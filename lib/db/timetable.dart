import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/sql_provider.dart';

const tableTimetable = "timetable";
const colTableId = "tableId";
const colCellId = "cellId";
const colSubject = "subject";
const colRoom = "room";
const colTeacher = "teacher";
const colNote = "note";

class Timetable {
  int? id;
  int? tableId;
  int cellId;
  String subject;
  String room;
  String teacher;
  String note;

  static var undoList = <Map<int, Timetable>>[];
  static var redoList = <Map<int, Timetable>>[];

  Timetable({
    this.id,
    this.tableId,
    required this.cellId,
    required this.subject,
    this.room = "",
    this.teacher = "",
    this.note = "",
  });

  @override
  String toString() {
    return {
      "id": id,
      "tableId": tableId,
      "cellId": cellId,
      "subject": subject,
    }.toString();
  }
}

class TimetableProvider extends SqlProvider<Timetable> {
  late String currentTableId;

  @override
  String tableName() => tableTimetable;

  @override
  List<SqlField> columns() {
    return [
      SqlField(colId, DataType.integer, isPrimaryKey: true),
      SqlField(colTableId, DataType.integer, isNonNull: false),
      SqlField(colCellId, DataType.integer),
      SqlField(colSubject, DataType.string),
      SqlField(colRoom, DataType.string),
      SqlField(colTeacher, DataType.string),
      SqlField(colNote, DataType.string),
    ];
  }

  @override
  Timetable mapToObj(Map map) {
    return Timetable(
      id: map[colId],
      tableId: map[colTableId],
      cellId: map[colCellId],
      subject: map[colSubject],
      room: map[colRoom],
      teacher: map[colTeacher],
      note: map[colNote] ?? "",
    );
  }

  Future<List<Timetable>> getCurrentTimetable() async {
    if (currentTableId != "main") {
      return await getAll(
          where: "$colTableId = ?", whereArgs: [currentTableId]);
    } else {
      return await getAll(where: "$colTableId is null");
    }
  }

  @override
  Future<Timetable> insert(Timetable data) async {
    if (currentTableId != "main") data.tableId = int.parse(currentTableId);
    await deleteLocal(data.cellId);
    SharedPrefs.use((prefs) {
      prefs.isTimetableInsertedOnce = true;
    });
    return await super.insert(data);
  }

  Future<void> deleteLocal(int cellId) async {
    if (currentTableId != "main") {
      await db.delete(tableName(),
          where: "$colCellId = ? and $colTableId = ?",
          whereArgs: [cellId, currentTableId]);
    } else {
      await db.delete(tableName(),
          where: "$colCellId = ? and $colTableId is null", whereArgs: [cellId]);
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<int> delete(int cellId) async {
    deleteLocal(cellId);
    deleteFirestore(cellId);
    return cellId;
  }

  @override
  Map<String, Object?> objToMap(Timetable data) {
    return objToMapStatic(data);
  }

  static Map<String, Object?> objToMapStatic(Timetable data) {
    return {
      colId: data.id,
      colTableId: data.tableId,
      colCellId: data.cellId,
      colSubject: data.subject,
      colRoom: data.room,
      colTeacher: data.teacher,
      colNote: data.note,
    };
  }

  @override
  Future<void> setFirestore(Timetable data) async {
    if (await FirestoreProvider.timetable.exists(currentTableId) == true ||
        currentTableId == "main") {
      await FirestoreProvider.timetable.set(
          currentTableId,
          {
            "cells": {data.cellId.toString(): objToMap(data)}
          },
          SetOptions(merge: true));
    }
  }

  @override
  Future<void> deleteAll() async {
    deleteAllFirestore();
    if (currentTableId != "main") {
      await db.execute(
          "delete from ${tableName()} where $colTableId = $currentTableId");
    } else {
      await db.execute("delete from ${tableName()} where $colTableId is null");
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> deleteFirestore(int cellId) async {
    await FirestoreProvider.timetable.set(
      currentTableId,
      {
        "cells": {cellId.toString(): FieldValue.delete()}
      },
      SetOptions(merge: true),
    );
  }

  @override
  void deleteAllFirestore() {
    FirestoreProvider.timetable.set(currentTableId,
        {"cells": FieldValue.delete()}, SetOptions(merge: true));
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {
    FirestoreProvider.timetable.set(currentTableId, {
      "cells": Map.fromIterables(
          list.map((e) => e["id"].toString()), list.map((e) => e))
    });
  }

  @override
  Future<void> use(Function(SqlProvider<Timetable> provider) fn) async {
    var pref = await SharedPreferences.getInstance();
    var id = SharedPrefs(pref).currentTimetableId;
    currentTableId = id;
    return await super.use(fn);
  }
}