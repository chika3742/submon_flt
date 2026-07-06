# コードベース リファクタリング提案

全体的なメンテナンス性向上を目的とした、コードベース全体のリファクタリング提案です。
規模（コスト）は度外視してよいという前提で、意味のある範囲をすべて挙げています。

現状の把握として、このコードベースは #173（Riverpod 導入による状態管理の書き直し）以降、
「Riverpod + feature-first（`lib/features/`）+ Repository パターン」への移行の**途中**にあります。
`features/auth` はモデル・ユースケース・プレゼンテーションが分離されたきれいなお手本になっており、
本提案の多くは「auth で確立したパターンを残りの領域へ展開し、移行を完了させる」ことに帰着します。

---

## 優先度サマリー

| # | 提案 | 効果 | リスク | 規模 |
|---|------|------|--------|------|
| 1 | デッドコード・死蔵ファイルの削除 | 高 | 低 | 小 |
| 2 | テスト基盤の整備（現状テストは実質ゼロ） | 高 | 低 | 中〜大 |
| 3 | go_router 導入（型付きルート・EventBus 廃止） | 高 | 中 | 中 |
| 4 | main.dart の分割（bootstrap / theme / router / effects） | 中 | 低 | 小 |
| 5 | feature-first 構成への移行完了（timetable / digestive） | 高 | 中 | 大 |
| 6 | 残存 StatefulWidget の Riverpod 移行完了 | 中 | 中 | 中 |
| 7 | データ層の一貫性向上（同期記述子・マイグレーション基盤） | 中 | 中 | 中 |
| 8 | `utils/`・UI ヘルパーの再編成 | 中 | 低 | 中 |
| 9 | Lint / analyzer の強化 | 中 | 低 | 小 |
| 10 | 文字列の一元管理（ARB による l10n 基盤） | 中 | 低 | 大 |
| 11 | CI の強化（format / build_runner 検証） | 中 | 低 | 小 |

---

## 1. デッドコード・死蔵ファイルの削除（最優先・低リスク）

もっとも費用対効果が高い作業です。Git 履歴に残るため、削除して問題ありません。

### 全行コメントアウトされたファイル（合計 1,200 行超）

- `lib/pages/memorize_card/camera_preview_page.dart` — **835 行全部**コメントアウト
- `lib/pages/home_tabs/tab_memorize_card.dart` — **334 行全部**コメントアウト
- `lib/utils/card_side_builder.dart` — **44 行全部**コメントアウト

### 実装のないスタブページ（暗記カード機能の残骸）

- `lib/pages/memorize_card/card_forum_page.dart` / `card_graph_page.dart` /
  `card_test_page.dart` / `card_view_page.dart` / `memorize_card_create_page.dart`
  （各 15〜23 行のスタブ。どこからも import されていない）
- `lib/utils/text_recognized_candidate_painter.dart`（カメラページ専用 → 死蔵）
- `lib/isar_db/isar_memorization_card_group.dart` と、`core_providers.dart:30` の
  `MemorizationCardGroupSchema` 登録
  （※ Isar スキーマの削除は既存ローカル DB との互換に注意。スキーマ登録だけ残す判断もあり得るが、
  その場合はコメントで理由を明記する）
- `lib/main.dart:369-374` のコメントアウトされたルート定義

### どこからも参照されていないファイル

- `lib/models/twitter_sign_in_result.dart` — Twitter ログインは廃止済みで参照ゼロ
- `lib/models/sign_in_result.dart` — 参照ゼロ（auth 機能は `features/auth/models/` に移行済み）

### Canvas LMS の残骸（copilot-instructions.md でも「削除予定」と明記）

- `Submission.canvasPlannableId`（`lib/isar_db/isar_submission.dart`）
  - Firestore 側のデータ互換があるため、削除する場合は `schemaVersion` を上げて
    マイグレーションで落とすか、「フィールドは残すが deprecated」と明記するかを決める。

### そのほかの小物

- `lib/main.dart:383` — `CupertinoPageRoute(title: "asdf")` というプレースホルダーが残存
- `test/widget_test.dart` — Flutter テンプレートの**カウンターアプリ用テストがそのまま**残っており、
  本アプリに対して意味を成さない（§2 で置き換え）

### ついでに発見したバグ（リファクタリングではないが記録）

`lib/isar_db/isar_submission.dart` の `Submission()` コンストラクタ:

```dart
final nextDate = DateTime.now()..add(const Duration(days: 1)).toLocal();
```

カスケード演算子 `..` のため `add()` の戻り値が捨てられ、`nextDate` は「明日」ではなく「今日」になります
（`DateTime` はイミュータブル）。デフォルト締切が意図と 1 日ずれている可能性が高いです。
これは §2 のテスト整備で真っ先に検出できる種類のバグであり、テスト不足の証左でもあります。

---

## 2. テスト基盤の整備（現状は実質ゼロ）

現状、`flutter test` で走るのはテンプレート由来のカウンターテスト 1 本のみで、
アプリの実挙動を守っているテストは存在しません。Riverpod 移行によって
DI（`ProviderScope.overrides`）が全面的に使えるようになった今が整備の好機です。

### 2-1. 純粋ロジックのユニットテスト（すぐ書ける）

- `hasRemoteChanges()`（`providers/firestore_providers.dart:240`）
- `getRemainingString()` / `getRemainingDateColor()`（`utils/ui.dart`）
- `createNewSubmissionForTimetable()` の締切計算・`TimeOfDayToMinutes`（`utils/utils.dart`）
- `Submission` / `Digestive` / `Timetable` 各モデルの `toMap()` / `fromMap()` 往復
  （§1 のバグのような問題を検出する）

### 2-2. Notifier / UseCase のテスト

`ProviderContainer` + `overrides` で、`DataSyncService`・`SignInStateNotifier`・
各 UseCase の状態遷移をテストする。Firestore は `fake_cloud_firestore`、
Isar はインメモリインスタンス（`Isar.open(directory: '')` 相当）で代替可能。

### 2-3. Widget テスト / golden テスト

`SubmissionListItem`・`Timetable` など、ロジックを含む表示コンポーネントから着手。

### 2-4. 進め方

リファクタリングの各フェーズの**前**に、対象領域の characterization test（現状の挙動を固定するテスト）
を書いてから着手する。これにより後続のすべての提案のリスクが下がります。

---

## 3. ナビゲーションの近代化: go_router 導入

現状の課題（`lib/main.dart` / `lib/pages/home_page.dart`）:

- `onGenerateRoute` + `settings.arguments as XxxArguments` の**非型安全なキャスト**が 10 箇所以上
- タブ切り替えが `EventBus`（`SwitchBottomNav`）経由で、`home_page.dart:134` では
  **25ms 間隔の `Timer.periodic` ポーリング**で Navigator の準備を待つというフラジャイルな実装
- ボトムナビが手製のネスト `Navigator` + 文字列パス（`"home"` / `"digestive"` / …）で管理されている
- ディープリンク処理（`link_handler/`）がルーティングと別系統

copilot-instructions.md にも「go_router 導入時に EventBus を置き換える」と既に方針が
書かれています。提案:

1. `go_router` + `go_router_builder`（コード生成による型付きルート）を導入
2. ボトムナビは `StatefulShellRoute.indexedStack` に置き換え
   → ネスト Navigator・`_scrollControllers` の手動管理・`Timer.periodic` ポーリング・EventBus が全廃可能
3. 各ページの `static const routeName` + `XxxPageArguments` クラスを型付きルートに置換
4. `link_handler/` のディープリンクを go_router の `redirect` / ルート定義に統合
5. `firebaseUserProvider` を監視する `redirect` で「未ログイン → WelcomePage」の遷移を宣言的にする
   （現在 `main.dart:175-179` の `ref.listen` + `backToWelcomePage()` で命令的に行っている処理）

タブパスの文字列リテラル（`"home"` 等）は、go_router 導入前の暫定処置としても
enum 化しておく価値があります。

---

## 4. `main.dart`（446 行）の分割

現在 `main.dart` に混在している責務を分離します:

```
lib/app/
├── bootstrap.dart   ← main() の初期化処理（Firebase, dotenv, AdMob, ライセンス登録）
├── app.dart         ← Application ウィジェット本体
├── theme.dart       ← TextTheme / ThemeData / PageTransitionsTheme
├── router.dart      ← ルート定義（§3 実施後は go_router 設定）
└── app_effects.dart ← ref.listen 群（下記）
```

特に `_ApplicationState.build()` 内の **6 つの `ref.listen`**（メール認証・認証アクション・
提出物保存・Firestore エラー・リンクイベント・ログアウト検知）は、
「グローバルな状態変化 → SnackBar / モーダル / 遷移」という横断的関心事なので、
feature ごとのリスナー Widget（例: `AuthEffectsListener`、`SyncErrorListener`）に切り出し、
`MaterialApp.builder` あるいは `Application` 直下で合成する構成にすると、
main.dart が肥大化せず、feature 追加時の変更箇所も分散しません。

---

## 5. feature-first 構成への移行完了

現状はディレクトリ構成が新旧混在しています:

```
lib/
├── features/            ← 新: auth / google_tasks / submission（一部）
├── pages/               ← 旧: 画面がフラットに 30 ファイル弱
├── components/          ← 旧: feature 固有 Widget と汎用 Widget が混在
├── ui_components/       ← 旧: 汎用 Widget（components/ との棲み分けが不明瞭）
├── providers/           ← 旧: feature 横断でプロバイダが集約
├── repositories/        ← 旧
├── isar_db/             ← モデル
├── models/              ← ほぼ死蔵（§1）
└── utils/               ← 雑多（§8）
```

`features/auth` の層構造（models / repositories / use_cases / presentation）を規範として、
以下を段階的に移設します:

- `features/submission/` — `pages/submission_*`、`components/submissions/*`、
  `providers/submission_providers.dart`、`repositories/submission_repository.dart`
- `features/timetable/` — `pages/timetable_*`、`pages/home_tabs/tab_timetable*`、
  `components/timetable/*`、`providers/timetable_providers.dart`、timetable 系 repository 3 種
- `features/digestive/` — digestive 系一式 + `pages/focus_timer_page.dart`
- `features/settings/` — `pages/settings*`
- 横断層は `core/`（`pref_key.dart` は既にここ）へ:
  `providers/core_providers.dart`・`firebase_providers.dart`・`firestore_providers.dart`・
  `data_sync_service.dart` → `core/providers/` または `core/sync/`
- `components/` と `ui_components/` は統合し、**feature 非依存の汎用 Widget だけ**を
  `core/widgets/`（または `shared/widgets/`）に残す

move 自体は機械的ですが、`prefer_relative_imports` 運用のため import 書き換えが広範囲に
及びます。IDE のリファクタリング機能で feature 単位に分割して行うのが安全です。

あわせて、この移行の完了形（ディレクトリ規約・層の依存方向）を
`.github/copilot-instructions.md` か `docs/architecture.md` に明文化しておくと、
以後の実装（人間・AI とも）が迷いません。

---

## 6. 残存 StatefulWidget の Riverpod 移行完了

`extends StatefulWidget` が 15 ファイル、`setState` 呼び出しが 119 箇所残っています
（うち数ファイルは §1 で削除される暗記カード関連）。

- `pages/settings/timetable.dart:40`・`pages/settings/functions.dart:45` には
  `// TODO: hooksを使ってbuild関数内で完結できるようにする` が残っています。
  方針を決めるべきポイント:
  - **案 A**: `hooks_riverpod` + `flutter_hooks` を導入し、`initState` での fetch →
    `useEffect` / `ref.watch(futureProvider)` に置き換える
  - **案 B（推奨）**: hooks を導入せず、「初期値の取得」は `FutureProvider` /
    `AsyncNotifier` に寄せ、Widget は `AsyncValue` を watch するだけにする。
    依存が増えず、既存の auth 系 Notifier パターンとも一貫する。
- `TimetableSettingsPage` のように「`initState` で Firestore から読んで `setState`、
  エラー処理も Widget 内」というページは、Notifier に寄せることで
  `home_page.dart:380` の `_handleSyncError` と同種のエラー処理を §7 の共通機構に統合できる。
- ローカル UI 状態のみの StatefulWidget（`color_picker_dialog.dart` 等）は無理に変えない。
  「アプリ状態は Riverpod、一時的な UI 状態は StatefulWidget で可」という基準を明文化する。

---

## 7. データ層の一貫性向上

`SyncedRepository<T>` は良い抽象です。その上でさらに:

### 7-1. DataSyncService の fetch 処理の宣言化

`data_sync_service.dart:56-107` は、コレクションごとに
「`firestoreCollectionProvider` 取得 → `Future.wait` → インデックス参照 → fromMap → putAll」を
手書きしており、`results[0]`〜`results[3]` の添字対応が暗黙です。
コレクションごとの同期記述子に畳み込みます:

```dart
class SyncTarget<T> {
  final String collectionId;
  final List<T> Function(QuerySnapshot<Map<String, dynamic>>) parse;
  final Future<void> Function(Isar, List<T>) putAll;
}
```

timetable の cells 展開のような特殊ケースも `parse` に閉じ込められ、
新しいコレクション追加時の変更箇所が 1 箇所になります。

### 7-2. マイグレーション基盤

`_migrate()`（`data_sync_service.dart:174-266`）は `if (oldVersion == 4) {...}; if (oldVersion == 5) {...}`
のベタ書きで、バージョンが増えるたびにメソッドが伸びます。

```dart
abstract class FirestoreMigration {
  int get fromVersion;
  Future<void> apply(MigrationContext ctx);
}
const migrations = [MigrationV4toV5(), MigrationV5toV6(), ...];
```

の形にし、1 マイグレーション = 1 ファイル + 1 テストを規約化します。
`(snapshot.data() as dynamic)?["schemaVersion"]`（`data_sync_service.dart:149`）のような
dynamic 経由のアクセスもこの際に排除します。

### 7-3. シリアライズの整理

- 各 Isar モデルの手書き `toMap()` / `fromMap()` には、旧スキーマ互換の防御コード
  （例: `map["done"] is bool ? map["done"] : map["done"] == 1`）が現行コードに混入しています。
  旧形式の変換は §7-2 のマイグレーション側に移し、モデルの fromMap は現行スキーマのみを扱う。
- `UserConfig` は既に freezed + json_serializable 化されているので、Isar モデルの
  Firestore 変換も `json_serializable` に寄せる（Isar の `@Collection` と共存可能）ことで
  手書きの詰め替えミスを型レベルで防げます。
- `schemaVersion` 定数は `core_providers.dart` ではなく `core/constants.dart` 等へ移動。

### 7-4. timetable 系 repository の方針明記

`TimetableRepository`（149 行・独自同期）と `SyncedRepository` 系の使い分けは
コードからは読み取りにくいため、`SyncedRepository` へ統合できないか検討し、
できない場合はその理由（cells がドキュメント内 Map であること等）を基底クラスの doc comment に残す。

---

## 8. `utils/` と UI ヘルパーの再編成

`lib/utils/ui.dart`（419 行）が SnackBar・ダイアログ・BottomSheet・日付整形・色計算・
さらには `TextFormFieldBottomSheet` という **Widget クラスまで**含む grab-bag になっています。

```
lib/core/
├── presentation/
│   ├── snackbar.dart          ← showSnackBar / showMaterialBanner
│   ├── dialogs.dart           ← showSimpleDialog / showLoadingModal / showSelectSheet
│   ├── bottom_sheets.dart     ← showRoundedBottomSheet / showRoundedDraggableBottomSheet
│   └── remaining_time.dart    ← getRemainingString / getRemainingDateColor
├── widgets/
│   └── text_form_field_bottom_sheet.dart
└── extensions/
    ├── date_time.dart         ← getWeekdayString → DateTime/int 拡張, TimeOfDayToMinutes
    └── color.dart             ← BlendToCardColor
```

- `utils/utils.dart` の `createNewSubmissionForTimetable()` は Navigator 呼び出しを含む
  feature ロジックなので `features/timetable/`（または submission）の use_case へ。
- `getTimetableCellId()` の `period * 6 + weekday` はマジックナンバー `6` に名前を付ける
  （`maxWeekdays` 等）か、timetable feature 内の値オブジェクトへ。
- `utils/types.dart` の `typedef Restorable` は「Undo 用の復元クロージャ」という意図が
  名前から読み取りにくいので、doc comment を付けるか `UndoOperation` 等に改名。
- ダイアログ系 API の `Function?` 型コールバック（`showSimpleDialog` の `onOKPressed`）は
  `VoidCallback?` / `Future<void> Function()?` に型を締める。

---

## 9. Lint / analyzer の強化

現在は `flutter_lints` + 個別ルール 13 個。移行が進んだ今、静的解析を強化して
「新しく書くコードが旧パターンに戻らない」ようにガードします。

```yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
```

- `strict-casts` は `settings.arguments as XxxArguments` や
  `(snapshot.data() as dynamic)` のような箇所を炙り出します（§3 / §7 と連動）。
- `strict-raw-types` は `Future<AsyncValue>`（`notifier_state_guard.dart` 利用側）のような
  raw 型を検出します。
- 追加候補ルール: `unnecessary_lambdas`, `avoid_dynamic_calls`, `cast_nullable_to_non_nullable`,
  `no_self_assignments`, `unnecessary_statements`, `prefer_asserts_with_message`
- 一括導入すると警告が大量に出るため、`# TODO` 付きで段階的に有効化するか、
  ベースラインを切ってから進める。

---

## 10. ユーザー向け文字列の一元管理（l10n 基盤）

UI 文字列は全ファイルに日本語ハードコードで散在しています（copilot-instructions.md にも
「ARB 未導入」と明記）。多言語化の予定がなくても、以下の理由で ARB 化に価値があります:

- 文言変更が 1 箇所で済み、表記ゆれ（「。」有無、全角半角）を防げる
- `auth_messages.dart` で始めた「メッセージの一元化」の完成形になる
- Widget テストで文言変更のたびにテストが壊れる問題を、キー参照で緩和できる

`flutter gen-l10n`（`l10n.yaml` + `app_ja.arb`）を導入し、feature 移行（§5）と同じ単位で
段階的に置き換えるのが現実的です。規模は大きいものの完全に機械的な作業です。

---

## 11. CI の強化

`test.yaml` は analyze + test のみ。以下を追加:

1. `dart format --set-exit-if-changed .`（フォーマット検証）
2. `./scripts/build_runner.sh` 実行後に `git diff --exit-code`
   （**生成コードのコミット漏れ検出**。freezed / riverpod_generator / Isar / Pigeon を
   多用しているこのリポジトリでは特に有効）
3. `flutter test --coverage` + カバレッジの可視化（§2 の定着を測る）
4. （任意）`custom_lint` CLI 実行 — analyzer plugin のルールは
   `flutter analyze` に出ない環境があるため、CI での担保を確認する

---

## 推奨ロードマップ

依存関係を考慮した実施順です。各フェーズは独立して PR にできます。

1. **Phase 0 — 掃除**（§1, §9 の analyzer 設定, §11）
   デッドコード削除・壊れたテストの撤去・CI 強化。リスクほぼゼロで見通しが一気に良くなる。
2. **Phase 1 — テストの足場**（§2 の 2-1, 2-2）
   純粋ロジックと主要 Notifier の characterization test。以降の全フェーズの保険。
3. **Phase 2 — main.dart 分割 + go_router**（§4 → §3）
   分割してから go_router を入れると差分がレビューしやすい。EventBus・ポーリング撤去。
4. **Phase 3 — feature-first 移行完了**（§5, §6, §8）
   timetable → digestive → settings の順に、テストを書きながら 1 feature ずつ。
5. **Phase 4 — データ層**（§7）
   同期記述子・マイグレーション基盤・シリアライズ整理。
6. **Phase 5 — l10n**（§10）
   機械的作業なので最後にまとめて、あるいは Phase 3 と並走。

---

*この提案は 2026-07-06 時点の `main`（11856f5）を対象に作成。*
