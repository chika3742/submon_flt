# T00 — 基盤: アーキ規約の明文化と `infrastructure/` 集約

## 文脈
リポジトリ `submon_flt`（Flutter / Riverpod v3 / Isar Community / Firebase / freezed）を
ドメイン駆動・feature-first 構造へ移行する取り組みの **最初のタスク** です。
作業前に `docs/ddd-refactor/00-analysis.md` と `docs/ddd-refactor/01-roadmap.md` を必ず読んでください。
既存の `lib/features/auth/` が手本となる完成形です。

## ゴール
1. アーキテクチャ規約をリポジトリに明文化する。
2. ドメインに属さない**技術インフラ系 provider** を `lib/infrastructure/` に集約し、
   `lib/providers/` からドメイン非依存の基盤を分離する。

## やること
### 1. 規約の明文化
- リポジトリ直下に `CLAUDE.md` を新規作成（または追記）し、以下を記載:
  - feature 配下のレイヤー構成（`models/repositories/services/use_cases/presentation`）と各責務。
  - 依存方向ルール（`presentation → use_cases → repositories/services → models`、
    `features → infrastructure` のみ可、data/repository 層は presentation を import しない）。
  - コード生成手順（`dart run build_runner build --delete-conflicting-outputs`）。
  - `00-analysis.md` 第3節「ターゲットアーキテクチャ」を要約して参照リンクを貼る。

### 2. `infrastructure/` への集約
- `lib/infrastructure/` を新設し、以下の **ドメイン非依存の基盤 provider** を移設:
  - `lib/providers/firebase_providers.dart`
  - `lib/providers/firestore_providers.dart`（Firestore コレクション/設定の汎用ラッパ部分）
  - `lib/providers/core_providers.dart` のうち Isar 初期化など技術基盤に該当する部分
  - `lib/providers/pref_provider.dart`（SharedPreferences ラッパ）
  - `lib/providers/firestore_error_notifier.dart`
- 移設に伴い `part` ディレクティブのパス、全 import を追従。
- `dart run build_runner build --delete-conflicting-outputs` を実行し生成物を更新。

> 注意: `core_providers.dart` にドメイン固有のものが混ざっている場合は **無理に動かさず**、
> 技術基盤のみ抽出する。判断に迷うものは `lib/providers/` に残し、後続タスクで各 feature が引き取る。

### 3. 検証
- `flutter analyze` がクリーンであること。
- アプリのエントリポイント (`main.dart`) からの参照が壊れていないこと。

## 完了条件 (DoD)
- `CLAUDE.md` に規約が書かれている。
- インフラ系 provider が `lib/infrastructure/` 配下にあり、旧パスへの import が残っていない。
- `flutter analyze` クリーン、生成物コミット済み。
- コミットメッセージ例: `refactor(infra): T00 establish architecture convention and infrastructure layer`

## スコープ外（やらないこと）
- ドメイン feature の移設（T01 以降）。
- 依存方向の **自動 lint 導入**（T12 で実施）。今回は規約の文章化まで。
