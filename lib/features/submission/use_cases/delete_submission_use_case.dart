import "dart:developer";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../providers/digestive_providers.dart";
import "../../../providers/submission_providers.dart";
import "../../../repositories/digestive_repository.dart";
import "../../../repositories/submission_repository.dart";
import "../../../utils/types.dart";
import "../../google_tasks/repositories/tasks_repository.dart";
import "save_submission_use_case.dart";

part "delete_submission_use_case.g.dart";

/// 提出物の新規作成・更新・Google Tasks 同期を一括して行うユースケース。
class DeleteSubmissionUseCase {
  const DeleteSubmissionUseCase(this._repo, this._digestiveRepo, this._tasksRepo);

  final SubmissionRepository _repo;
  final DigestiveRepository _digestiveRepo;
  final TasksRepository? _tasksRepo;

  Future<Restorable> execute(int id) async {
    final submission = await _repo.get(id);
    if (submission == null) throw ArgumentError("Submission not fount for id: $id");

    if (submission.googleTasksTaskId case final googleTasksTaskId?) {
      if (_tasksRepo == null) {
        log(
          "Google Tasks Repository is not available. Task with id $googleTasksTaskId may be left undeleted.",
          name: "DeleteSubmissionUseCase",
        );
      } else {
        _tasksRepo.deleteTask(googleTasksTaskId);
      }
    }

    final digestivesToRestore = await _digestiveRepo.deleteBySubmissionId(id);

    await _repo.delete(id);

    return () async {
      await _repo.create(submission);
      await _digestiveRepo.createAll(digestivesToRestore);
      if (submission.googleTasksTaskId != null) {
        final newTask = SaveSubmissionUseCase.createTaskFromSubmission(submission);
        await _tasksRepo?.addTask(newTask);
        await _repo.update(submission..googleTasksTaskId = newTask.id);
      }
    };
  }
}

@riverpod
DeleteSubmissionUseCase deleteSubmissionUseCase(Ref ref) {
  return DeleteSubmissionUseCase(
    ref.watch(submissionRepositoryProvider),
    ref.watch(digestiveRepositoryProvider),
    ref.watch(tasksRepositoryProvider),
  );
}
