import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/features/timetable/models/timetable.dart";
import "package:submon/features/timetable/use_cases/undo_redo.dart";

/// Tests for the stack-transition logic of the `UndoRedo` Notifier.
///
/// `TimetableEditUseCase` mocks `UndoRedoHandler`, so the stack invariants
/// (push clears redo, pop pushes current onto the opposite stack) are verified
/// directly here.
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  UndoRedo handler() => container.read(undoRedoProvider(-1).notifier);

  Timetable cell(int cellId) {
    return Timetable()
      ..tableId = -1
      ..cellId = cellId
      ..subject = "s$cellId";
  }

  TimetableSnapshot snapshot(int cellId) => {cellId: cell(cellId)};

  test("initial state: both stacks empty, popUndo/popRedo return null", () {
    final h = handler();
    expect(h.popUndo(snapshot(0)), isNull);
    expect(h.popRedo(snapshot(0)), isNull);
  });

  test("pushSnapshot then popUndo returns it and pushes current onto redo", () {
    final h = handler();
    final s1 = snapshot(1);
    final current = snapshot(2);

    h.pushSnapshot(s1);
    final popped = h.popUndo(current);

    expect(popped, s1);
    // current was pushed onto the redo stack and can be popped back
    expect(h.popRedo(snapshot(3)), current);
  });

  test("pushSnapshot clears the redo stack", () {
    final h = handler();
    h.pushSnapshot(snapshot(1));
    h.popUndo(snapshot(2)); // pushed onto the redo stack

    // A new operation (pushSnapshot) clears redo
    h.pushSnapshot(snapshot(3));
    expect(h.popRedo(snapshot(4)), isNull);
  });

  test("clear empties both stacks", () {
    final h = handler();
    h.pushSnapshot(snapshot(1));
    h.clear();

    expect(h.popUndo(snapshot(2)), isNull);
    expect(h.popRedo(snapshot(2)), isNull);
  });
}
