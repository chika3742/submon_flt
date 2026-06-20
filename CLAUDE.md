# CLAUDE.md

このファイルは Claude Code / Copilot 等が本リポジトリで作業する際のアーキテクチャ規約をまとめたものです。
詳細な背景と移行計画は [`docs/ddd-refactor/`](docs/ddd-refactor/) を参照してください
（特に [`00-analysis.md`](docs/ddd-refactor/00-analysis.md) 第3節「ターゲットアーキテクチャ」と
[`01-roadmap.md`](docs/ddd-refactor/01-roadmap.md)）。

ビルド・実行・コード生成の具体的なコマンドは [`.github/copilot-instructions.md`](.github/copilot-instructions.md)
に詳しくあります。本ファイルは「どこに何を書くか」というレイヤリング規約に焦点を当てます。

## アーキテクチャ概要

Submon は **feature-first / ドメイン駆動** 構造へ移行中です。
新しい命名規約は発明せず、既存の `lib/features/` 規約を正とします。
最も完成度の高い手本は [`lib/features/auth/`](lib/features/auth/) です。

```
lib/
  infrastructure/   # 技術基盤の初期化（ドメイン非依存）
  features/
    <feature>/
      models/         # ドメインモデル・値オブジェクト・例外（freezed）
      repositories/   # データアクセス（永続化・外部I/O）+ DTO/mapper + DI provider
      services/       # 外部サービス連携（任意。例: Google Tasks API）
      use_cases/      # アプリケーションロジック（repo/service を協調）+ DI provider
      presentation/   # Riverpod Notifier・ページ・その feature 専用 UI 部品
  core/             # 純粋な横断要素（共通型・拡張・定数・pref_key）
  providers/        # 【レガシー】未移行のドメイン provider。順次 features/ へ移設中
  ...               # pages/ components/ repositories/ isar_db/ 等もレガシー、移行対象
```

### 各レイヤーの責務

| レイヤー         | 責務                                                         |
|-----------------|-------------------------------------------------------------|
| `models/`       | ドメインモデル・値オブジェクト・例外（freezed）。永続化非依存が理想 |
| `repositories/` | データアクセス（Isar/Firestore 永続化・外部I/O）、DTO/mapper、DI provider |
| `services/`     | 外部サービス連携（Google Tasks API 等）                        |
| `use_cases/`    | アプリケーションロジック。repository/service を協調させる        |
| `presentation/` | Riverpod Notifier（UI 状態）、ページ、feature 専用 UI 部品      |

## `infrastructure/` レイヤー

ドメインに属さない**技術基盤の provider** を [`lib/infrastructure/`](lib/infrastructure/) に集約します。
現状（フラット構成）:

- `firebase_providers.dart` — FirebaseAuth / Firestore / Crashlytics / Analytics 等の DI
- `firestore_providers.dart` — Firestore コレクション/ユーザー設定の汎用ラッパ
- `core_providers.dart` — Isar 初期化・schemaVersion・GoogleSignIn・各種 Pigeon API 等
- `pref_provider.dart` — SharedPreferences ラッパ（`PrefNotifier<T>`）
- `firestore_error_notifier.dart` — Firestore エラーのストリーム配信

> 将来的に `00-analysis.md` 第3節の目標図に沿って `isar/`・`pref/` 等へサブ分割する余地がありますが、
> 現時点ではフラット構成です。

## 依存方向のルール

```
presentation ──▶ use_cases ──▶ repositories/services ──▶ models
                    └──────────────────────────────────▶ models
```

- **`features → infrastructure` は可。逆（`infrastructure → features`）は不可。**
- **features 間の参照は原則禁止**（例外: 明示的に公開された use_case のみ）。
- **data/repository 層が presentation 層を import することは禁止。**
  （過去に `providers`(データ層) → `pages`(UI層) の逆転依存があった。再発防止）

> 注: レガシー `lib/providers/` や移行途中の `infrastructure/` には、
> まだ上記ルールを満たさない過渡的な依存（例: `infrastructure → user_config`）が残っています。
> これらは feature 移設タスク（T01 以降）で順次解消します。
> 依存方向の **自動 lint 強制** は T12 で導入予定です。

## コード生成

provider（riverpod_generator）・freezed・json_serializable・Isar スキーマはコード生成に依存します。
provider/freezed を移動・変更したら必ず再生成してください。

```sh
# FVM 利用が前提（.fvmrc で Flutter バージョンを固定）
fvm dart run build_runner build --delete-conflicting-outputs
# または
./scripts/build_runner.sh
```

- 生成物（`*.g.dart` / `*.freezed.dart`）は**手で編集しない**。
- provider を別ファイルへ移すと `part` 宣言と生成物のパスも変わるため、import を全て追従させること。
- 静的解析は `fvm flutter analyze` がクリーンであること（新規 warning/error を増やさない）。

## 移行の指針

1. **ストラングラー・フィグ方式**: 一度に全置換せず、feature 単位で「新構造へ移し → 旧参照を貼り替え → 旧ファイルを削除」を完結させる。
2. 各タスクは**独立してビルド・テスト可能**な状態で終える（analyze クリーン、生成物再生成済み）。
3. **挙動を変えない**: リファクタリングであり機能変更ではない。
4. **Isar スキーマは破壊的変更に注意**: `@collection` の構造・順序を変えると既存ローカル DB が壊れる。
   ドメイン/DTO 分離は mapper 追加で行い、エンティティのフィールド構造は変えない。
5. **Firestore の `toMap`/`fromMap` キー名は変更不可**（サーバ互換）。
