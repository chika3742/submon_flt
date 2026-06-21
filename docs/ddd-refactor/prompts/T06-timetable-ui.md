# T06 — timetable: UI 移設

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、**T05 完了済み**（timetable データ層 feature 化済み）。

## ゴール
timetable の UI を `features/timetable/presentation/` に移設する。

## やること
### 1. UI 移設
- `lib/pages/timetable_edit_page.dart`
- `lib/pages/timetable_cell_edit_page.dart`
- `lib/pages/timetable_table_view_page.dart`
- `lib/pages/home_tabs/tab_timetable.dart`
- `lib/pages/home_tabs/tab_timetable_2.dart`
- `lib/components/timetable/*`（`timetable`, `timetable_day_list`, `open_modal_animation`）
- `lib/pages/settings/timetable.dart`（timetable 固有の設定。横断設定と混在する場合は timetable 関連分のみ移し、
  汎用設定枠は T10 の settings feature に委ねる）

### 2. ロジック確認
- グリッド編集・undo/redo 呼び出しが T05 で用意した use_case/notifier 経由になっているか確認。
  Widget 内に残った永続化直叩きがあれば use_case 経由へ寄せる（挙動不変・最小変更）。

### 3. 仕上げ
- ルーティング・タブ構成・設定ページからの参照 import 更新。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- timetable UI が `features/timetable/presentation/` 配下にあり、旧 `pages/timetable_*`・
  `pages/home_tabs/tab_timetable*`・`components/timetable/` が削除済み。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(timetable): T06 move timetable UI into presentation layer`

## スコープ外
- 汎用 settings の整理 → T10。
