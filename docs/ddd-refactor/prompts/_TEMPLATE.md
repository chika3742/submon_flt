# セッション引き継ぎプロンプトの使い方

`prompts/Txx-*.md` の各ファイルは、**そのまま別の Claude セッションに貼り付けて渡せる** 自己完結プロンプトとして書かれている。

## 渡し方
1. 対象タスクのプロンプトファイル全文をコピーする。
2. 新しいセッションを開く（ブランチ `claude/domain-driven-refactor-plan-zp4nrj` 上、または派生ブランチ）。
3. プロンプトを貼り付けて実行させる。
4. 完了後、`docs/ddd-refactor/01-roadmap.md` の進捗を更新する。

## 全プロンプト共通の前提（各ファイル冒頭で再掲される）
- リポジトリ: `submon_flt`（Flutter / Riverpod v3 / Isar Community / Firebase / freezed）。
- 背景資料: `docs/ddd-refactor/00-analysis.md` と `01-roadmap.md` を**作業前に必ず読む**。
- ターゲット規約: `lib/features/<feature>/{models,repositories,services,use_cases,presentation}`。
- **挙動を変えない**。リファクタリングのみ。Firestore のキー名と Isar スキーマ構造は維持する。
- provider/freezed を移動・追加したら `dart run build_runner build --delete-conflicting-outputs` を実行。
- 完了条件: `flutter analyze` クリーン、生成物コミット済み、旧ファイル/旧 import 削除済み。
- 既存の `features/auth`（最も完成度が高い）を **手本** として参照する。
- **後で文脈が分かるよう、コメント・dartdoc を適切に残す**: public な型/メソッド/provider には責務とレイヤーを示す
  dartdoc (`///`) を付け、移設・抽出・レイヤー違反解消など **意図が見えにくい箇所には理由コメント** を残す。
  既存の有用なコメントは移設先へ持っていく。自明なコードへの冗長なコメントは避ける。
- **コメント・dartdoc は英語で統一する。** 新規コメントはすべて英語。**触れたファイルの既存日本語コメントは
  可能な限り英語へ置き換える**（意味を変えない）。UI 表示用のユーザー向け文字列は翻訳対象外（挙動を変えない）。
  （詳細は `01-roadmap.md`「コメント・dartdoc 方針」を参照）
