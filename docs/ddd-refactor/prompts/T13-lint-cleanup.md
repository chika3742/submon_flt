# T13 — 仕上げ: 新規 lint ルールへの全面準拠（既存違反の解消）

## 文脈
`submon_flt` の DDD 移行タスクの **最終タスク**。前提: `00-analysis.md` / `01-roadmap.md`、
**T00〜T12 完了済み**（全ドメインが `features/` へ移行済み、または削除済み）。

`analysis_options.yaml` には新しい lint ルール群が導入済みだが、**コードベース全体はまだ準拠していない**。
各移行タスクの DoD は「新規 warning を増やさない」であり、**既存の違反バックログは残ったまま**。
このタスクで、それらを一掃して `flutter analyze` を完全にクリーンにする。

### 対象の lint（`analysis_options.yaml`）
- `linter.rules`:
  `prefer_final_fields` / `prefer_double_quotes` / `always_declare_return_types` /
  `avoid_void_async` / `prefer_final_locals` / `eol_at_end_of_file` / `prefer_relative_imports` /
  `directives_ordering` / `unawaited_futures` / `discarded_futures` / `use_named_constants` /
  `unnecessary_parenthesis` / `prefer_const_declarations`
- プラグイン: `riverpod_lint` / `better_require_trailing_commas`
- `analyzer.exclude`: `lib/**.g.dart` / `lib/**.freezed.dart`（生成物は対象外）

## やること
### 1. 現状把握
- `fvm flutter analyze`（または `./scripts/build_runner.sh` 後に analyze）を実行し、
  違反の **全件リスト** を取得する。ルール別に件数を集計し、修正方針を分類する。

### 2. 機械的に修正できるものを優先
- `dart fix --apply` で自動修正可能な lint（`directives_ordering`, `prefer_relative_imports`,
  `unnecessary_parenthesis`, `eol_at_end_of_file`, `prefer_final_locals` 等）をまず一括適用。
- `dart format` は **プロジェクト方針に従う**（既存スタイルを壊さない範囲で。
  `better_require_trailing_commas` 対応のため末尾カンマ補完が必要な箇所のみ手当て）。

### 3. 手動対応が要るものを修正
- `discarded_futures` / `unawaited_futures`: 意図的な fire-and-forget は `unawaited(...)` で明示。
  待つべき箇所は `await` を追加（**挙動を変えないか必ず確認**。非同期化で順序が変わる箇所は要注意）。
- `avoid_void_async`: `void` の非同期メソッドを `Future<void>` へ。呼び出し側の整合性を確認。
- `always_declare_return_types`: 戻り値型を明示。
- `prefer_final_fields` / `prefer_const_declarations` / `use_named_constants`: 該当箇所を修正。
- riverpod_lint の指摘（provider の誤用・依存漏れ等）を解消。

### 4. `// ignore` の扱い
- 既存の抑制コメント（例: `data_sync_service.dart` の
  `// ignore_for_file: only_use_keep_alive_inside_keep_alive`）は、
  T09 で sync feature へ移設済みのはず。移設先で **本当に必要か再評価** し、
  不要なら除去、必要なら理由をコメントで残す。
- 新たに `// ignore` で握りつぶすのは原則禁止。やむを得ない場合のみ、**1行 ignore + 理由コメント** に限定する
  （ファイル全体の `ignore_for_file` で広く無効化しない）。

### 5. 分割コミット
- ルール単位、または機能領域単位で **小さくコミット** する（巨大な単一コミットにしない）。
  例: `style: apply directives_ordering and prefer_relative_imports across codebase`、
  `fix: address discarded_futures warnings`。

## 完了条件 (DoD)
- `fvm flutter analyze` が **完全にクリーン**（warning / error / info ゼロ。生成物除く）。
- 挙動不変（特に `discarded_futures` / `avoid_void_async` 対応で非同期の待ち合わせを変えていないこと）。
- 不要な `// ignore` が増えていない。残した ignore には理由コメントがある。
- `dart run build_runner build --delete-conflicting-outputs` 後も analyze がクリーン。

## 注意
- **生成物（`*.g.dart` / `*.freezed.dart`）は触らない**（analyzer から除外済み）。lint 対象は手書きコードのみ。
- 自動修正後は必ず差分をレビューし、意図しない挙動変更（特に非同期周り）が混入していないか確認する。
- このタスクは全 feature に横断的に触れるため、**他タスク（T01〜T12）が全て完了してから** 着手する
  （途中だと移設で違反が再発し二度手間になる）。
