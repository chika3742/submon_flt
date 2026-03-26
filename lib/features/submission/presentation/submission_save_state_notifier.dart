import "dart:async";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../isar_db/isar_submission.dart";
import "../../../providers/core_providers.dart";
import "../../../utils/distinguish.dart";
import "../../google_tasks/models/tasks_operation_exception.dart";
import "../use_cases/save_submission_use_case.dart";

part "submission_save_state_notifier.freezed.dart";
part "submission_save_state_notifier.g.dart";

@freezed
sealed class SubmissionSaveState with _$SubmissionSaveState {
  const factory SubmissionSaveState.none() = SubmissionSaveStateNone;
  const factory SubmissionSaveState.failed(Object error) = SubmissionSaveStateFailed;
}

@Riverpod(keepAlive: true)
class SubmissionSaveStateNotifier extends _$SubmissionSaveStateNotifier {
  @override
  Distinguish<SubmissionSaveState> build() =>
      Distinguish(const SubmissionSaveState.none());

  void save(Submission submission, {required bool writeGoogleTasks}) {
    final useCase = ref.read(saveSubmissionUseCaseProvider);
    unawaited(
      _saveAsync(useCase, submission, writeGoogleTasks: writeGoogleTasks),
    );
  }

  Future<void> _saveAsync(
    SaveSubmissionUseCase useCase,
    Submission submission, {
    required bool writeGoogleTasks,
  }) async {
    try {
      await useCase.execute(submission, writeGoogleTasks: writeGoogleTasks);
    } on TasksOperationException catch (e) {
      state = Distinguish(SubmissionSaveState.failed(e));
    } catch (e, st) {
      ref.read(crashlyticsProvider).recordError(e, st);
      state = Distinguish(SubmissionSaveState.failed(e));
    }
  }
}
