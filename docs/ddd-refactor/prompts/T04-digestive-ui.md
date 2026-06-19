# T04 — digestive: UI 移設と編集ロジック抽出

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、**T03 完了済み**（digestive データ層は feature 化済み）。
手本は `features/submission/presentation/`（T02 の成果）。

## ゴール
digestive の UI を `features/digestive/presentation/` に移設し、編集ロジックを抽出する。

## やること
### 1. UI 移設
- `lib/pages/home_tabs/tab_digestive_list.dart` → `features/digestive/presentation/`
  （`DigestiveWithSubmission` は T03 で models へ移済みなので参照のみ）。
- `lib/components/digestive_detail_card.dart` → `features/digestive/presentation/components/`
- `lib/components/digestive_edit_bottom_sheet.dart` → `features/digestive/presentation/components/`

### 2. ロジック抽出
- `digestive_edit_bottom_sheet.dart`（241行）の保存・検証・状態組み立てを
  use_case / notifier へ抽出（submission の `SaveSubmissionUseCase` / save notifier パターンに倣う）。
- `digestive_detail_card.dart` 内に永続化や完了トグル等のロジックがあれば repository/use_case 経由に統一。
- **挙動不変**。リスクの高い箇所は最小抽出に留める。

### 3. 仕上げ
- `home_page` / タブ構成からの参照 import を更新。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- digestive UI が `features/digestive/presentation/` 配下にあり、旧 `components/digestive_*`・
  `pages/home_tabs/tab_digestive_list.dart` が削除されている。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(digestive): T04 move digestive UI and extract edit logic`

## スコープ外
- timetable / memorize_card（別タスク）。
