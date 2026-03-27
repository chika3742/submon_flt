import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../isar_db/isar_submission.dart";
import "../../../providers/firebase_providers.dart";
import "../../../providers/submission_providers.dart";
import "../../../repositories/submission_repository.dart";
import "../../google_tasks/services/tasks_service.dart";
import "common.dart";

part "save_submission_use_case.g.dart";

/// 提出物の新規作成・更新・Google Tasks 同期を一括して行うユースケース。
class SaveSubmissionUseCase {
  const SaveSubmissionUseCase(this._repo, this._tasksRepo, this._uid);

  final SubmissionRepository _repo;
  final TasksService? _tasksRepo;
  final String _uid;

  Future<void> execute(
    Submission submission, {
    required bool writeGoogleTasks,
  }) async {
    if (submission.id == null) {
      await _repo.create(submission);
    } else {
      await _repo.update(submission);
    }

    if (writeGoogleTasks) {
      final newTask = createTaskFromSubmission(submission, uid: _uid);
      if (submission.googleTasksTaskId == null) {
        final taskId = await _tasksRepo?.addTask(newTask);
        await _repo.update(submission..googleTasksTaskId = taskId);
      } else {
        await _tasksRepo?.updateTask(newTask);
      }
    }
  }
}

@riverpod
SaveSubmissionUseCase saveSubmissionUseCase(Ref ref) {
  return SaveSubmissionUseCase(
    ref.watch(submissionRepositoryProvider),
    ref.watch(tasksServiceProvider),
    ref.watch(firebaseUserProvider).requireValue!.uid,
  );
}
