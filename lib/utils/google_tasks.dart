import "package:collection/collection.dart";
import "package:googleapis/tasks/v1.dart" as tasks;
import "package:googleapis_auth/googleapis_auth.dart";

import "../isar_db/isar_submission.dart";
import "app_links.dart";

class GoogleTasksException implements Exception {
  final GoogleTasksError error;

  const GoogleTasksException(this.error);

  @override
  String toString() => switch (error) {
        GoogleTasksError.failedToAuthenticate =>
          "Google Tasksへの追加に失敗しました。(認証に失敗しました。)",
        GoogleTasksError.taskListDoesNotExist =>
          "Google Tasksのタスクリストが存在しません。Tasksアプリでタスクリストを作成してください。",
      };
}

enum GoogleTasksError {
  failedToAuthenticate,
  taskListDoesNotExist,
}

class GoogleTasksHelper {
  const GoogleTasksHelper._();

  static Future<tasks.Task> makeTaskRequest(Submission data) async {
    final linkData = createSubmissionLink(data.id!);
    return tasks.Task(
      id: data.googleTasksTaskId,
      title: "${data.title} (Submon)",
      notes: "Submon アプリ内で開く→$linkData",
      due: data.due.toUtc().toIso8601String(),
    );
  }

  /// Google Tasks にタスクを追加/更新し、タスクIDを返す。
  /// 既存タスクの更新時は既存IDをそのまま返す。
  static Future<String?> addTask(AuthClient client, Submission data) async {
    final tasksApi = tasks.TasksApi(client);

    final tasklist =
        (await tasksApi.tasklists.list(maxResults: 1)).items?.firstOrNull;
    if (tasklist == null) {
      throw const GoogleTasksException(
        GoogleTasksError.taskListDoesNotExist,
      );
    }

    if (data.googleTasksTaskId != null) {
      await tasksApi.tasks.update(
        await makeTaskRequest(data),
        tasklist.id!,
        data.googleTasksTaskId!,
      );
      return data.googleTasksTaskId;
    } else {
      final result = await tasksApi.tasks
          .insert(await makeTaskRequest(data), tasklist.id!);
      return result.id;
    }
  }
}
