import "package:riverpod_annotation/riverpod_annotation.dart";

import "../models/timetable.dart";

part "undo_redo.g.dart";

/// Undo/Redo interface that can be mocked in tests.
abstract interface class UndoRedoHandler<T> {
  void pushSnapshot(T snapshot);
  T? popUndo(T current);
  T? popRedo(T current);
  void clear();
}

/// Per-tableId Undo/Redo stack.
@Riverpod(keepAlive: true)
class UndoRedo extends _$UndoRedo
    implements UndoRedoHandler<TimetableSnapshot> {
  @override
  ({List<TimetableSnapshot> undoStack, List<TimetableSnapshot> redoStack})
      build(int tableId) {
    return (undoStack: [], redoStack: []);
  }

  @override
  void pushSnapshot(TimetableSnapshot snapshot) {
    state = (
      undoStack: [...state.undoStack, Map.of(snapshot)],
      redoStack: [],
    );
  }

  @override
  TimetableSnapshot? popUndo(TimetableSnapshot current) {
    if (state.undoStack.isEmpty) return null;
    final newUndo = [...state.undoStack];
    final snapshot = newUndo.removeLast();
    state = (
      undoStack: newUndo,
      redoStack: [...state.redoStack, Map.of(current)],
    );
    return snapshot;
  }

  @override
  TimetableSnapshot? popRedo(TimetableSnapshot current) {
    if (state.redoStack.isEmpty) return null;
    final newRedo = [...state.redoStack];
    final snapshot = newRedo.removeLast();
    state = (
      undoStack: [...state.undoStack, Map.of(current)],
      redoStack: newRedo,
    );
    return snapshot;
  }

  @override
  void clear() {
    state = (undoStack: [], redoStack: []);
  }
}
