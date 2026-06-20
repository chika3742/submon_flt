# Submon ドメイン駆動リファクタリング — 問題点分析とターゲットアーキテクチャ

このドキュメントは、`submon_flt` (Flutter / Riverpod / Isar / Firebase) を
ドメイン駆動・feature-first 構造へ段階的に移行するための前提資料である。
具体的な作業手順は [`01-roadmap.md`](./01-roadmap.md)、各作業のセッション用プロンプトは
[`prompts/`](./prompts/) を参照。

---

## 1. 現状サマリ

コードベースは **feature-first 構造への移行が途中** で止まっている。

### 移行済み（理想形に近い）
`lib/features/<feature>/` 配下に以下のサブレイヤーを持つ規約が既に存在する。

| サブレイヤー       | 役割                                            |
|------------------|------------------------------------------------|
| `models/`        | ドメインモデル・値オブジェクト・例外 (freezed)      |
| `repositories/`  | データアクセス（永続化・外部I/O）                   |
| `services/`      | 外部サービス連携（例: Google Tasks API）           |
| `use_cases/`     | アプリケーションロジック（repo/service を協調）      |
| `presentation/`  | Riverpod StateNotifier（UI 状態）                 |

- `features/auth/` … 最も完成度が高い（models/presentation/use_cases/repositories 揃い）
- `features/google_tasks/` … models/presentation/repositories/services 揃い
- `features/submission/` … **use_cases と presentation のみ**。repository・エンティティ・クエリ・UI はレガシー側に残存

### 未移行（レガシー構造）

| ディレクトリ            | ファイル数 | 内容と問題                                              |
|----------------------|----------|------------------------------------------------------|
| `lib/providers/`     | 12 (手書き) | infra・repository生成・クエリ・サービス・use_case が混在 |
| `lib/repositories/`  | 6        | `SyncedRepository` 基底 + submission/digestive/timetable×3 |
| `lib/isar_db/`       | 6 (エンティティ) | Isar エンティティがドメインモデル兼 Firestore DTO       |
| `lib/pages/`         | 33       | 画面単位。ビジネスロジックが混在                          |
| `lib/components/`    | 13       | UI 部品。保存/検証ロジックが混在                          |
| `lib/models/`        | 2        | 旧 sign-in 結果モデル（auth へ集約候補）                  |
| `lib/utils/` `lib/core/` `lib/ui_components/` | — | 横断的関心事（一部は妥当、一部は再配置候補）   |

---

## 2. 問題点（DDD/レイヤリング観点）

### P1. 構造の二重化・一貫性の欠如
`features/` と レガシー (`providers/` 等) が並存し、同一ドメインが両側にまたがる。
特に **submission** は use_case/presentation が `features/`、repository/entity/query/UI がレガシーと分裂しており、
新規参加者がどちらの規約に従うべきか判断できない。

### P2. レイヤー違反（依存方向の逆転）
- `lib/providers/digestive_providers.dart`（**データ層**）が
  `lib/pages/home_tabs/tab_digestive_list.dart`（**UI層**）を import している。
- ドメインモデルであるべき `DigestiveWithSubmission` が **page ファイル内に定義** されている。
- 依存が「UI → application → domain ← data」という一方向になっておらず、循環の温床。

### P3. `providers/` ディレクトリの責務過多
`lib/providers/` 1か所に、
(a) インフラ初期化 (`firebase_providers`, `firestore_providers`, `core_providers`, `pref_provider`)、
(b) repository のDIワイヤリング、
(c) クエリ用 Stream provider、
(d) サービス (`data_sync_service` 279行)、
(e) use_case (`timetable_providers` 内の `TimetableEditUseCase`)
が同居している。ドメイン境界もレイヤー境界も表現されていない。

### P4. ドメインモデルと永続化モデル（DTO）の未分離
`isar_db/` のエンティティが Isar コレクション・`toMap`/`fromMap` による Firestore シリアライズ・
ドメイン振る舞いを一身に背負っている。永続化の都合（Isar アノテーション、Firestore のキー名、
スキーマ migration）がドメイン表現に漏れ出している。

### P5. UI にビジネスロジックが流出
`components/submissions/submission_editor.dart`（385行）が、
入力検証・繰り返し設定・Google Tasks 同期判定・保存・各種 tips バナー副作用・analytics ログを直接保持。
「保存とは何か」というユースケースが UI に埋没している。

### P6. 未移行ドメインの放置
**digestive / timetable / data-sync / account-settings** は feature 化されていない。
なお **memorize_card** は機能としてほぼ全てがコメントアウト済みのデッドコードであり、
feature 化せず **移行の過程で完全に削除する**（[`prompts/T07-remove-memorize-card.md`](./prompts/T07-remove-memorize-card.md)）。

### P7. 横断的関心事の不透明な結合
`events.dart` の `EventBus` によるグローバルなイベント配信（main / home_page / memorize_card 間）が、
Riverpod のデータフローと二重化している。状態の出所が追いにくい。

---

## 3. ターゲットアーキテクチャ

**既存の `features/` 規約を正とし、それに全ドメインを揃える。** 新しい命名規約は発明しない
（移行コストと学習コストを最小化するため）。レイヤー命名は既存の
`models / repositories / services / use_cases / presentation` を踏襲する。

```
lib/
  app/                      # アプリ起動・ルーティング・テーマ（main から分離）
  core/                     # 純粋な横断要素: 共通型, 拡張, 定数, pref_key
  infrastructure/           # 技術的詳細の初期化（旧 providers の (a)）
    firebase_providers.dart
    firestore_providers.dart
    isar/ (core_providers の isar 部分)
    pref/ (pref_provider)
  features/
    <feature>/
      models/               # ドメインモデル・値オブジェクト・例外（永続化非依存が理想）
      repositories/         # データアクセス + DTO/mapper + DIプロバイダ
      services/             # 外部サービス連携（任意）
      use_cases/            # アプリケーションロジック + DIプロバイダ
      presentation/
        notifiers/          # Riverpod StateNotifier
        pages/              # 画面
        components/         # その feature 専用 UI 部品
  ui_components/            # 真に汎用な UI 部品（feature 非依存のみ残す）
```

### 依存方向のルール（lint で強制する）
```
presentation ──▶ use_cases ──▶ repositories/services ──▶ models
                    └──────────────────────────────────▶ models
infrastructure は features から参照可。features → infrastructure の逆は不可。
features 間の参照は原則禁止（例外: 明示的に公開された use_case のみ）。
data/repository 層が presentation 層を import することは禁止（P2 の再発防止）。
```

### ドメイン境界（feature 一覧）
| feature        | 含むもの                                                          |
|----------------|-----------------------------------------------------------------|
| `auth`         | 認証・アカウント連携（移行済み、`lib/models/*sign_in*` を集約）       |
| `submission`   | 提出物 CRUD・共有リンク・Google Tasks 同期トリガ（完成させる）         |
| `digestive`    | 消化（学習タスク分割）・submission 結合ビュー                         |
| `timetable`    | 時間割テーブル/セル/時限・undo-redo                                  |
| ~~`memorize_card`~~ | **削除対象**（デッドコード。feature 化しない）                    |
| `google_tasks` | Google Tasks 連携（移行済み）                                       |
| `sync`         | Firestore↔Isar 同期・スキーマ migration（data_sync_service 由来）   |
| `settings`     | ユーザー設定・user_config・各 settings ページ                        |

---

## 4. 移行の指針

1. **ストラングラー・フィグ方式**: 一度に全置換しない。feature 単位で「新構造へ移し、旧参照を貼り替え、旧ファイルを削除」を完結させる。
2. **各タスクは独立してビルド・テスト可能な状態で終える**（`flutter analyze` がクリーン、`*.g.dart`/`*.freezed.dart` 再生成済み）。
3. **コード生成**: provider/freezed の移動後は必ず
   `dart run build_runner build --delete-conflicting-outputs` を実行する。
4. **挙動を変えない**: リファクタリングであり機能変更ではない。ロジック抽出時も入出力を保つ。
5. **import 境界の検証**: P2 のような違反を再発させない。Phase 終盤で依存方向 lint を導入する。

---

## 5. リスク・注意点

- **Isar スキーマ変更は破壊的**: エンティティ（`@collection`）の構造・名前・順序を変えると既存ローカルDBが壊れる。
  ドメイン/DTO 分離（P4）は **エンティティのフィールド構造を変えずに** mapper を追加する形で行う（移動・改名のみ、構造変更は別タスク）。
- **Firestore の `toMap`/`fromMap` キー名は変更不可**（サーバ互換）。mapper 抽出時もキー文字列はそのまま。
- **コード生成ファイル** (`*.g.dart`, `*.freezed.dart`) は手で編集しない。移動後は再生成。
- **riverpod の `part` 宣言とファイルパス**: provider を別ファイルへ移すと生成物のパスも変わる。import を全て追従させる。
