# T07 — memorize_card: 関連機能の完全削除

## 文脈
`submon_flt` の DDD 移行タスク。前提に `docs/ddd-refactor/00-analysis.md` / `01-roadmap.md`。
**方針変更**: memorize_card（暗記カード）機能は **feature へ移行せず、移行の過程で完全に削除する**。

### 現状（調査済み・低リスク）
memorize_card は既にほぼ全てが **コメントアウト済みのデッドコード**:
- `lib/pages/memorize_card/camera_preview_page.dart`(835行)・`lib/pages/home_tabs/tab_memorize_card.dart`(334行)・
  `lib/utils/card_side_builder.dart` は **100% コメントアウト**。
- 残り 5 ページ（`card_view_page` / `card_forum_page` / `card_graph_page` / `card_test_page` /
  `memorize_card_create_page`）は中身が空の Scaffold スタブ。
- `events.dart` に memorize 関連イベントは **存在しない**（参照はコメント内のみ）。
- camera / ML / Vision 系の依存は `pubspec.yaml` から **既に除去済み**。
- **唯一のアクティブな実依存**は `lib/providers/core_providers.dart` の Isar スキーマ登録
  （`MemorizationCardGroupSchema` と `isar_memorization_card_group.dart` の import）。

このタスクは独立性が高く、**T00 完了後の早い段階で単独実施** してよい（後続タスクのスコープを縮小できる）。

## やること
### 1. ファイル削除
- `lib/pages/memorize_card/`（6 ファイル全て）
- `lib/pages/home_tabs/tab_memorize_card.dart`
- `lib/isar_db/isar_memorization_card_group.dart` および生成物 `isar_memorization_card_group.g.dart`
- `lib/utils/card_side_builder.dart`
- 次の util は **memorize_card 専用かを `grep` で確認した上で** 削除（他から参照が無ければ削除、あれば残す）:
  - `lib/utils/text_recognized_candidate_painter.dart`
  - `lib/utils/point.dart`

### 2. アクティブコードの編集
- `lib/providers/core_providers.dart`:
  - `import "../isar_db/isar_memorization_card_group.dart";` を削除。
  - `Isar.open([...])` のスキーマリストから `MemorizationCardGroupSchema,` を削除。
- `lib/main.dart`: memorize_card 関連のコメントアウト済みルート定義を削除（クリーンアップ）。
- `lib/pages/home_page.dart`: memorize_card / `BottomNavItemId.memorizeCard` 関連のコメントアウト済み参照を削除。
- `BottomNavItemId` enum の定義箇所を特定し、`memorizeCard` の値が残っていて
  **どこからも使われていなければ** 削除する（使われている場合は影響を確認）。
- `assets/`（`pubspec.yaml` の assets）に memorize_card 専用画像があれば削除を検討（任意・要確認）。

### 3. 再生成・検証
- `dart run build_runner build --delete-conflicting-outputs` を実行（`core_providers.g.dart` 更新、削除した `.g.dart` の掃除）。
- `flutter analyze` クリーン。
- `grep -rin "memoriz\|MemorizationCard\|card_side\|TextRecognizedCandidate" lib --include=*.dart` で
  **残存参照ゼロ** を確認（生成物含む）。

## Isar スキーマに関する注意
- スキーマリストから `MemorizationCardGroupSchema` を外すのは **安全**。Isar は該当コレクションを開かなくなるだけで、
  既存の他コレクションのデータには影響しない。**DB migration は不要**。
- `core_providers.dart` の `const schemaVersion = 7` は **Firestore のスキーマバージョン**（`data_sync_service` の
  migration 用）であり、Isar とは無関係。**変更しないこと**。

## 完了条件 (DoD)
- memorize_card 関連のファイル・参照・Isar スキーマ登録が全て削除されている（`grep` で残存ゼロ）。
- `flutter analyze` クリーン、`build_runner` 成功、生成物コミット済み。
- アプリが問題なくビルドでき、他機能の挙動は不変。
- コミット例: `refactor(memorize_card): T07 remove memorize card feature entirely`
