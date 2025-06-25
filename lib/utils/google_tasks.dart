import 'package:collection/collection.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;

import '../isar_db/isar_submission.dart';
import '../main.dart';
import 'app_links.dart';

class GoogleTasksHelper {

  static Future<tasks.Task> makeTaskRequest(Submission data) async {
    final linkData = createSubmissionLink(data.id!);
    return tasks.Task(
      id: data.googleTasksTaskId,
      title: "${data.title} (Submon)",
      notes: "Submon アプリ内で開く→$linkData",
      due: data.due.toUtc().toIso8601String(),
    );
  }

  static Future<GoogleApiError?> addTask(Submission data) async {
    var client = await googleSignIn.authenticatedClient();
    if (client == null) {
      return GoogleApiError.failedToAuthenticate;
    }

    var tasksApi = tasks.TasksApi(client);

    try {
      var tasklist =
          (await tasksApi.tasklists.list(maxResults: 1)).items?.firstOrNull;
      if (tasklist == null) {
        return GoogleApiError.taskListDoesNotExist;
      }

      if (data.googleTasksTaskId != null) {
        await tasksApi.tasks.update(
            await makeTaskRequest(data), tasklist.id!, data.googleTasksTaskId!);
      } else {
        var result = await tasksApi.tasks
            .insert(await makeTaskRequest(data), tasklist.id!);

        SubmissionProvider().use((provider) async {
          await provider.writeTransaction(() async {
            await provider.put(data..googleTasksTaskId = result.id);
          });
        });
      }

      return null;
    } catch (e, st) {

      FirebaseCrashlytics.instance.recordError(e, st);
      return GoogleApiError.unknown;
    }
  }

}

enum GoogleApiError {
  failedToAuthenticate,
  taskListDoesNotExist,
  unknown;
}
