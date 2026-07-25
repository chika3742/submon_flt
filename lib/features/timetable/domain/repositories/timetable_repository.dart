import "package:flutter/material.dart";

import "../models/timetable_cell.dart";
import "../models/timetable_class_time.dart";
import "../models/timetable_table.dart";

abstract interface class TimetableRepository {
  Stream<TimetableCells> watchTable(int tableId);

  Future<TimetableCell> getCell(int tableId, int period, int weekday);

  Future<void> upsertCell(TimetableCell cell);

  Future<void> deleteCell(TimetableCell cell);

  Stream<TimetableTable> watchTables();

  Future<void> upsertTable(TimetableTable table);

  Future<void> deleteTable(TimetableTable table);

  Stream<TimetableClassTimes> watchClassTimes();

  Future<void> setClassTime(int period, TimeOfDay start, TimeOfDay end);

  Future<void> clearClassTime(int period);
}
