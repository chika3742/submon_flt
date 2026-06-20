/// `DataSyncService._migrate` の **per-document データ変換** を Firestore I/O から
/// 切り離した純粋関数群。
///
/// これらは挙動不変のまま `_migrate` から呼び出される。テスト容易性のために
/// 切り出しただけであり、**変換結果は 1 バイトも変えてはならない**
/// (Firestore キー名はサーバ互換のため変更不可)。
library;

/// Submission ドキュメントを schemaVersion 4 → 5 形式へ変換する (in-place)。
///
/// - `detail` → `details` (リネーム)
/// - `date` → `due` (リネーム)
/// - `done == 1` → `bool`
/// - `important == 1` → `bool`
/// - 旧キー `detail` / `date` を削除
///
/// 渡された [data] を破壊的に更新し、同じ参照を返す (旧実装と同じ挙動)。
Map<String, dynamic> migrateSubmissionV4(Map<String, dynamic> data) {
  data["details"] = data["detail"];
  data["due"] = data["date"];
  data["done"] = data["done"] == 1;
  data["important"] = data["important"] == 1;
  data.remove("detail");
  data.remove("date");
  return data;
}

/// Digestive の `done` フィールドを schemaVersion 4 → 5 形式
/// (`done == 1` → `bool`) へ変換する。
bool migrateDigestiveV4Done(Map<String, dynamic> data) {
  return data["done"] == 1;
}

/// Timetable ドキュメントの `cells` マップに schemaVersion 4 → 5 変換を適用する
/// (in-place)。各セルに `tableId = -1` を付与する。
///
/// `cells` が null の場合は何もしない (旧実装と同じ挙動)。
/// 渡された [data] を破壊的に更新し、同じ参照を返す。
Map<String, dynamic> migrateTimetableCellsV4(Map<String, dynamic> data) {
  if (data["cells"] != null) {
    data["cells"] = (data["cells"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value..["tableId"] = -1));
  }
  return data;
}

/// TimetableClassTime ドキュメントを schemaVersion 4 → 5 形式へ変換する (in-place)。
///
/// - `id` → `period` (リネーム)
/// - 旧キー `id` を削除
///
/// 渡された [data] を破壊的に更新し、同じ参照を返す。
Map<String, dynamic> migrateTimetableClassTimeV4(Map<String, dynamic> data) {
  data["period"] = data["id"];
  data.remove("id");
  return data;
}
