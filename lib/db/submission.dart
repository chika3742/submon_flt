import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;
import 'package:submon/db/digestive.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/main.dart';

const tableSubmission = "submission";

const colTitle = "title";
const colDate = "date";
const colDetail = "detail";
const colDone = "done";
const colImportant = "important";
const colRepeat = "repeat";
const colColor = "color";
const colGoogleTasksTaskId = "googleTasksTaskId";
const colCanvasPlannableId = "canvasPlannableId";

class Submission {
  int? id;
  DateTime? date = DateTime.now();
  String title;
  String detail;
  bool done;
  bool important;
  Repeat repeat;
  Color color;
  String? googleTasksTaskId;
  int? canvasPlannableId;

  Submission({
    this.id,
    this.date,
    this.title = "",
    this.detail = "",
    this.done = false,
    this.important = false,
    this.repeat = Repeat.none,
    this.color = Colors.white,
    this.googleTasksTaskId,
    this.canvasPlannableId,
  });
}

class SubmissionProvider extends SqlProvider<Submission> {
  @override
  String tableName() => "submission";

  @override
  List<SqlField> columns() =>
      [
        SqlField(colId, DataType.integer, isPrimaryKey: true),
        SqlField(colDate, DataType.string),
        SqlField(colTitle, DataType.string),
        SqlField(colDetail, DataType.string),
        SqlField(colDone, DataType.bool),
        SqlField(colImportant, DataType.bool),
        SqlField(colColor, DataType.integer),
        SqlField(colRepeat, DataType.integer),
        SqlField(colGoogleTasksTaskId, DataType.string, isNonNull: false),
        SqlField(colCanvasPlannableId, DataType.integer, isNonNull: false),
      ];

  @override
  Submission mapToObj(Map map) {
    var date = DateTime.parse(map[colDate]).toLocal();
    return Submission(
      id: map[colId],
      date: date,
      title: map[colTitle],
      detail: map[colDetail],
      done: map[colDone] == 1,
      important: map[colImportant] == 1,
      color: Color(map[colColor]),
      repeat: Repeat.values[map[colRepeat]],
      googleTasksTaskId: map[colGoogleTasksTaskId],
      canvasPlannableId: map[colCanvasPlannableId],
    );
  }

  @override
  Map<String, Object?> objToMap(Submission data) {
    return {
      colId: data.id,
      colDate: data.date!.toUtc().toIso8601String(),
      colTitle: data.title,
      colDetail: data.detail,
      colDone: data.done == true ? 1 : 0,
      colImportant: data.important == true ? 1 : 0,
      colColor: data.color.value,
      colRepeat: data.repeat.index,
      colGoogleTasksTaskId: data.googleTasksTaskId,
      colCanvasPlannableId: data.canvasPlannableId,
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
  Future<void> setFirestore(Submission data) async {
    await FirestoreProvider.submission
        .set(data.id.toString(), objToMap(data), SetOptions(merge: true));
    // NotificationMethodChannel.registerReminder();
    MainMethodPlugin.updateWidgets();
  }

  @override
  Future<void> deleteFirestore(int id) async {
    await FirestoreProvider.submission.delete(id.toString());
    await DigestiveProvider(db: db).deleteForSubmissionId(id);
    MainMethodPlugin.updateWidgets();
  }

  void deleteGoogleTasks(String? taskId) {
    if (taskId != null) {
      googleSignIn.authenticatedClient().then((client) async {
        if (client != null) {
          var tasksApi = tasks.TasksApi(client);

          var tasklist =
              (await tasksApi.tasklists.list(maxResults: 1)).items?.firstOrNull;
          if (tasklist != null) {
            tasksApi.tasks.delete(tasklist.id!, taskId);
          }
        }
      });
    }
  }

  @override
  void deleteAllFirestore() {}

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {}
}

enum Repeat {
  none, weekly, monthly
}