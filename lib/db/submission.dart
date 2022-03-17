import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as c;
import "package:intl/intl.dart";
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/main.dart';
import 'package:submon/utils/utils.dart';

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
  Future<List<Submission>> getAll({String? where, List? whereArgs, bool sortDescending = false}) async {
    var list = await super.getAll(where: where, whereArgs: whereArgs);
    // sort by date
    list.sort((a, b) {
      if (a.date!.isAfter(b.date!)) {
        if (!sortDescending) {
          return 1;
        } else {
          return 0;
        }
      } else {
        if (!sortDescending) {
          return 0;
        } else {
          return 1;
        }
      }
    });
    // sort by Star
    list.sort((a, b) {
      if (a.important == true && b.important == false) {
        return -1;
      } else if (a.important == false && b.important == true) {
        return 1;
      } else {
        return 0;
      }
    });
    return list;
  }

  @override
  Future<Submission> insert(Submission data) {
    return super.insert(data);
  }

  @override
  void setFirestore(Submission data) {
    FirestoreProvider.submission
        .set(data.id.toString(), objToMap(data), SetOptions(merge: true));
    // NotificationMethodChannel.registerReminder();
    updateWidgets();
  }

  @override
  void deleteFirestore(int id) {
    FirestoreProvider.submission.delete(id.toString());
    // NotificationMethodChannel.registerReminder();
    updateWidgets();

    googleSignIn.authenticatedClient().then((client) async {
      if (client != null) {
        var api = c.CalendarApi(client).events;

        var event = await api.getEventForSubmissionId(id);
        if (event != null) {
          api.delete("primary", event.id!);
        }
      }
    });
  }

  @override
  void deleteAllFirestore() {}

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {}
}

enum Repeat {
  none, weekly, monthly
}