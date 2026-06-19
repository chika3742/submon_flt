# T07 — memorize_card: feature 新設（repository から作る）

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、**T00 完了済み**。
手本は `features/submission/`（T01）と `features/timetable/`（T05）。

memorize_card は **最も未整備** のドメイン。repository が存在せず、Isar エンティティと UI が直結している。
このタスクでは欠けているデータ層を **新設** する。

## やること
### 1. 現状調査（最初に必ず実施）
- `lib/isar_db/isar_memorization_card_group.dart` のエンティティ構造を把握。
- `lib/pages/memorize_card/*` が Isar をどう直叩きしているか洗い出す（`grep` で `isar`/`MemorizationCardGroup` 参照箇所）。
- `lib/utils/card_side_builder.dart` の役割を確認（カード表裏の構築ロジック → ドメインに属する公算大）。
- `core_providers.dart` 内の memorize 関連 provider があれば確認。

### 2. データ層の新設
- `features/memorize_card/models/` に Isar エンティティ（`isar_memorization_card_group.dart`）を移設。
- `features/memorize_card/repositories/` に **新規 repository** を作成。既存の `SyncedRepository` 基底に
  倣う（Firestore 同期が必要かは現状の保存経路を見て判断。**新たな同期は足さない** — 現状の挙動を repository に閉じ込めるだけ）。
- カード表裏ロジック `card_side_builder.dart` は domain（models）かドメインサービスとして `features/memorize_card/` へ。

### 3. 参照の貼り替え
- UI からの Isar 直叩きを **新 repository 経由に置換**（このタスクの範囲では「データアクセスを repository に集約」まで。
  大規模な UI 改変は T08）。最小変更で挙動を保つ。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- `features/memorize_card/{models,repositories}` が存在し、Isar エンティティが移設済み。
- memorize_card のデータアクセスが repository に集約され、`isar_db/isar_memorization_card_group.dart` が削除済み。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(memorize_card): T07 introduce data layer and repository`

## スコープ外
- UI（6ページ + タブ）の移設 → **T08**。
- EventBus の置換 → T11。
