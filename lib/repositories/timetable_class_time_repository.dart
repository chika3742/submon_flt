import "package:isar_community/isar.dart";

import "../db/firestore_provider.dart";
import "../isar_db/isar_timetable_class_time.dart";
import "synced_repository.dart";

class TimetableClassTimeRepository
    extends SyncedRepository<TimetableClassTime> {
  TimetableClassTimeRepository(super.isar);

  @override
  IsarCollection<TimetableClassTime> get collection =>
      isar.timetableClassTimes;

  @override
  FirestoreProvider get firestoreProvider =>
      FirestoreProvider.timetableClassTime;

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
