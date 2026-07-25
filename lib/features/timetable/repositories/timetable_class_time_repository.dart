import "package:isar_community/isar.dart";

import "../../../infrastructure/synced_repository.dart";
import "../models/timetable_class_time.dart";

class TimetableClassTimeRepository
    extends SyncedRepository<TimetableClassTime> {
  TimetableClassTimeRepository(
    super.isar,
    super._firestore,
    super._crashlytics,
    super._errorNotifier,
  );

  @override
  IsarCollection<TimetableClassTime> get collection =>
      isar.timetableClassTimes;

  @override
  Map<String, dynamic> toFirestoreMap(TimetableClassTime data) => data.toMap();

  // --- Write ---

  /// 新規作成。
  Future<int> create(TimetableClassTime data) => put(data);

  /// 既存データを更新。
  Future<void> update(TimetableClassTime data) => put(data);

  Future<void> remove(int id) => delete(id);
}
