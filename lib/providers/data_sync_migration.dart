/// Pure functions for the **per-document data conversion** part of
/// `DataSyncService._migrate`, decoupled from Firestore I/O.
///
/// They are called from `_migrate` without changing behavior; they were
/// extracted only for testability. **The conversion result must not change by
/// even a single byte** (Firestore key names must stay server-compatible).
library;

/// Converts a Submission document from schemaVersion 4 to 5 format (in-place).
///
/// - `detail` → `details` (rename)
/// - `date` → `due` (rename)
/// - `done == 1` → `bool`
/// - `important == 1` → `bool`
/// - removes the old keys `detail` / `date`
///
/// Mutates and returns the same [data] reference (same as the old impl).
Map<String, dynamic> migrateSubmissionV4(Map<String, dynamic> data) {
  data["details"] = data["detail"];
  data["due"] = data["date"];
  data["done"] = data["done"] == 1;
  data["important"] = data["important"] == 1;
  data.remove("detail");
  data.remove("date");
  return data;
}

/// Converts a Digestive `done` field from schemaVersion 4 to 5 format
/// (`done == 1` → `bool`).
bool migrateDigestiveV4Done(Map<String, dynamic> data) {
  return data["done"] == 1;
}

/// Applies the schemaVersion 4 → 5 conversion to a Timetable document's
/// `cells` map (in-place), adding `tableId = -1` to every cell.
///
/// Does nothing when `cells` is null (same as the old impl).
/// Mutates and returns the same [data] reference.
Map<String, dynamic> migrateTimetableCellsV4(Map<String, dynamic> data) {
  if (data["cells"] != null) {
    data["cells"] = (data["cells"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value..["tableId"] = -1));
  }
  return data;
}

/// Converts a TimetableClassTime document from schemaVersion 4 to 5 format
/// (in-place).
///
/// - `id` → `period` (rename)
/// - removes the old key `id`
///
/// Mutates and returns the same [data] reference.
Map<String, dynamic> migrateTimetableClassTimeV4(Map<String, dynamic> data) {
  data["period"] = data["id"];
  data.remove("id");
  return data;
}
