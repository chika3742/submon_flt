import "package:flutter_test/flutter_test.dart";
import "package:googleapis/tasks/v1.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/google_tasks/services/tasks_service.dart";
import "package:submon/features/submission/use_cases/save_submission_use_case.dart";
import "package:submon/isar_db/isar_submission.dart";
import "package:submon/repositories/submission_repository.dart";

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

class MockTasksService extends Mock implements TasksService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Submission());
    registerFallbackValue(Task());
  });

  late MockSubmissionRepository repo;
  late MockTasksService tasksService;

  setUp(() {
    repo = MockSubmissionRepository();
    tasksService = MockTasksService();

    when(() => repo.create(any())).thenAnswer((_) async => 1);
    when(() => repo.update(any())).thenAnswer((_) async {});
    when(() => tasksService.addTask(any())).thenAnswer((_) async => "new-task-id");
    when(() => tasksService.updateTask(any())).thenAnswer((_) async {});
  });

  Submission buildSubmission({int? id, String? googleTasksTaskId}) {
    return Submission.from(
      id: id,
      title: "t",
      details: "d",
      due: DateTime(2024, 1, 1),
      color: 0,
    )..googleTasksTaskId = googleTasksTaskId;
  }

  group("永続化の分岐", () {
    test("id == null → create が呼ばれ update は呼ばれない", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: null);

      await useCase.execute(submission, writeGoogleTasks: false);

      verify(() => repo.create(submission)).called(1);
      verifyNever(() => repo.update(any()));
    });

    test("id != null → update が呼ばれ create は呼ばれない", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: 5);

      await useCase.execute(submission, writeGoogleTasks: false);

      verify(() => repo.update(submission)).called(1);
      verifyNever(() => repo.create(any()));
    });
  });

  group("Google Tasks 同期の分岐", () {
    test("writeGoogleTasks == false → Tasks API を呼ばない", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");

      await useCase.execute(buildSubmission(id: 5), writeGoogleTasks: false);

      verifyNever(() => tasksService.addTask(any()));
      verifyNever(() => tasksService.updateTask(any()));
    });

    test(
        "writeGoogleTasks == true かつ googleTasksTaskId == null → "
        "addTask の戻り値を update で保存", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: 5, googleTasksTaskId: null);

      await useCase.execute(submission, writeGoogleTasks: true);

      final captured =
          verify(() => tasksService.addTask(captureAny())).captured.single
              as Task;
      // createTaskFromSubmission が submission を正しく Task へ写像している
      expect(captured.title, "t (Submon)");
      expect(captured.due, submission.due.toUtc().toIso8601String());
      verifyNever(() => tasksService.updateTask(any()));
      // 戻り値の taskId が submission に保存される
      expect(submission.googleTasksTaskId, "new-task-id");
      // 更新は「初回の永続化」+「taskId 保存」で 2 回呼ばれる
      verify(() => repo.update(submission)).called(2);
    });

    test(
        "writeGoogleTasks == true かつ googleTasksTaskId != null → "
        "updateTask が呼ばれ addTask は呼ばれない", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: 5, googleTasksTaskId: "existing");

      await useCase.execute(submission, writeGoogleTasks: true);

      final captured =
          verify(() => tasksService.updateTask(captureAny())).captured.single
              as Task;
      // 既存タスク更新時は Task.id に既存 ID が入る
      expect(captured.id, "existing");
      expect(captured.title, "t (Submon)");
      verifyNever(() => tasksService.addTask(any()));
    });

    test("_tasksRepo == null でも例外を投げない (連携無効)", () async {
      final useCase = SaveSubmissionUseCase(repo, null, "uid");
      final submission = buildSubmission(id: 5, googleTasksTaskId: null);

      await expectLater(
        useCase.execute(submission, writeGoogleTasks: true),
        completes,
      );
      // addTask が null を返すため googleTasksTaskId は null になる
      expect(submission.googleTasksTaskId, isNull);
    });
  });
}
