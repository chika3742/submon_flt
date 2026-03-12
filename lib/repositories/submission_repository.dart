import "package:collection/collection.dart";
import "package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart";
import "package:googleapis/tasks/v1.dart" as tasks;
import "package:isar_community/isar.dart";

import "../db/firestore_provider.dart";
import "../isar_db/isar_digestive.dart";
import "../isar_db/isar_submission.dart";
import "../main.dart";
import "../src/pigeons.g.dart";
import "../utils/types.dart";
import "synced_repository.dart";

class SubmissionRepository extends SyncedRepository<Submission> {
  SubmissionRepository(super.isar);

  @override
  IsarCollection<Submission> get collection => isar.submissions;

  @override
  FirestoreProvider get firestoreProvider => FirestoreProvider.submission;

  @override
  Map<String, dynamic> toFirestoreMap(Submission data) => data.toMap();

  @override
  void onFirestoreUpdated() {
    GeneralApi().updateWidgets();
  }

  // --- Write ---

  Future<void> invertDone(Submission data) {
    return put(data..done = !data.done);
  }

  /// 提出物を削除し、関連する Digestive も削除する。
  /// 戻り値の関数を呼ぶと削除を元に戻せる。
  Future<Restorable> deleteItem(int id) async {
    final submission = await get(id);
    if (submission == null) {
      return () async {};
    }

    await delete(id);

    // DigestiveProvider を暫定利用 (Phase 2 で DI に変更)
    List<Digestive> digestivesToRestore = [];
    await DigestiveProvider().use((provider) async {
      digestivesToRestore = await provider.deleteBySubmissionId(id);
    });

    return () async {
      await put(submission);
      await DigestiveProvider().use((provider) async {
        for (final digestive in digestivesToRestore) {
          await provider.writeTransaction(() async {
            await provider.put(digestive);
          });
        }
      });
    };
  }

  // --- Google Tasks ---

  static void deleteFromGoogleTasks(String? taskId) {
    if (taskId != null) {
      googleSignIn.authenticatedClient().then((client) async {
        if (client != null) {
          final tasksApi = tasks.TasksApi(client);
          final tasklist =
              (await tasksApi.tasklists.list(maxResults: 1)).items?.firstOrNull;
          if (tasklist != null) {
            tasksApi.tasks.delete(tasklist.id!, taskId);
          }
        }
      });
    }
  }
}
