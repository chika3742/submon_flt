import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/isar_db/isar_timetable.dart";
import "package:submon/providers/timetable_providers.dart";
import "package:submon/repositories/timetable_repository.dart";

class MockTimetableRepository extends Mock implements TimetableRepository {}

class MockUndoRedo extends Mock implements UndoRedoHandler<TimetableSnapshot> {}

void main() {
  setUpAll(() {
    registerFallbackValue(<int, Timetable>{});
  });

  const tableId = -1;

  late MockTimetableRepository repo;
  late MockUndoRedo undoRedo;
  late TimetableEditUseCase useCase;

  setUp(() {
    repo = MockTimetableRepository();
    undoRedo = MockUndoRedo();
    useCase = TimetableEditUseCase(tableId, repo, undoRedo);

    when(() => repo.getByTableId(any())).thenAnswer((_) async => []);
    when(() => repo.restoreSnapshot(any(), any())).thenAnswer((_) async {});
    when(() => repo.clearTable(any())).thenAnswer((_) async {});
    when(() => undoRedo.pushSnapshot(any())).thenReturn(null);
  });

  Timetable cell(int cellId) {
    return Timetable()
      ..tableId = tableId
      ..cellId = cellId
      ..subject = "s$cellId";
  }

  group("undo", () {
    test("does not call restoreSnapshot when undo stack is empty (popUndo == null)",
        () async {
      when(() => undoRedo.popUndo(any())).thenReturn(null);

      await useCase.undo();

      verifyNever(() => repo.restoreSnapshot(any(), any()));
    });

    test("calls restoreSnapshot with the snapshot returned by popUndo", () async {
      final snapshot = {0: cell(0)};
      when(() => undoRedo.popUndo(any())).thenReturn(snapshot);

      await useCase.undo();

      verify(() => repo.restoreSnapshot(tableId, snapshot)).called(1);
    });
  });

  group("redo", () {
    test("does not call restoreSnapshot when redo stack is empty (popRedo == null)",
        () async {
      when(() => undoRedo.popRedo(any())).thenReturn(null);

      await useCase.redo();

      verifyNever(() => repo.restoreSnapshot(any(), any()));
    });

    test("calls restoreSnapshot with the snapshot returned by popRedo", () async {
      final snapshot = {1: cell(1)};
      when(() => undoRedo.popRedo(any())).thenReturn(snapshot);

      await useCase.redo();

      verify(() => repo.restoreSnapshot(tableId, snapshot)).called(1);
    });
  });

  group("pushUndoSnapshot", () {
    test("pushes the current table state (cellId map)", () async {
      when(() => repo.getByTableId(tableId))
          .thenAnswer((_) async => [cell(0), cell(3)]);

      await useCase.pushUndoSnapshot();

      final captured = verify(() => undoRedo.pushSnapshot(captureAny()))
          .captured
          .single as TimetableSnapshot;
      expect(captured.keys.toSet(), {0, 3});
    });
  });

  group("clearTable", () {
    test("pushes an undo snapshot before clearing", () async {
      when(() => undoRedo.popUndo(any())).thenReturn(null);

      await useCase.clearTable();

      verifyInOrder([
        () => repo.getByTableId(tableId),
        () => undoRedo.pushSnapshot(any()),
        () => repo.clearTable(tableId),
      ]);
    });
  });
}
