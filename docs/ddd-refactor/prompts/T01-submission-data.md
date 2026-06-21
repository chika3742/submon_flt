# T01 — submission: データ層を feature へ集約 + DTO/mapper 分離

## 文脈
`submon_flt` の DDD 移行タスク。前提に `docs/ddd-refactor/00-analysis.md` / `01-roadmap.md`、
完了済みの **T00**（`infrastructure/` 集約）。手本は `lib/features/auth/`。
submission は現在 **分裂状態**: use_case と presentation は `lib/features/submission/` にあるが、
repository・エンティティ・クエリ provider はレガシー側に残っている。この分裂を解消する。

## ゴール
submission の **データ層** を `lib/features/submission/` に集約し、ドメインモデルと永続化 DTO を分離する。

## やること
### 1. 移設
以下を `lib/features/submission/` 配下の適切なレイヤーへ移設:
- `lib/repositories/submission_repository.dart` → `features/submission/repositories/`
- `lib/isar_db/isar_submission.dart`（`Submission` エンティティ）→ `features/submission/models/`
- `lib/providers/submission_providers.dart`（repository DI + クエリ Stream provider）→
  repository DI は `repositories/` の provider へ、クエリ Stream は `repositories/` または専用の
  `submission_queries.dart` へ整理。
- `lib/providers/submission_share_link_provider.dart` → `features/submission/`（共有リンク用 service/repository）。
- 共通基底 `lib/repositories/synced_repository.dart` は **複数 feature が依存** するため、
  `lib/infrastructure/`（または `lib/core/`）へ置く。判断は T00 の規約に従う。

### 2. ドメイン / DTO 分離（構造は変えない）
- `Submission` の `toMap`/`fromMap`（Firestore シリアライズ）を **mapper として分離**する余地を作る。
  ただし **Isar の `@collection` フィールド構造・順序・名前、Firestore のキー文字列は一切変更しない**
  （既存DB・サーバ互換のため）。今回は「ファイルの所属を正す + mapper の置き場所を用意する」に留め、
  破壊的なスキーマ変更はしない。

### 3. 参照の貼り替え
- `Submission` / `submissionRepositoryProvider` / 各クエリ provider を参照している全箇所
  （`pages/`, `components/`, `features/submission/use_cases/`, `digestive` 関連等）の import を新パスへ更新。
- `dart run build_runner build --delete-conflicting-outputs` を実行。

## 完了条件 (DoD)
- submission のデータ層が `features/submission/` 配下に存在し、`lib/repositories/submission_repository.dart`・
  `lib/isar_db/isar_submission.dart`・`lib/providers/submission_providers.dart` が削除されている。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(submission): T01 consolidate submission data layer into feature`

## スコープ外
- UI（pages/components）の移設と `submission_editor` ロジック抽出 → **T02**。
- Isar スキーマのフィールド構造変更。
