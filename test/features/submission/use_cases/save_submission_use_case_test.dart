import "package:flutter_test/flutter_test.dart";
import "package:googleapis/tasks/v1.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/google_tasks/services/tasks_service.dart";
import "package:submon/features/submission/models/submission.dart";
import "package:submon/features/submission/repositories/submission_repository.dart";
import "package:submon/features/submission/use_cases/save_submission_use_case.dart";

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

  group("persistence branch", () {
    test("id == null -> create is called, update is not", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: null);

      await useCase.execute(submission, writeGoogleTasks: false);

      verify(() => repo.create(submission)).called(1);
      verifyNever(() => repo.update(any()));
    });

    test("id != null -> update is called, create is not", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: 5);

      await useCase.execute(submission, writeGoogleTasks: false);

      verify(() => repo.update(submission)).called(1);
      verifyNever(() => repo.create(any()));
    });
  });

  group("Google Tasks sync branch", () {
    test("writeGoogleTasks == false -> Tasks API is not called", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");

      await useCase.execute(buildSubmission(id: 5), writeGoogleTasks: false);

      verifyNever(() => tasksService.addTask(any()));
      verifyNever(() => tasksService.updateTask(any()));
    });

    test(
        "writeGoogleTasks == true and googleTasksTaskId == null -> "
        "saves addTask's return value via update", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: 5, googleTasksTaskId: null);

      await useCase.execute(submission, writeGoogleTasks: true);

      final captured =
          verify(() => tasksService.addTask(captureAny())).captured.single
              as Task;
      // createTaskFromSubmission maps the submission to a Task correctly
      expect(captured.title, "t (Submon)");
      expect(captured.due, submission.due.toUtc().toIso8601String());
      verifyNever(() => tasksService.updateTask(any()));
      // The returned taskId is saved on the submission
      expect(submission.googleTasksTaskId, "new-task-id");
      // update is called twice: initial persistence + saving the taskId
      verify(() => repo.update(submission)).called(2);
    });

    test(
        "writeGoogleTasks == true and googleTasksTaskId != null -> "
        "updateTask is called, addTask is not", () async {
      final useCase = SaveSubmissionUseCase(repo, tasksService, "uid");
      final submission = buildSubmission(id: 5, googleTasksTaskId: "existing");

      await useCase.execute(submission, writeGoogleTasks: true);

      final captured =
          verify(() => tasksService.updateTask(captureAny())).captured.single
              as Task;
      // When updating an existing task, Task.id holds the existing id
      expect(captured.id, "existing");
      expect(captured.title, "t (Submon)");
      verifyNever(() => tasksService.addTask(any()));
    });

    test("does not throw when _tasksRepo == null (integration disabled)",
        () async {
      final useCase = SaveSubmissionUseCase(repo, null, "uid");
      final submission = buildSubmission(id: 5, googleTasksTaskId: null);

      await expectLater(
        useCase.execute(submission, writeGoogleTasks: true),
        completes,
      );
      // addTask returns null, so googleTasksTaskId becomes null
      expect(submission.googleTasksTaskId, isNull);
    });
  });
}
