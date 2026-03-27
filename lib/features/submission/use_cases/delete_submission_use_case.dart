import "dart:developer";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../providers/core_providers.dart";
import "../../../providers/digestive_providers.dart";
import "../../../providers/submission_providers.dart";
import "../../../repositories/digestive_repository.dart";
import "../../../repositories/submission_repository.dart";
import "../../../utils/types.dart";
import "../../google_tasks/repositories/tasks_repository.dart";
import "common.dart";

part "delete_submission_use_case.g.dart";

/// 提出物の削除、Google Tasks 同期を一括して行うユースケース。
class DeleteSubmissionUseCase {
  const DeleteSubmissionUseCase(
    this._repo,
    this._digestiveRepo,
    this._tasksRepo,
    this._uid,
  );

  final SubmissionRepository _repo;
  final DigestiveRepository _digestiveRepo;
  final TasksRepository? _tasksRepo;
  final String _uid;

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
        final newTask = createTaskFromSubmission(submission, uid: _uid);
        final newTaskId = await _tasksRepo?.addTask(newTask);
        await _repo.update(submission..googleTasksTaskId = newTaskId);
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
    ref.watch(firebaseUserProvider).requireValue!.uid,
  );
}
