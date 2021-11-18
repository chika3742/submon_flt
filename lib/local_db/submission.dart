import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import "package:intl/intl.dart";

const tableSubmission = "submission";

// ここと
const colId = "id";
const colTitle = "title";
const colDate = "date";
const colDetail = "detail";
const colDone = "done";
const colImportant = "important";
const colRepeat = "repeat";
const colColor = "color";

// ここと
const allCols = [
  colId,
  colTitle,
  colDate,
  colDetail,
  colDone,
  colImportant,
  colRepeat,
  colColor,
];

class Submission {
  // ここと
  int? id;
  String title = "";
  DateTime? date = DateTime.now();
  String detail = "";
  bool done = false;
  bool important = false;
  Repeat? repeat = Repeat.none;
  Color? color = Colors.white;

  final _formatter = DateFormat("yyyy/MM/dd HH:mm", 'ja_JP');

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      // ここと
      colTitle: title,
      colDate: _formatter.format(date!),
      colDetail: detail,
      colDone: done == true ? 1 : 0,
      colImportant: important == true ? 1 : 0,
      colRepeat: repeat!.index,
      colColor: color!.value,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }

  Submission();

  Submission.fromMap(Map<String, dynamic> map) {
    // ここと
    id = map[colId];
    title = map[colTitle];
    date = map[colDate] != null ? _formatter.parse(map[colDate]) : null;
    if (map[colDetail] != null) detail = map[colDetail];
    done = map[colDone] == 1;
    important = map[colImportant] == 1;
    color = map[colColor] != null ? Color(map[colColor]) : null;
  }
}

class SubmissionProvider {
  static const schemaVer = 1;

  late Database db;

  SubmissionProvider();

  Future<void> open() async {
    db = await openDatabase("main.db", version: schemaVer, onCreate: (db, version) async {
      // ここに追加
      await db.execute('''create table $tableSubmission (
        $colId integer primary key autoincrement,
        $colTitle text not null,
        $colDate text not null,
        $colDetail text not null,
        $colDone integer not null,
        $colImportant integer not null,
        $colRepeat integer not null,
        $colColor integer not null
      )''');
    }, onUpgrade: _migrate, onDowngrade: onDatabaseDowngradeDelete);
  }

  Future<Submission?> getSubmission(int id, List<String> columns) async {
    var maps = await db.query(tableSubmission, columns: columns, where: "$colId = ?", whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Submission.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Submission>> getSubmissions(List<String> columns, {String? where, List<dynamic>? whereArgs}) async {
    var maps = await db.query(tableSubmission, columns: columns, where: where, whereArgs: whereArgs);
    return maps.map((e) => Submission.fromMap(e)).toList();
  }

  Future<Submission> insert(Submission data) async {
    data.id = await db.insert(tableSubmission, data.toMap());
    return data;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableSubmission, where: "$colId = ?", whereArgs: [id]);
  }

  Future<int> update(Submission data) async {
    return await db.update(tableSubmission, data.toMap(), where: "$colId = ?", whereArgs: [data.id]);
  }

  static use(dynamic Function(SubmissionProvider provider) fn) async {
    var provider = SubmissionProvider();
    await provider.open();
    await fn(provider);
    provider.close();
  }

  Future close() async => db.close();
}

/// Migration
Future _migrate(Database db, int oldVersion, int newVersion) async {
  // var batch = db.batch();
  if (oldVersion == 1) {
    // batch.execute("alter table $tableSubmission add ");
  }
}

enum Repeat {
  none, weekly, monthly
}