# リファクタリング・ロードマップ（作業分割）

前提・背景は [`00-analysis.md`](./00-analysis.md) を参照。

各タスクは **1セッションで完結する粒度** に分割してある。原則として
「前のフェーズが完了していること」を前提に、上から順に実施する。
各タスクの詳細プロンプトは [`prompts/Txx-*.md`](./prompts/) にある。
別セッションへはそのプロンプトファイルの内容をそのまま渡せばよい。

## 完了の定義（全タスク共通 DoD）
- `flutter analyze` がクリーン（新規 warning/error なし）。
- `dart run build_runner build --delete-conflicting-outputs` が成功し、生成物がコミットされている。
- 既存テスト（`test/`）が通る（存在する範囲で）。
- リファクタリングであり **挙動を変えていない**。
- 旧ファイル・旧 import が残っていない（ストラングラー完了）。
- コミットは小さく、メッセージに対象 feature とタスクID (例 `refactor(submission): T02 ...`) を含める。

---

## Phase 0 — 基盤と規約
| ID  | タスク                                  | 主な対象                                  | 依存 |
|-----|---------------------------------------|------------------------------------------|------|
| T00 | アーキ規約を CLAUDE.md に明文化 + `infrastructure/` 新設、インフラ系 provider を集約 | `providers/{firebase,firestore,core,pref}*`, `CLAUDE.md` | なし |

## Phase 1 — submission を完成（既存移行のテンプレ確立）
| ID  | タスク                                                          | 主な対象 | 依存 |
|-----|---------------------------------------------------------------|---------|------|
| T01 | submission の repository / エンティティ / クエリ provider / DTO mapper を `features/submission` へ集約 | `repositories/submission_repository.dart`, `isar_db/isar_submission.dart`, `providers/submission_providers.dart`, `providers/submission_share_link_provider.dart` | T00 |
| T02 | submission の pages/components を `features/submission/presentation` へ移設し、`submission_editor` の保存ロジックを use_case/notifier へ抽出 | `pages/submission_*`, `pages/done_submissions_page.dart`, `components/submissions/*` | T01 |

## Phase 2 — digestive
| ID  | タスク                                                                 | 主な対象 | 依存 |
|-----|----------------------------------------------------------------------|---------|------|
| T03 | digestive feature 切り出し。**P2 のレイヤー違反解消**（`DigestiveWithSubmission` を models へ、provider→pages 依存除去） | `repositories/digestive_repository.dart`, `isar_db/isar_digestive.dart`, `providers/digestive_providers.dart`, `pages/home_tabs/tab_digestive_list.dart` | T00 |
| T04 | digestive の UI 移設 + `digestive_edit_bottom_sheet` のロジック抽出   | `components/digestive_*`, `pages/home_tabs/tab_digestive_list.dart` | T03 |

## Phase 3 — timetable
| ID  | タスク                                                                    | 主な対象 | 依存 |
|-----|-------------------------------------------------------------------------|---------|------|
| T05 | timetable feature 切り出し（3 repository, クエリ, undo-redo, `TimetableEditUseCase`） | `repositories/timetable*`, `isar_db/isar_timetable*`, `providers/timetable_providers.dart` | T00 |
| T06 | timetable の UI 移設（編集・表示・設定ページのうち timetable 関連）           | `pages/timetable_*`, `pages/home_tabs/tab_timetable*`, `components/timetable/*`, `pages/settings/timetable.dart` | T05 |

## Phase 4 — memorize_card（**移行せず完全削除**）
memorize_card は既にほぼ全てがコメントアウト済みのデッドコード。feature 化せず削除する。
独立性が高く、T00 完了後の早い段階で単独実施してよい（後続のスコープを縮小できる）。

| ID  | タスク                                                              | 主な対象 | 依存 |
|-----|-------------------------------------------------------------------|---------|------|
| T07 | memorize_card 関連機能を完全削除（ファイル・Isar スキーマ登録・コメントアウト済み参照） | `pages/memorize_card/*`, `pages/home_tabs/tab_memorize_card.dart`, `isar_db/isar_memorization_card_group.dart`, `providers/core_providers.dart`, `utils/{card_side_builder,text_recognized_candidate_painter,point}.dart` | T00 |

## Phase 5 — 横断・同期・設定
| ID  | タスク                                                                   | 主な対象 | 依存 |
|-----|------------------------------------------------------------------------|---------|------|
| T09 | `sync` feature 切り出し。`DataSyncService` を整理し、スキーマ migration を別クラスへ分離 | `providers/data_sync_service.dart`, `providers/firestore_providers.dart` の同期部分 | T01,T03,T05 |
| T10 | `settings` feature 整理。`user_config`・各 settings ページを集約        | `user_config.dart`, `pages/settings/*`, `pages/settings_page.dart` | T05,T09 |
| T11 | `EventBus`(`events.dart`) を Riverpod ストリームへ置換し撤去             | `events.dart`, `main.dart`, `pages/home_page.dart` | T07 |

## Phase 6 — 仕上げ
| ID  | タスク                                                                  | 主な対象 | 依存 |
|-----|-----------------------------------------------------------------------|---------|------|
| T12 | 依存方向 lint の導入（import 境界違反の自動検出）＋ 残存レガシーディレクトリの掃除・規約ドキュメント最終化 | `analysis_options.yaml`, 全 feature | T02–T11 |

---

## 推奨順序と並列化
- **T00 は必ず最初**（全タスクの土台）。
- T01→T02、T03→T04、T05→T06 は **各 feature 内で直列**。
- T07（memorize_card 削除）は独立。T00 後すぐ単独実施すると後続のスコープが縮む。
- 異なる feature 同士（例: digestive と timetable）は **並列セッション可**（ただし共通の `infrastructure/` を触る競合に注意。T00 で安定させておく）。
- Phase 5 は各ドメイン feature が揃ってから着手する。
- T12 は最後。

## 進捗トラッキング
各タスク完了時にこの表の「依存」列の右に `✅` を追記してコミットすると、別セッションが現状を把握しやすい。
