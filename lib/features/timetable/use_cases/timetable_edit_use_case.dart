import "package:riverpod_annotation/riverpod_annotation.dart";

import "../models/timetable.dart";
import "../repositories/timetable_providers.dart";
import "../repositories/timetable_repository.dart";
import "undo_redo.dart";

part "timetable_edit_use_case.g.dart";

/// tableId-scoped UseCase provider.
@riverpod
TimetableEditUseCase timetableEditUseCase(Ref ref, int tableId) {
  return TimetableEditUseCase(
    tableId,
    ref.watch(timetableRepositoryProvider),
    ref.watch(undoRedoProvider(tableId).notifier),
  );
}

/// UseCase for editing a timetable.
/// Coordinates [TimetableRepository] (persistence) and [UndoRedoHandler] (state).
class TimetableEditUseCase {
  TimetableEditUseCase(this._tableId, this._repo, this._undoRedo);

  final int _tableId;
  final TimetableRepository _repo;
  final UndoRedoHandler<TimetableSnapshot> _undoRedo;

  /// Pushes the current table state onto the undo stack.
  Future<void> pushUndoSnapshot() async {
    final entries = await _repo.getByTableId(_tableId);
    _undoRedo.pushSnapshot(entries.toCellIdMap());
  }

  Future<void> undo() async {
    final current = await _repo.getByTableId(_tableId);
    final snapshot = _undoRedo.popUndo(current.toCellIdMap());
    if (snapshot == null) return;
    await _repo.restoreSnapshot(_tableId, snapshot);
  }

  Future<void> redo() async {
    final current = await _repo.getByTableId(_tableId);
    final snapshot = _undoRedo.popRedo(current.toCellIdMap());
    if (snapshot == null) return;
    await _repo.restoreSnapshot(_tableId, snapshot);
  }

  /// Clears the whole table (with an undo snapshot).
  Future<void> clearTable() async {
    await pushUndoSnapshot();
    await _repo.clearTable(_tableId);
  }
}
