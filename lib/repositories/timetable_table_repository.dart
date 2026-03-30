import "package:isar_community/isar.dart";

import "../isar_db/isar_timetable_table.dart";
import "synced_repository.dart";

class TimetableTableRepository extends SyncedRepository<TimetableTable> {
  TimetableTableRepository(
    super.isar,
    super._firestore,
    super._errorReporter,
  );

  @override
  IsarCollection<TimetableTable> get collection => isar.timetableTables;

  @override
  Map<String, dynamic> toFirestoreMap(TimetableTable data) => data.toMap();

  // --- Write ---

  /// 新規作成。
  Future<int> create(TimetableTable data) => put(data);

  /// 既存データを更新。
  Future<void> update(TimetableTable data) => put(data);

  Future<void> remove(int id) => delete(id);
}
