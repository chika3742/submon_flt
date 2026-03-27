import "package:isar_community/isar.dart";

import "../isar_db/isar_timetable_class_time.dart";
import "synced_repository.dart";

class TimetableClassTimeRepository
    extends SyncedRepository<TimetableClassTime> {
  TimetableClassTimeRepository(super.isar, super.firestore, super.crashlytics);

  @override
  IsarCollection<TimetableClassTime> get collection =>
      isar.timetableClassTimes;

  @override
  Map<String, dynamic> toFirestoreMap(TimetableClassTime data) => data.toMap();

  // --- Write ---

  /// 新規作成。
  Future<int> create(TimetableClassTime data) => put(data);

  /// 既存データを更新。
  Future<void> update(TimetableClassTime data) async {
    await put(data);
  }
}
