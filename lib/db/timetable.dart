import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/firestore.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/sql_provider.dart';

const tableTimetable = "timetable";
const colId = "id";
const colTableId = "tableId";
const colCellId = "cellId";
const colSubject = "subject";
const colNote = "note";

class Timetable {
  int? id;
  int? tableId;
  int cellId;
  String subject;
  String note;

  static var undoList = <Map<int, Timetable>>[];
  static var redoList = <Map<int, Timetable>>[];

  Timetable({
    this.id,
    this.tableId,
    required this.cellId,
    this.subject = "",
    this.note = "",
  });

  @override
  String toString() {
    return {
      "id": id,
      "tableId": tableId,
      "subject": subject,
      "note": note,
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
      note: map[colNote],
    );
  }

  @override
  Future<Timetable> insert(Timetable data) {
    if (currentTableId != "main") data.tableId = int.parse(currentTableId);
    return super.insert(data);
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
      colNote: data.note,
    };
  }

  @override
  void setFirestore(Timetable data) async {
    if (await FirestoreProvider.timetable.exists(currentTableId) == true) {
      FirestoreProvider.timetable.set(
          currentTableId,
          {
            "cells": {data.id.toString(): objToMap(data)}
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
  void deleteFirestore(int id) {
    FirestoreProvider.timetable.set(
        currentTableId,
        {
          "cells": {id.toString(): FieldValue.delete()}
        },
        SetOptions(merge: true));
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