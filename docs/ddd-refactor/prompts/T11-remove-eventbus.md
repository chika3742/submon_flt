# T11 — 横断: EventBus を Riverpod へ置換し撤去

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、**T07 完了済み**
（memorize_card 削除済み。元は EventBus の主要利用元だったため、削除後に着手すると残存イベントが減る）。

`lib/events.dart` の `EventBus` が `main.dart` / `pages/home_page.dart` 等で
グローバルにイベント配信しており、Riverpod のデータフローと二重化している（問題 P7）。状態の出所が追えない。

## ゴール
EventBus による通信を Riverpod（Notifier / StreamProvider）へ置換し、`events.dart` を撤去する。

## やること
### 1. 調査
- `events.dart` が定義する各イベント型と、その publish/subscribe 箇所を洗い出す
  （`grep` で `eventBus` / イベントクラス名）。
- 各イベントが「何のドメインの、どの状態変化」を表すか分類する。

### 2. 置換
- 各イベントを、対応する feature の Notifier の状態変化、または Riverpod の
  `StreamProvider` / `ref.listen` による購読へ置き換える。
- グローバル単一の `EventBus` インスタンスへの依存を排除する。

### 3. 撤去
- `lib/events.dart` を削除し、`main.dart` の初期化、各 page の subscribe/dispose を除去。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- `lib/events.dart` が削除され、`eventBus` への参照がゼロ（`grep` で確認）。
- 旧 EventBus が担っていた画面更新挙動が Riverpod 経由で **同等に再現** されている。
- `flutter analyze` クリーン、生成物コミット済み、挙動不変。
- コミット例: `refactor(core): T11 replace EventBus with Riverpod streams`

## 注意
- イベント駆動の更新タイミング（即時/遅延）を変えると体感が変わる。購読の発火タイミングを合わせること。
