import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:sqflite/sqflite.dart';
import 'package:submon/db/firestore.dart';
import 'package:submon/db/sql_provider.dart';

const tableSubmission = "submission";

const colId = "id";
const colTitle = "title";
const colDate = "date";
const colDetail = "detail";
const colDone = "done";
const colImportant = "important";
const colRepeat = "repeat";
const colColor = "color";

class Submission {
  int? id;
  DateTime? date = DateTime.now();
  String title;
  String detail;
  bool done;
  bool important;
  Repeat repeat;
  Color color;

  Submission({
    this.id,
    this.date,
    this.title = "",
    this.detail = "",
    this.done = false,
    this.important = false,
    this.repeat = Repeat.none,
    this.color = Colors.white,
  });
}

class SubmissionProvider extends SqlProvider<Submission> {
  final _formatter = DateFormat("yyyy/MM/dd HH:mm", "ja_JP");

  @override
  String tableName() => "submission";

  @override
  List<SqlField> columns() => [
        SqlField(colId, DataType.integer, isPrimaryKey: true),
        SqlField(colDate, DataType.string),
        SqlField(colTitle, DataType.string),
        SqlField(colDetail, DataType.string),
        SqlField(colDone, DataType.bool),
        SqlField(colImportant, DataType.bool),
        SqlField(colColor, DataType.integer),
        SqlField(colRepeat, DataType.integer),
      ];

  @override
  Submission mapToObj(Map map) {
    return Submission(
      id: map[colId],
      date: _formatter.parse(map[colDate]),
      title: map[colTitle],
      detail: map[colDetail],
      done: map[colDone] == 1,
      important: map[colImportant] == 1,
      color: Color(map[colColor]),
      repeat: Repeat.values[map[colRepeat]],
    );
  }

  @override
  Map<String, Object?> objToMap(Submission data) {
    return {
      colId: data.id,
      colDate: _formatter.format(data.date!),
      colTitle: data.title,
      colDetail: data.detail,
      colDone: data.done == true ? 1 : 0,
      colImportant: data.important == true ? 1 : 0,
      colColor: data.color.value,
      colRepeat: data.repeat.index,
    };
  }

  @override
  void setFirestore(Submission data) {
    FirestoreProvider.submission.set(data.id.toString(), objToMap(data));
  }

  @override
  void deleteFirestore(int id) {
    FirestoreProvider.submission.delete(id.toString());
  }

  @override
  void deleteAllFirestore() {
    // TODO: implement deleteAllFirestore
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {
    // TODO: implement setAllFirestore
  }

  @override
  void migrate(Database db, int oldVersion, int newVersion) {}
}

enum Repeat {
  none, weekly, monthly
}