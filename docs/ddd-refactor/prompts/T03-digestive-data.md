# T03 — digestive: feature 切り出しとレイヤー違反の解消

## 文脈
`submon_flt` の DDD 移行タスク。前提: `docs/ddd-refactor/00-analysis.md` / `01-roadmap.md`、**T00 完了済み**。
手本は `features/auth/` と、T01/T02 で整えた `features/submission/`。

このタスクは **問題 P2（レイヤー違反）の解消** を含む最重要ケース:
- `lib/providers/digestive_providers.dart`（データ層）が
  `lib/pages/home_tabs/tab_digestive_list.dart`（UI層）を import している。
- ドメインモデル `DigestiveWithSubmission` が **page ファイル内に定義** されている。

## ゴール
digestive のデータ層を `features/digestive/` に切り出し、レイヤー違反を解消する。

## やること
### 1. ドメインモデルの救出
- `DigestiveWithSubmission`（現在 `pages/home_tabs/tab_digestive_list.dart` 内）を
  `features/digestive/models/` へ移す。これにより data 層が UI を import する必要がなくなる。

### 2. 移設
- `lib/isar_db/isar_digestive.dart`（`Digestive` エンティティ）→ `features/digestive/models/`
- `lib/repositories/digestive_repository.dart` → `features/digestive/repositories/`
- `lib/providers/digestive_providers.dart`（repository DI + クエリ Stream + `undoneDigestivesWithSubmission` の結合ロジック）
  → repository DI は `repositories/` へ、submission と結合する `undoneDigestivesWithSubmission` は
  digestive 側の use_case もしくは repository クエリへ整理（submission feature の公開クエリを参照する形）。

### 3. レイヤー違反の最終確認
- `features/digestive/repositories/` や `providers` 相当が `pages/` / `components/` / `presentation/` を
  import していないことを確認（`grep` で `import .*pages` を検査）。

### 4. 仕上げ
- 参照箇所（`pages/home_tabs/tab_digestive_list.dart`, `components/digestive_*`, submission detail からの参照等）の import 更新。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- `DigestiveWithSubmission` が models 層にあり、data→UI の依存が消えている。
- digestive のデータ層が `features/digestive/` 配下にあり、旧 `repositories/digestive_repository.dart`・
  `isar_db/isar_digestive.dart`・`providers/digestive_providers.dart` が削除されている。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(digestive): T03 extract digestive data layer and fix layer violation`

## スコープ外
- digestive UI 移設と編集ロジック抽出 → **T04**。
