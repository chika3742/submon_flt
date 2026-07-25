import "package:flutter_test/flutter_test.dart";
import "package:googleapis/tasks/v1.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/digestive/models/isar_digestive.dart";
import "package:submon/features/digestive/repositories/digestive_repository.dart";
import "package:submon/features/google_tasks/services/tasks_service.dart";
import "package:submon/features/submission/models/submission.dart";
import "package:submon/features/submission/repositories/submission_repository.dart";
import "package:submon/features/submission/use_cases/delete_submission_use_case.dart";

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

class MockDigestiveRepository extends Mock implements DigestiveRepository {}

class MockTasksService extends Mock implements TasksService {}

void main() {
  setUpAll(() {
    registerFallbackValue(Submission());
    registerFallbackValue(Task());
    registerFallbackValue(<Digestive>[]);
  });

  late MockSubmissionRepository repo;
  late MockDigestiveRepository digestiveRepo;
  late MockTasksService tasksService;

  setUp(() {
    repo = MockSubmissionRepository();
    digestiveRepo = MockDigestiveRepository();
    tasksService = MockTasksService();

    when(() => repo.remove(any())).thenAnswer((_) async {});
    when(() => repo.create(any())).thenAnswer((_) async => 1);
    when(() => repo.update(any())).thenAnswer((_) async {});
    when(() => digestiveRepo.deleteBySubmissionId(any()))
        .thenAnswer((_) async => []);
    when(() => digestiveRepo.createAll(any())).thenAnswer((_) async => []);
    when(() => tasksService.deleteTask(any())).thenAnswer((_) async {});
    when(() => tasksService.addTask(any())).thenAnswer((_) async => "restored-id");
  });

  Submission buildSubmission({int id = 5, String? googleTasksTaskId}) {
    return Submission.from(
      id: id,
      title: "t",
      details: "d",
      due: DateTime(2024, 1, 1),
      color: 0,
    )..googleTasksTaskId = googleTasksTaskId;
  }

  group("main deletion logic", () {
    test("throws ArgumentError when the target does not exist", () async {
      when(() => repo.get(any())).thenAnswer((_) async => null);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      expect(() => useCase.execute(99), throwsArgumentError);
    });

    test("deletes digestives and the submission", () async {
      final submission = buildSubmission();
      final deletedDigestives = [
        Digestive.from(startAt: DateTime(2024, 1, 1), minute: 10, content: "x"),
      ];
      when(() => repo.get(5)).thenAnswer((_) async => submission);
      when(() => digestiveRepo.deleteBySubmissionId(5))
          .thenAnswer((_) async => deletedDigestives);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      await useCase.execute(5);

      verify(() => digestiveRepo.deleteBySubmissionId(5)).called(1);
      verify(() => repo.remove(5)).called(1);
    });

    test("googleTasksTaskId present + _tasksRepo present -> deleteTask is called",
        () async {
      final submission = buildSubmission(googleTasksTaskId: "gt-1");
      when(() => repo.get(5)).thenAnswer((_) async => submission);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      await useCase.execute(5);

      verify(() => tasksService.deleteTask("gt-1")).called(1);
    });

    test("googleTasksTaskId absent -> deleteTask is not called", () async {
      when(() => repo.get(5))
          .thenAnswer((_) async => buildSubmission(googleTasksTaskId: null));
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      await useCase.execute(5);

      verifyNever(() => tasksService.deleteTask(any()));
    });

    test("googleTasksTaskId present + _tasksRepo == null -> does not throw",
        () async {
      when(() => repo.get(5))
          .thenAnswer((_) async => buildSubmission(googleTasksTaskId: "gt-1"));
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, null, "uid");

      await expectLater(useCase.execute(5), completes);
    });
  });

  group("Restorable (undo)", () {
    test("running it re-creates the submission and digestives", () async {
      final submission = buildSubmission(googleTasksTaskId: null);
      final deletedDigestives = [
        Digestive.from(startAt: DateTime(2024, 1, 1), minute: 10, content: "x"),
      ];
      when(() => repo.get(5)).thenAnswer((_) async => submission);
      when(() => digestiveRepo.deleteBySubmissionId(5))
          .thenAnswer((_) async => deletedDigestives);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      final restore = await useCase.execute(5);
      await restore();

      verify(() => repo.create(submission)).called(1);
      verify(() => digestiveRepo.createAll(deletedDigestives)).called(1);
      // No taskId, so the Task is not re-created
      verifyNever(() => tasksService.addTask(any()));
    });

    test("re-creates the Task and updates with the new id when taskId present",
        () async {
      final submission = buildSubmission(googleTasksTaskId: "gt-1");
      when(() => repo.get(5)).thenAnswer((_) async => submission);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      final restore = await useCase.execute(5);
      await restore();

      verify(() => tasksService.addTask(any())).called(1);
      // The re-created taskId is reflected on the submission and updated
      expect(submission.googleTasksTaskId, "restored-id");
      verify(() => repo.update(submission)).called(1);
    });
  });
}
