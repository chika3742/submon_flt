# T09 — sync: 同期 feature 切り出しと migration の分離

## 文脈
`submon_flt` の DDD 移行タスク。前提: `00-analysis.md` / `01-roadmap.md`、
**T01・T03・T05 完了済み**（submission/digestive/timetable のデータ層が feature 化されていること）。

`lib/providers/data_sync_service.dart`（279行）は Firestore→Isar の全件同期と、
スキーマ migration（`_migrate`、バージョン 4→7 の変換ロジック）を **1クラスに混載** している。
複数ドメインのエンティティを直接組み立てており、ドメイン境界をまたぐ典型的な「アプリケーションサービス」。

## ゴール
`features/sync/` を切り出し、同期サービスと migration を分離する。

## やること
### 1. 移設
- `lib/providers/data_sync_service.dart` → `features/sync/`（service もしくは use_case 層）。
- `SchemaVersionMismatchException` → `features/sync/models/`。

### 2. 責務分離
- `DataSyncService` から **スキーマ migration ロジック（`_migrate` / `_runMigrationIfNeeded`）を別クラス**
  （例 `FirestoreSchemaMigrator`）へ抽出。同期サービスは「migration を呼ぶ」だけにする。
- 各ドメインのエンティティ復元（`Submission.fromMap` 等）は、可能なら **各 feature の repository/mapper を経由** させ、
  sync サービスがドメイン内部のシリアライズ詳細を直接知らない形に近づける（T01/T03/T05 で用意した mapper を活用）。
  難しい部分は無理をせず、まず「クラス分割と feature 移設」を確実に行う。

### 3. Firestore 同期ヘルパの整理
- `lib/providers/firestore_providers.dart` のうち同期に固有の部分があれば sync feature 側へ。
  汎用 Firestore ラッパは T00 の `infrastructure/` に残す。

### 4. 仕上げ
- 呼び出し元（アプリ起動フロー、ログイン後の fetch 等）の import 更新。
- `dart run build_runner build --delete-conflicting-outputs`。

## 完了条件 (DoD)
- `features/sync/` に同期サービスと migration が分離配置され、`providers/data_sync_service.dart` が削除済み。
- migration ロジックが独立クラスになっている。
- `flutter analyze` クリーン、生成物コミット済み、**同期・migration の挙動が不変**。
- コミット例: `refactor(sync): T09 extract sync feature and separate schema migration`

## 注意
- migration はユーザーデータに関わる **最もリスクの高い領域**。バージョン分岐（4/5/6）の処理順・
  Firestore 書き込み内容を 1 バイトも変えないこと。純粋な構造移動に徹する。
