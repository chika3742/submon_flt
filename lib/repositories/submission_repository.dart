import "package:isar_community/isar.dart";

import "../isar_db/isar_submission.dart";
import "../src/pigeons.g.dart";
import "synced_repository.dart";

class SubmissionRepository extends SyncedRepository<Submission> {
  SubmissionRepository(
    super.isar,
    super.firestore,
    super.crashlytics,
  );

  @override
  IsarCollection<Submission> get collection => isar.submissions;

  @override
  Map<String, dynamic> toFirestoreMap(Submission data) => data.toMap();

  @override
  void onFirestoreUpdated() {
    GeneralApi().updateWidgets();
  }

  /// 新規作成。
  Future<int> create(Submission data) => put(data);

  /// 既存データを更新。
  Future<void> update(Submission data) => put(data);

  Future<void> remove(int id) => delete(id);

  Future<void> invertDone(Submission data) {
    return put(data..done = !data.done);
  }

  Future<void> toggleImportant(Submission data) {
    return put(data..important = !data.important);
  }
}
