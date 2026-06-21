# T05 — timetable: feature 切り出し（3 repository + undo/redo + use_case）

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、**T00 完了済み**。
手本は `features/submission/`（T01）。

timetable は 3 つのエンティティ（テーブル / セル / 時限）と undo-redo、既に存在する
`TimetableEditUseCase` を持つ、最も構造が複雑なドメイン。`lib/providers/timetable_providers.dart`（206行）に
repository DI・クエリ・`UndoRedo` notifier・use_case が **すべて同居** している。

## ゴール
timetable のデータ層・状態（undo/redo）・use_case を `features/timetable/` の各レイヤーへ分解配置する。

## やること
### 1. 移設（エンティティ → models）
- `lib/isar_db/isar_timetable.dart`（`Timetable` セル）
- `lib/isar_db/isar_timetable_table.dart`（`TimetableTable`）
- `lib/isar_db/isar_timetable_class_time.dart`（`TimetableClassTime`）
- `TimetableSnapshot` 型・`toCellIdMap` 拡張も models へ。

### 2. 移設（repository）
- `lib/repositories/timetable_repository.dart`
- `lib/repositories/timetable_table_repository.dart`
- `lib/repositories/timetable_class_time_repository.dart`
→ `features/timetable/repositories/`。DI provider もここへ。

### 3. `timetable_providers.dart` の分解
- repository DI provider → `repositories/`
- クエリ Stream（`timetableTables`, `classTimes`, `timetableCells`, `currentTimetable`）→ `repositories/`（クエリ）
- `UndoRedoHandler` インターフェース + `UndoRedo` notifier → `presentation/notifiers/`（UI 状態）か `use_cases/`。
  既存設計（テスト用にモック可能なインターフェース）を尊重して配置。
- `TimetableEditUseCase` + `timetableEditUseCaseProvider` → `use_cases/`

### 4. 仕上げ
- 参照箇所（timetable 関連 pages/components/settings）の import 更新。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- timetable のデータ層・use_case・undo状態が `features/timetable/` 配下に整理され、旧
  `repositories/timetable*`・`isar_db/isar_timetable*`・`providers/timetable_providers.dart` が削除済み。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変（undo/redo の動作を含む）。
- コミット例: `refactor(timetable): T05 extract timetable data, undo-redo and use case`

## スコープ外
- timetable UI（編集グリッド等）の移設 → **T06**。
