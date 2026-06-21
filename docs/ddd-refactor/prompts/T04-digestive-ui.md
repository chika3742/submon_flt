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

## T03 から繰越の tech debt（本タスクで対応）
T03（#188）のレビューで指摘された、移設のため挙動不変としてあえて残した負債。T04 で UI を触る際に解消する。

1. **`DigestiveWithSubmission` を継承から composition へ**
   （`lib/features/digestive/models/digestive_with_submission.dart`）
   - 現状 `class DigestiveWithSubmission extends Digestive` かつ `final Digestive digestive` も保持しており、
     同じデータを二重に持つ。`Digestive` に `late` フィールドが増えると `fromObject` の更新漏れで
     `LateInitializationError` が潜在。`@Collection` 型でないサブクラスが `isar.digestives.put()` に渡ると
     Isar 実装依存の挙動になりうる。
   - 修正: `extends Digestive` をやめ、`final Digestive digestive` / `final Submission? submission` を持つ
     純粋な composition に変更。併せて呼び出し側（`DigestiveDetailCard(digestive: e)` →
     `DigestiveDetailCard(digestive: e.digestive)` 等）を更新する。
2. **use_case の Isar 直アクセスを `SubmissionRepository` 経由へ**
   （`lib/features/digestive/use_cases/undone_digestives_with_submission.dart` の
   `await isar.submissions.getAll(ids)`）
   - use_case が `SubmissionRepository` を介さず Isar の `submissions` コレクションへ直アクセスしており、
     依存方向ルール（`use_cases → repositories`）と features 間参照の原則に反する過渡的妥協。
   - 解消が T04 時点で難しい場合は、最低限 TODO コメント（英語）を残し追跡する。submission feature が
     公開する取得経路（repository/クエリ）が整い次第そちらへ寄せる。

## スコープ外
- timetable / memorize_card（別タスク）。
