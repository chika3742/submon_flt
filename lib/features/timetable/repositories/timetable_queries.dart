import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/pref_key.dart";
import "../models/timetable.dart";
import "../models/timetable_class_time.dart";
import "../models/timetable_table.dart";
import "timetable_providers.dart";

part "timetable_queries.g.dart";

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

/// Cells of the given table.
@riverpod
Stream<List<Timetable>> timetableCells(Ref ref, int tableId) {
  final repo = ref.watch(timetableRepositoryProvider);
  return repo.collection
      .filter()
      .tableIdEqualTo(tableId)
      .watch(fireImmediately: true);
}

/// Cells of the currently selected table (cellId -> Timetable).
/// Depends on [timetableCellsProvider] and converts it into a [Map].
@riverpod
TimetableSnapshot currentTimetable(Ref ref) {
  final tableId = ref.watchPref(PrefKey.intCurrentTimetableId);
  final cells = ref.watch(timetableCellsProvider(tableId)).value ?? [];
  return cells.toCellIdMap();
}
