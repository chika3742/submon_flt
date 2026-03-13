import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../isar_db/isar_timetable.dart";
import "../isar_db/isar_timetable_class_time.dart";
import "../isar_db/isar_timetable_table.dart";
import "../repositories/timetable_class_time_repository.dart";
import "../repositories/timetable_repository.dart";
import "../repositories/timetable_table_repository.dart";
import "core_providers.dart";

part "timetable_providers.g.dart";

// --- Repository providers ---

@riverpod
TimetableRepository timetableRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return TimetableRepository(isar);
}

@riverpod
TimetableTableRepository timetableTableRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return TimetableTableRepository(isar);
}

@riverpod
TimetableClassTimeRepository timetableClassTimeRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  return TimetableClassTimeRepository(isar);
}

// --- Current table ID ---

@riverpod
class CurrentTableId extends _$CurrentTableId {
  static const _key = "intCurrentTimetableId";

  @override
  int build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getInt(_key) ?? -1;
  }

  Future<void> update(int id) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_key, id);
    state = id;
  }
}

// --- Data streams ---

@riverpod
Stream<List<TimetableTable>> timetableTables(Ref ref) {
  final repo = ref.watch(timetableTableRepositoryProvider);
  return repo.collection.where().watch(fireImmediately: true);
}

@riverpod
Stream<List<TimetableClassTime>> classTimes(Ref ref) {
  final repo = ref.watch(timetableClassTimeRepositoryProvider);
  return repo.collection.where().watch(fireImmediately: true);
}

/// 指定テーブルのセル一覧。
@riverpod
Stream<List<Timetable>> timetableCells(Ref ref, int tableId) {
  final repo = ref.watch(timetableRepositoryProvider);
  return repo.collection
      .filter()
      .tableIdEqualTo(tableId)
      .watch(fireImmediately: true);
}

typedef TimetableSnapshot = Map<int, Timetable>;

/// [List<Timetable>] を cellId キーの [Map] に変換する。
extension TimetableCellIdMap on List<Timetable> {
  TimetableSnapshot toCellIdMap() => {for (final e in this) e.cellId: e};
}

/// 現在選択中のテーブルのセル一覧 (cellId → Timetable)。
/// [timetableCellsProvider] に依存し、Map に変換する。
@riverpod
TimetableSnapshot currentTimetable(Ref ref) {
  final tableId = ref.watch(currentTableIdProvider);
  final cells = ref.watch(timetableCellsProvider(tableId)).value ?? [];
  return cells.toCellIdMap();
}

// --- Undo/Redo ---

/// テスト用にモック可能な Undo/Redo インターフェース。
abstract interface class UndoRedoHandler<T> {
  void pushSnapshot(T snapshot);
  T? popUndo(T current);
  T? popRedo(T current);
  void clear();
}

/// Undo/Redo スタックの SSoT。
@riverpod
class UndoRedo extends _$UndoRedo implements UndoRedoHandler<TimetableSnapshot> {
  @override
  ({List<TimetableSnapshot> undoStack, List<TimetableSnapshot> redoStack})
      build() {
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

// --- UseCase ---

@riverpod
TimetableEditUseCase timetableEditUseCase(Ref ref) {
  return TimetableEditUseCase(
    ref.watch(timetableRepositoryProvider),
    ref.watch(undoRedoProvider.notifier),
  );
}

/// Timetable 編集の UseCase。
/// [TimetableRepository] (データ永続化) と [UndoRedoHandler] (状態) を協調させる。
class TimetableEditUseCase {
  TimetableEditUseCase(this._repo, this._undoRedo);

  final TimetableRepository _repo;
  final UndoRedoHandler<TimetableSnapshot> _undoRedo;

  /// 現在のテーブル状態を undo スタックに積む。
  Future<void> pushUndoSnapshot(int tableId) async {
    final entries = await _repo.getByTableId(tableId);
    _undoRedo.pushSnapshot(entries.toCellIdMap());
  }

  Future<void> undo(int tableId) async {
    final current = await _repo.getByTableId(tableId);
    final snapshot = _undoRedo.popUndo(current.toCellIdMap());
    if (snapshot == null) return;
    await _repo.restoreSnapshot(tableId, snapshot);
  }

  Future<void> redo(int tableId) async {
    final current = await _repo.getByTableId(tableId);
    final snapshot = _undoRedo.popRedo(current.toCellIdMap());
    if (snapshot == null) return;
    await _repo.restoreSnapshot(tableId, snapshot);
  }

  /// テーブルを全クリア (undo スナップショット付き)。
  Future<void> clearTable(int tableId) async {
    await pushUndoSnapshot(tableId);
    await _repo.clearTable(tableId);
  }
}
