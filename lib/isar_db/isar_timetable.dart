import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/isar_db/isar_provider.dart';

part '../generated/isar_db/isar_timetable.g.dart';

@Collection()
class Timetable {
  Id? id;

  late int tableId;
  late int cellId;
  late String subject;
  String room = "";
  String teacher = "";
  String note = "";

  Timetable();

  Timetable.from({this.id, required this.cellId, required this.subject, required this.room, required this.teacher});

  Timetable.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        tableId = map["tableId"],
        cellId = map["cellId"],
        subject = map["subject"],
        room = map["room"],
        teacher = map["teacher"],
        note = map["note"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tableId": tableId,
      "cellId": cellId,
      "subject": subject,
      "room": room,
      "teacher": teacher,
      "note": note,
    };
  }
}

class TimetableProvider extends IsarProvider<Timetable> {
  late int currentTableId;

  static List<Map<int, Timetable>> undoList = [];
  static List<Map<int, Timetable>> redoList = [];

  Future<List<Timetable>> getCurrentTable() async {
    return await getTableByTableId(currentTableId);
  }

  Future<List<Timetable>> getTableByTableId(int tableId) async {
    return await this.collection.filter().tableIdEqualTo(tableId).findAll();
  }

  Future<void> putToCurrentTable(Timetable data) async {
    await put(data..tableId = currentTableId);
  }

  Future<void> deleteFromCurrentTable(int cellId) async {
    var data = await this.collection
        .filter()
        .cellIdEqualTo(cellId)
        .and()
        .tableIdEqualTo(currentTableId)
        .findFirst();
    if (data != null) {
      await this.collection.delete(data.id!);
    }
    deleteFirestoreByCellId(cellId);
  }

  Future<void> deleteAllInTableLocalOnly(int tableId) async {
    var data = await this.collection.filter().tableIdEqualTo(tableId).findAll();
    await this.collection.deleteAll(data.map((e) => e.id!).toList());
  }

  Future<void> clearCurrentTable() {
    FirestoreProvider.timetable.set(currentTableId.toString(),
        {"cells": FieldValue.delete()}, SetOptions(merge: true));
    return this.collection.clear();
  }

  Future<void> deleteFirestoreByCellId(int cellId) async {
    await FirestoreProvider.timetable.set(
        currentTableId.toString(),
        {
          "cells": {cellId.toString(): FieldValue.delete()},
        },
        SetOptions(merge: true));
  }

  @override
  Future<void> deleteFirestore(int id) async {
    // do nothing
  }

  @override
  Future<void> setFirestore(Timetable data, int id) async {
    await FirestoreProvider.timetable.set(
        data.tableId.toString(),
        {
          "cells": {
            data.cellId.toString(): data.toMap(),
          },
        },
        SetOptions(merge: true));
  }

  @override
  Future<void> use(
      Future<void> Function(TimetableProvider provider) callback) async {
    currentTableId = SharedPrefs(await SharedPreferences.getInstance())
        .intCurrentTimetableId;
    await open();
    await callback(this);
  }
}
