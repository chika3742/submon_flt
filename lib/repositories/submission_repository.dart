import "package:collection/collection.dart";
import "package:googleapis/tasks/v1.dart" as tasks;
import "package:googleapis_auth/googleapis_auth.dart";
import "package:isar_community/isar.dart";

import "../isar_db/isar_submission.dart";
import "../src/pigeons.g.dart";
import "../utils/google_tasks.dart";
import "../utils/types.dart";
import "digestive_repository.dart";
import "synced_repository.dart";

class SubmissionRepository extends SyncedRepository<Submission> {
  SubmissionRepository(
    super.isar,
    super.firestore,
    this._authClient,
    this._digestiveRepository,
  );

  final AuthClient? _authClient;
  final DigestiveRepository _digestiveRepository;

  @override
  IsarCollection<Submission> get collection => isar.submissions;

  @override
  Map<String, dynamic> toFirestoreMap(Submission data) => data.toMap();

  @override
  void onFirestoreUpdated() {
    GeneralApi().updateWidgets();
  }

  // --- Write ---

  /// 新規作成。
  Future<int> create(Submission data) => put(data);

  /// 既存データを更新。
  Future<void> update(Submission data) async {
    await put(data);
  }

  Future<void> invertDone(Submission data) {
    return put(data..done = !data.done);
  }

  Future<void> toggleImportant(Submission data) {
    return put(data..important = !data.important);
  }

  /// 提出物を削除し、関連する Digestive も削除し、Google Tasks からも削除する。
  /// 戻り値の関数を呼ぶと削除を元に戻せる。
  Future<Restorable> deleteItem(int id) async {
    final submission = await get(id);
    if (submission == null) {
      return () async {};
    }

    if (submission.googleTasksTaskId case final googleTasksTaskId?) {
      _deleteFromGoogleTasks(googleTasksTaskId);
    }
    await delete(id);

    final digestivesToRestore =
        await _digestiveRepository.deleteBySubmissionId(id);

    return () async {
      await put(submission);
      await _digestiveRepository.createAll(digestivesToRestore);
    };
  }

  // --- Google Tasks (private) ---

  /// Google Tasks にタスクを追加/更新し、[data] の [googleTasksTaskId] を保存する。
  /// 未認証の場合は [GoogleTasksException] をスローする。
  Future<void> addToGoogleTasks(Submission data) async {
    if (_authClient == null) {
      throw const GoogleTasksException(GoogleTasksError.failedToAuthenticate);
    }
    final taskId = await GoogleTasksHelper.addTask(_authClient, data);
    if (taskId != null && data.googleTasksTaskId == null) {
      await update(data..googleTasksTaskId = taskId);
    }
  }

  Future<void> _deleteFromGoogleTasks(String taskId) async {
    if (_authClient == null) {
      throw const GoogleTasksException(GoogleTasksError.failedToAuthenticate);
    }

    final tasksApi = tasks.TasksApi(_authClient);
    final tasklist =
        (await tasksApi.tasklists.list(maxResults: 1)).items?.firstOrNull;
    if (tasklist != null) {
      await tasksApi.tasks.delete(tasklist.id!, taskId);
    }
  }
}
