import "package:googleapis/tasks/v1.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../isar_db/isar_submission.dart";
import "../../../providers/submission_providers.dart";
import "../../../repositories/submission_repository.dart";
import "../../../utils/app_links.dart";
import "../../google_tasks/repositories/tasks_repository.dart";

part "save_submission_use_case.g.dart";

/// 提出物の新規作成・更新・Google Tasks 同期を一括して行うユースケース。
class SaveSubmissionUseCase {
  const SaveSubmissionUseCase(this._repo, this._tasksRepo);

  final SubmissionRepository _repo;
  final TasksRepository? _tasksRepo;

  Future<void> execute(
    Submission submission, {
    required bool writeGoogleTasks,
  }) async {
    if (submission.id == null) {
      await _repo.create(submission);
      if (writeGoogleTasks) {
        final newTask = createTaskFromSubmission(submission);
        await _tasksRepo?.addTask(newTask);
      }
    } else {
      await _repo.update(submission);
      if (writeGoogleTasks) {
        final newTask = createTaskFromSubmission(submission);
        await _tasksRepo?.updateTask(newTask);
      }
    }
  }

  static Task createTaskFromSubmission(Submission submission) {
    return Task(
      id: submission.googleTasksTaskId,
      title: "${submission.title} (Submon)",
      notes: "Submon アプリ内で開く→${createSubmissionLink(submission.id!)}",
      due: submission.due.toUtc().toIso8601String(),
    );
  }
}

@riverpod
SaveSubmissionUseCase saveSubmissionUseCase(Ref ref) {
  return SaveSubmissionUseCase(
    ref.watch(submissionRepositoryProvider),
    ref.watch(tasksRepositoryProvider),
  );
}
