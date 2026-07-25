# TS — テスト安全網の整備（リファクタ前提タスク）

## 文脈
`submon_flt` の DDD 移行に先立つ **安全網タスク**。前提資料 `00-analysis.md` / `01-roadmap.md` /
`02-review.md`（レビュー指摘）を読むこと。共通方針は `_TEMPLATE.md` 参照。

このリポジトリには **実テストが事実上存在しない**（`test/widget_test.dart` はデフォルトのカウンタ
smoke test で、存在しないカウンタを参照しており壊れている）。一方で各移行タスクの DoD は
「挙動を変えない」と称しているが、それを機械的に検証する手段が無い。
本タスクで、**テスト可能な層に回帰検出の安全網を張る**。これにより T01〜T06 / T09 の「挙動不変」が
初めて検証可能になる。

### テスタビリティの実態（調査済み）
- **書ける**: use_case はコンストラクタ DI のプレーンクラス（例 `SaveSubmissionUseCase(repo, tasksRepo, uid)`）。
  リポジトリ/サービスをモックすれば Firebase/Isar 無しで単体テスト可能。エンティティの `toMap`/`fromMap` は純粋関数。
- **書けない（本タスクの対象外）**: アプリ全体の widget test。`main()` が `Firebase.initializeApp()` /
  `dotenv.load()` / `GoogleSignIn.initialize()` / `MobileAds.initialize()` を直叩きし、`Application` は
  `isarProvider`（実 Isar open）/`firebaseUserProvider` を watch するため、`pumpWidget(Application())` は起動しない。
  banner 表示条件・pop タイミング等の UI ロジックは widget に埋もれており、**抽出（T02 等）するまでテスト不能**。
  → これらは本タスクで無理に扱わない。「move only・手動確認」に委ねる旨を docs に残す。

## ゴール
テスト可能な範囲に、移行で壊れたら気づける回帰テストを用意し、`flutter test` がグリーンになる状態を作る。
**本タスクは原則テストの追加のみ。プロダクションコードは変更しない**（例外: 後述の壊れた widget_test 置換、
およびテストのために最小限必要な可視性変更があれば最小に留める）。

## やること

### 0. テスト基盤の準備
- `pubspec.yaml` の `dev_dependencies` に `mocktail` を追加（`flutter pub add --dev mocktail`）。
- 壊れた `test/widget_test.dart` を**削除または意味のあるテストに置換**する（カウンタ test は無意味）。
- テストは feature 構造にミラーした `test/features/...`, `test/models/...` 等に配置する。

### 1. シリアライズのゴールデンテスト（最優先・モック不要）
**Firestore キー名は不変という最重要不変条件を固定する。** 対象エンティティ:
`Submission` / `Digestive` / `Timetable` / `TimetableTable` / `TimetableClassTime`
（`lib/isar_db/*.dart`）。各々について:
- `toMap()` が返すキー集合と値を**明示的にアサート**する（キー名のタイポ/変更を検出するため、`containsPair`
  でキー名を直書きする。`toMap().keys` を変数経由で比較するだけにしない）。
- `fromMap(toMap())` のラウンドトリップで全フィールドが保存されることを確認。
- 型の揺れに対する後方互換を確認（例: `Submission.fromMap` は `done` が `bool` でも `1/0` でも解釈する。
  両方のケースをテスト）。
- 日付の UTC 変換（`toUtc().toIso8601String()` ↔ `parse().toLocal()`）の往復一致。

### 2. use_case の単体テスト（mocktail）
リポジトリ/サービスを `Mock` で差し替え、**分岐を網羅**する。対象と最低限カバーすべき分岐:
- `SaveSubmissionUseCase`（`features/submission/use_cases/save_submission_use_case.dart`）
  - `id == null` → `create` が呼ばれる / `id != null` → `update` が呼ばれる
  - `writeGoogleTasks == false` → Tasks API を呼ばない
  - `writeGoogleTasks == true` かつ `googleTasksTaskId == null` → `addTask` → 返り値を `update` で保存
  - `writeGoogleTasks == true` かつ `googleTasksTaskId != null` → `updateTask`
  - `_tasksRepo == null`（連携無効）時に落ちないこと
- `DeleteSubmissionUseCase`（同 `delete_submission_use_case.dart`）
  - 対象が存在しない → `ArgumentError`
  - digestive の削除（`deleteBySubmissionId`）が呼ばれ、戻り値が restore に使われる
  - `googleTasksTaskId` 有り/無し、`_tasksRepo` 無しの分岐（ログのみで例外を投げない）
  - 返される `Restorable` を実行すると create / `createAll` / Tasks 再作成が走ること
- `auth` の 5 use_case（`complete_sign_in` / `email_link_auth` / `link_social` / `sign_out` / `social_auth`）
  - 各々の成功パスと、`AuthException` 系のエラーマッピングを最低1ケース。
- `TimetableEditUseCase`（現状 `lib/providers/timetable_providers.dart` 内）
  - `undo` / `redo` がスナップショット空のとき何もしない
  - `pushUndoSnapshot` → `undo` で `restoreSnapshot` が正しい snapshot で呼ばれる
  - `clearTable` が undo スナップショットを積んでからクリアする
  - `UndoRedoHandler` はモック可能なインターフェースなのでこれを差し替える。

### 3. migration のゴールデンテスト（最高リスク・重点）
`DataSyncService._migrate`（`lib/providers/data_sync_service.dart`、schemaVersion 4→7）。
- これは**ユーザーデータ移行コードで最も壊すと痛い箇所**。テスト容易性が低ければ、まず
  **`_migrate` のデータ変換部分を純粋関数として切り出せるか**を検討する（切り出しは挙動不変の最小リファクタとして許容。
  ただし変換結果は1バイトも変えないこと）。
- 既知の v4 形式 Firestore ドキュメント（`detail`/`date`/`done==1` 等の旧スキーマ）を入力し、
  期待される v5+ 形式（`details`/`due`/`done:bool` 等）への変換を**フィールド単位でアサート**する。
- バージョン分岐（4→5、5→6、6→7）が順に適用されること、`schemaVersion > 7` で
  `SchemaVersionMismatchException` を投げることを確認。
- Firestore I/O はモック（`mocktail`）。`BatchOperation` の生成内容を検証する。

### 4. 純粋ユーティリティ（余力があれば）
`date_time_utils.dart` / `batch_operation.dart` / `distinguish.dart` の純粋ロジックに最低限の単体テスト。

### 5. 実行・確認
- `fvm flutter test` が**全てグリーン**。`fvm flutter analyze` がクリーン。
- カバレッジ参考値として `fvm flutter test --coverage` を取得（**行カバレッジ率は目安**。本質は下記の分岐網羅）。

---

## 6. ★ テストケース網羅性のエージェント検証（必須手順）★
テストを一通り書いたら、**別のサブエージェントに網羅性を監査させる**。行カバレッジ率だけでは
「分岐は通ったが結果を assert していない」テストを見逃すため、独立した目で穴を洗い出す。

**手順:**
1. サブエージェント（`general-purpose` 等）を起動し、次を指示する:
   > あなたはテストレビュアです。以下の各 "テスト対象" を**実装ファイルから独立に精読**し、
   > 取り得る分岐・エッジケース・不変条件を**自前で列挙**してください。その上で、私が書いた
   > テストファイル（`test/...`）と突き合わせ、**カバーされている項目／抜けている項目**を
   > 対象ごとの表（分岐 × テスト有無）で報告してください。特に次を重点的に確認:
   > - use_case の全分岐（if/switch/null 分岐）に対応する assert があるか
   > - シリアライズの**キー名**が直書きで固定されているか（キー変更を検出できるか）
   > - migration の各バージョン分岐と例外パスが網羅されているか
   > - 「呼ばれたこと」だけでなく「正しい引数で呼ばれたこと」「戻り値・状態」まで検証しているか
   > - 後方互換ケース（`done` の bool/int 揺れ等）が抜けていないか
   > 対象ファイルと対応テストのパスは以下: （ここに列挙）
   > ファイルは読むだけで変更しないこと。ギャップ一覧のみ返すこと。
2. エージェントが報告したギャップを精査し、**妥当なものを埋める**（テストを追加）。
   偽陽性（対象外と判断したもの）は理由を添えて `02-review.md` 追補か PR 説明に残す。
3. ギャップを埋めたら **再度同じエージェント（または新規）に再監査させ**、重大な抜けが無いことを確認する。
4. 最終的に「監査で確認した網羅範囲」と「意図的に対象外とした範囲（UI ロジック等）」を
   `test/README.md`（新規）に短くまとめる。

> 注: このエージェント検証は **`code-review` スキルや単なるカバレッジ％では代替しない**。
> 目的は「テストが存在するか」ではなく「**移行で挙動が変わったとき確実に落ちるか**」の担保。

## 完了条件 (DoD)
- `fvm flutter test` 全グリーン、`fvm flutter analyze` クリーン。
- 上記 1〜3（シリアライズ／use_case／migration）が網羅的にテストされている。
- **網羅性のエージェント監査を実施し、報告されたギャップを解消（または対象外理由を記録）済み**。
- 壊れた `widget_test.dart` が除去・置換されている。
- プロダクションコードを（許容された最小限を除き）変更していない。
- `test/README.md` に網羅範囲と対象外範囲が記載されている。
- コミット例: `test: add safety-net tests for serialization, use cases and migration`

## スコープ外
- widget / 統合テスト全般（インフラ初期化の重さと UI ロジック未抽出のため。T02 等で抽出後に別途）。
- プロダクションコードのリファクタ（migration 変換の純粋関数化を除く。それも挙動不変の範囲のみ）。
