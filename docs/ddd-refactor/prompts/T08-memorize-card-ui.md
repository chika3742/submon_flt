# T08 — memorize_card: UI 移設

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、**T07 完了済み**（データ層新設済み）。

## ゴール
memorize_card の UI を `features/memorize_card/presentation/` に移設する。

## やること
### 1. UI 移設（6ページ + タブ）
- `lib/pages/memorize_card/card_view_page.dart`
- `lib/pages/memorize_card/memorize_card_create_page.dart`
- `lib/pages/memorize_card/camera_preview_page.dart`（835行 — 最大。カメラ/OCR ロジックを含むため慎重に）
- `lib/pages/memorize_card/card_forum_page.dart`
- `lib/pages/memorize_card/card_graph_page.dart`
- `lib/pages/memorize_card/card_test_page.dart`
- `lib/pages/home_tabs/tab_memorize_card.dart`

### 2. ロジック整理
- `camera_preview_page.dart` の OCR / テキスト認識ロジックのうち、UI 非依存の処理は
  use_case かドメインサービスへ抽出する余地を検討（**リスクが高ければ最小移設に留める**）。
- カードのデータ操作は T07 の repository 経由に統一。
- `utils/text_recognized_candidate_painter.dart` 等 memorize 専用の util は feature 配下へ寄せる。

### 3. 仕上げ
- ルーティング・タブ・`home_page` からの参照 import 更新。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- memorize_card UI が `features/memorize_card/presentation/` 配下にあり、旧 `pages/memorize_card/`・
  `pages/home_tabs/tab_memorize_card.dart` が削除済み。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(memorize_card): T08 move memorize card UI into presentation layer`

## 注意
- `camera_preview_page.dart` はプラットフォームチャネル/カメラ依存が強い。移設で import パスがずれやすいので
  ビルドを丁寧に確認すること。
