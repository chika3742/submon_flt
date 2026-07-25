# T10 — settings: 設定 feature の整理と user_config 集約

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、**T05・T09 完了済み**。

設定は `lib/pages/settings/`（general/customize/functions/google_tasks/account_link/account_edit/timetable）、
`lib/pages/settings_page.dart`、`lib/user_config.dart`（freezed のユーザー設定モデル）に分散している。

## ゴール
`features/settings/` を整理し、ユーザー設定モデルと設定 UI を集約する。各設定が他 feature に固有なものは
その feature へ、横断的なものは settings feature に置く。

## やること
### 1. user_config の配置
- `lib/user_config.dart`（+ `user_config.g.dart` / `user_config.freezed.dart`）を `features/settings/models/` へ。
  ただし sync(T09) や各 feature が広く参照するため、依存関係を確認し、
  横断モデルなら `lib/core/` 配置も検討（T00 の規約に従って決定）。

### 2. 設定 UI の振り分け
- `pages/settings/google_tasks.dart` → `features/google_tasks/presentation/`（既存 feature へ）
- `pages/settings/account_link.dart` / `account_edit_page.dart` → `features/auth/presentation/`
- `pages/settings/timetable.dart` の timetable 固有部分 → `features/timetable/presentation/`（T06 で未移設なら）
- `pages/settings/{general,customize,functions}.dart` と `settings_page.dart` → `features/settings/presentation/`

### 3. ロジック整理
- 設定の読み書きが pref/user_config を直叩きしている箇所は repository/notifier 経由に整理（最小変更）。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- 設定 UI が各 feature へ適切に振り分けられ、`pages/settings/` と `pages/settings_page.dart` が空になり削除済み。
- `user_config` が規約に沿った場所にあり、参照が壊れていない。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(settings): T10 distribute settings UI and consolidate user config`
