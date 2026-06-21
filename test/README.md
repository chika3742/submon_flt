# テストガイド（安全網テスト）

DDD 移行（T01〜）に先立つ**回帰検出の安全網**です。目的は「テストが存在すること」ではなく
**「移行で挙動が変わったとき確実に落ちること」**。`fvm flutter test` が全グリーンであることを保ちます。

> 背景・方針は [`docs/ddd-refactor/prompts/TS-test-safety-net.md`](../docs/ddd-refactor/prompts/TS-test-safety-net.md) を参照。

## 実行方法

```sh
fvm flutter test
fvm flutter test --coverage   # 参考: 行カバレッジ
```

> 注: `pubspec.yaml` が `.env` をアセット宣言しているため、テストビルドには（gitignore 済みの）
> `.env` ファイルが必要です。CI/ローカルで存在しない場合は空ファイルを作成してください
> （`touch .env`）。本番の値はコミットしません。

## ディレクトリ構成

feature 構造をミラーしています。

| パス | 対象 |
|------|------|
| `test/isar_db/` | エンティティの `toMap`/`fromMap` シリアライズ・ゴールデンテスト |
| `test/features/submission/use_cases/` | Save/Delete Submission use_case |
| `test/features/auth/use_cases/` | auth 系 use_case（email_link / social / link_social / sign_out / complete_sign_in） |
| `test/features/auth/models/` | `AuthErrorCode` の Firebase エラー写像 |
| `test/providers/` | migration 変換（純粋関数）/ `TimetableEditUseCase` / `UndoRedo` |
| `test/utils/` | 純粋ユーティリティ |

## カバーしている範囲（監査で確認済み）

- **シリアライズ不変条件**: 全エンティティの `toMap` キー名を直書きで固定（Firestore 互換キーの変更/タイポを検出）、
  `fromMap(toMap())` 往復、`due`/`startAt` の UTC↔ローカル往復、`Submission.repeat` enum 往復、
  `Submission.done` の bool/int 後方互換。
- **use_case の分岐網羅**: 永続化（create/update）分岐、Google Tasks 同期分岐（addTask/updateTask/連携無効）、
  削除と `Restorable`（元に戻す）経路、auth の mode/provider ルーティングとキャンセル・例外伝播、
  `createTaskFromSubmission` の Task 写像内容まで検証。
- **migration 変換（v4→v5）**: per-document 変換（`detail→details`/`date→due`/`done`・`important` の `1→bool`/
  `id→period`/cells `tableId=-1`）と旧キー削除をフィールド単位で固定。`SchemaVersionMismatchException` も確認。
- **状態ロジック**: `UndoRedo` の undo/redo スタック遷移（push で redo クリア等）。
- **純粋ユーティリティ**: `partition` 境界、`range` の例外、`TimeOfDay` 拡張、`Distinguish` など。

## 意図的に対象外とした範囲

| 対象外 | 理由 |
|--------|------|
| widget / 統合テスト全般 | `main()` の Firebase/dotenv/Ads 初期化と `isarProvider` 実 open で `pumpWidget` が起動不能。banner 表示・pop タイミング等の UI ロジックは widget に埋もれており、抽出（T02 等）まで検証不能。move-only・手動確認に委ねる。 |
| `DataSyncService._migrate` / `_runMigrationIfNeeded` のオーケストレーション | バージョン段階適用・`timetable/main`→`-1` コピー&削除・batch 構築コミット・`>schemaVersion` 例外は Firestore I/O と Riverpod `ref` に密結合。本タスクでは per-document 変換のみ純粋関数化してテストし、組み立て層は手動確認に委ねる。 |
| `BatchOperation.commit` | FirebaseFirestore の batch I/O。純粋部分（`partition`）のみテスト。 |
| `Digestive.fromMap` / `Submission.important` の int→bool | これらは `fromMap` では **bool 専用**（int→bool 変換は migration 側のみ）。`Submission.done` だけが両対応という production 側の非対称であり、テストで int を渡すと現状仕様では失敗する。挙動変更を伴うため本タスク（テスト追加のみ）では対象外。 |

> 上記は網羅性のエージェント監査で「ギャップ」として報告されたが、いずれも本タスクのスコープ
> （テスト追加のみ・Firestore I/O を伴う層は除外・挙動不変）に基づき意図的に対象外としたもの。
