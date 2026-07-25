# T12 — 仕上げ: 依存境界の lint 導入と最終クリーンアップ

## 文脈
`submon_flt` の DDD 移行タスクの **最終フェーズ**。前提: `00-analysis.md` / `01-roadmap.md`、
**T02〜T11 完了済み**（全ドメインが `features/` へ移行済み）。

## ゴール
1. 依存方向ルールを **自動 lint で強制** し、P2 のようなレイヤー違反の再発を防ぐ。
2. 残存するレガシーディレクトリ・未使用コードを掃除する。
3. 規約ドキュメントを最終化する。

## やること
### 1. 依存境界 lint の導入
- `analysis_options.yaml` に import 境界チェックを追加する。選択肢:
  - Dart 標準の lint では層間 import 禁止を直接表現しづらいため、
    `custom_lint` + `riverpod_lint`（既に riverpod 利用）に加え、
    レイヤー違反検出ルール（例: data/repository 層が `presentation` を import しない、
    feature 間の直接 import 禁止）を導入する。
  - 軽量に済ませるなら、CI 用の **スクリプト**（`scripts/` に grep ベースの境界チェック）でも可。
    既存の `scripts/` ディレクトリを活用する。
- 最低限、以下を検出して fail させる:
  - `lib/features/*/repositories/` や同 data 層が `presentation` / `pages` / `components` を import。
  - `lib/infrastructure/` が `lib/features/` を import。
  - features 間の直接 import（明示的に許可した公開 use_case を除く）。

### 2. クリーンアップ
- 空になった旧ディレクトリ（`lib/providers/`, `lib/repositories/`, `lib/isar_db/`,
  `lib/pages/`, `lib/components/`, `lib/models/`）を削除（残骸がないか確認）。
- `lib/utils/` のうち特定 feature 専用のものを feature 配下へ寄せ、真に汎用なものだけ残す。
- `lib/ui_components/` は feature 非依存の汎用 UI のみ残す。
- 未使用 import・デッドコードの除去。

### 3. ドキュメント最終化
- `docs/ddd-refactor/00-analysis.md` の問題点が解消されたことを反映した
  `docs/ddd-refactor/99-result.md`（最終構造図・残課題）を作成。
- `CLAUDE.md` の規約を最新構造に合わせて更新。

## 完了条件 (DoD)
- 依存境界違反が CI/lint で検出される仕組みが入り、現状の違反がゼロ。
- レガシーディレクトリが消えている（`lib/features/` と `lib/{app,core,infrastructure,ui_components}` 中心の構成）。
- `flutter analyze` クリーン、`dart run build_runner build` 成功、テスト通過。
- コミット例: `chore(arch): T12 enforce dependency boundaries and final cleanup`

## 注意
- lint 導入で大量の既存違反が出た場合は、**まず検出を可視化**し、解消は範囲を区切って段階的に行う。
  全違反の一括修正を 1 コミットに詰め込まない。
