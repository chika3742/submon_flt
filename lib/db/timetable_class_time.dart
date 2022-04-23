import 'package:flutter/material.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/timetable.dart';

const tableTimetableClassTime = "timetableClassTime";
const colStart = "start";
const colEnd = "end";

class TimetableClassTime {
  // period
  int id;
  TimeOfDay start;
  TimeOfDay end;

  TimetableClassTime({
    required this.id,
    required this.start,
    required this.end,
  });
}

class TimetableClassTimeProvider extends SqlProvider<TimetableClassTime> {
  BuildContext context;

  TimetableClassTimeProvider(this.context);

  @override
  String tableName() => tableTimetableClassTime;

  @override
  List<SqlField> columns() => [
        SqlField(colId, DataType.integer, isPrimaryKey: true),
        SqlField(colStart, DataType.string),
        SqlField(colEnd, DataType.string),
      ];

  @override
  void deleteAllFirestore() {}

  @override
  Future<void> deleteFirestore(int id) async {
    // TODO: implement deleteFirestore
  }

  @override
  TimetableClassTime mapToObj(Map<String, dynamic> map) {
    return TimetableClassTime(
      id: map[colId],
      start: TimeOfDay(
          hour: int.parse(map[colStart].split(":")[0]),
          minute: int.parse(map[colStart].split(":")[1])),
      end: TimeOfDay(
          hour: int.parse(map[colEnd].split(":")[0]),
          minute: int.parse(map[colEnd].split(":")[1])),
    );
  }

  @override
  Map<String, Object?> objToMap(TimetableClassTime data) {
    return {
      colId: data.id,
      colStart: data.start.format(context),
      colEnd: data.end.format(context),
    };
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {
    // TODO: implement setAllFirestore
  }

  @override
  Future<void> setFirestore(TimetableClassTime data) async {}
}
