import "package:flutter_test/flutter_test.dart";
import "package:googleapis/tasks/v1.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/google_tasks/services/tasks_service.dart";
import "package:submon/features/submission/use_cases/delete_submission_use_case.dart";
import "package:submon/isar_db/isar_digestive.dart";
import "package:submon/isar_db/isar_submission.dart";
import "package:submon/repositories/digestive_repository.dart";
import "package:submon/repositories/submission_repository.dart";

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

  group("削除の本処理", () {
    test("対象が存在しない → ArgumentError", () async {
      when(() => repo.get(any())).thenAnswer((_) async => null);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      expect(() => useCase.execute(99), throwsArgumentError);
    });

    test("digestive を削除し、submission を削除する", () async {
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

    test("googleTasksTaskId 有り + _tasksRepo 有り → deleteTask が呼ばれる", () async {
      final submission = buildSubmission(googleTasksTaskId: "gt-1");
      when(() => repo.get(5)).thenAnswer((_) async => submission);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      await useCase.execute(5);

      verify(() => tasksService.deleteTask("gt-1")).called(1);
    });

    test("googleTasksTaskId 無し → deleteTask は呼ばれない", () async {
      when(() => repo.get(5))
          .thenAnswer((_) async => buildSubmission(googleTasksTaskId: null));
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      await useCase.execute(5);

      verifyNever(() => tasksService.deleteTask(any()));
    });

    test("googleTasksTaskId 有り + _tasksRepo == null → 例外を投げない", () async {
      when(() => repo.get(5))
          .thenAnswer((_) async => buildSubmission(googleTasksTaskId: "gt-1"));
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, null, "uid");

      await expectLater(useCase.execute(5), completes);
    });
  });

  group("Restorable (元に戻す)", () {
    test("実行すると submission と digestive を再作成する", () async {
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
      // taskId が無いので Tasks 再作成はしない
      verifyNever(() => tasksService.addTask(any()));
    });

    test("googleTasksTaskId 有りなら Tasks を再作成して新 ID で update する", () async {
      final submission = buildSubmission(googleTasksTaskId: "gt-1");
      when(() => repo.get(5)).thenAnswer((_) async => submission);
      final useCase =
          DeleteSubmissionUseCase(repo, digestiveRepo, tasksService, "uid");

      final restore = await useCase.execute(5);
      await restore();

      verify(() => tasksService.addTask(any())).called(1);
      // 再作成された taskId が submission に反映され update される
      expect(submission.googleTasksTaskId, "restored-id");
      verify(() => repo.update(submission)).called(1);
    });
  });
}
