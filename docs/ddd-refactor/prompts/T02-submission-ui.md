# T02 — submission: UI 移設と保存ロジックの抽出

## 文脈
`submon_flt` の DDD 移行タスク。前提: `docs/ddd-refactor/00-analysis.md` / `01-roadmap.md`、
**T00・T01 完了済み**（submission のデータ層は `features/submission/` に集約済み）。手本は `features/auth/`。

## ゴール
submission の UI を `features/submission/presentation/` に移設し、`submission_editor.dart`（385行）に
埋もれているビジネスロジックを use_case / notifier へ抽出する。

## やること
### 1. UI 移設
以下を `features/submission/presentation/{pages,components}/` へ移設し import を貼り替え:
- `lib/pages/submission_create_page.dart`
- `lib/pages/submission_edit_page.dart`
- `lib/pages/submission_detail_page.dart`
- `lib/pages/done_submissions_page.dart`
- `lib/components/submissions/*`（`submission_editor`, `submission_list`, `submission_list_item`,
  `submission_list_item_bottom_sheet`, `formatted_date_remaining`）

### 2. ロジック抽出（`submission_editor.dart`）
現在 Widget が直接持っている以下を、適切なレイヤーへ移す:
- **入力検証**（タイトル必須など）→ presentation の notifier か、ドメインのバリデーションへ。
- **繰り返し(Repeat)・時刻付与・色** の状態組み立て → そのままでも可だが、保存形の構築は notifier に集約。
- **保存フロー**（新規/更新判定・Google Tasks 同期判定）→ 既存 `SaveSubmissionUseCase` /
  `submissionSaveStateProvider` を活用。Widget からは「保存を依頼するだけ」にする。
- **副作用（tips バナー表示、analytics ログ）** → UI 起因の副作用はページ側に残してよいが、
  「保存が成功したら」という条件は notifier の状態を購読して判定する形に整理。
- ルーティング定数 (`routeName`) と画面遷移は presentation に残す。

> 重要: **挙動を完全に保つ**。バナーの出る条件、pop のタイミング、fire-and-forget 保存の挙動を変えない。
> 抽出はあくまで「責務の置き場所を正す」こと。リスクが高い箇所は無理に動かさず、最小の抽出に留めてよい。

### 3. 仕上げ
- `dart run build_runner build --delete-conflicting-outputs`。
- ルーティングテーブル（`main.dart` 等の `routes`）の参照を更新。

## 完了条件 (DoD)
- submission の UI が `features/submission/presentation/` 配下にあり、`lib/pages/submission_*`・
  `lib/components/submissions/` が削除されている。
- `submission_editor` から保存・検証ロジックが notifier/use_case 側へ移っている。
- `flutter analyze` クリーン、生成物コミット済み、**画面の挙動が不変**。
- コミット例: `refactor(submission): T02 move submission UI and extract save logic`

## スコープ外
- digestive/timetable など他 feature（別タスク）。
