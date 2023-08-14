import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;
import 'package:isar/isar.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/isar_db/isar_digestive.dart';
import 'package:submon/isar_db/isar_provider.dart';
import 'package:submon/main.dart';
import 'package:submon/src/pigeons.g.dart';

import '../db/shared_prefs.dart';

part '../generated/isar_db/isar_submission.g.dart';

@Collection()
class Submission {
  Id? id;

  late String title;
  late String details;
  late DateTime due;
  bool done = false;
  bool important = false;
  @enumerated
  Repeat repeat = Repeat.none;
  int color = Colors.white.value;
  String? googleTasksTaskId;
  int? canvasPlannableId;
  bool? repeatSubmissionCreated;

  Submission() {
    var nextDate = DateTime.now()..add(const Duration(days: 1)).toLocal();
    due = DateTime(nextDate.year, nextDate.month, nextDate.day, 23, 59);
  }

  Submission.from({
    this.id,
    required this.title,
    required this.details,
    required this.due,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "details": details,
      "due": due.toUtc().toIso8601String(),
      "done": done,
      "important": important,
      "repeat": repeat.index,
      "color": color,
      "googleTasksTaskId": googleTasksTaskId,
      "canvasPlannableId": canvasPlannableId,
      "repeatSubmissionCreated": repeatSubmissionCreated,
    };
  }

  Color getColorToDisplay(SharedPrefs? pref) {
    if (canvasPlannableId != null && color == 0xFFFFFFFF) {
      return pref?.colorSubmissionsAddedFromLms ?? Color(color);
    }
    return Color(color);
  }

  Color getColor() {
    return Color(color);
  }

  Submission.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        details = map["details"],
        due = DateTime.parse(map["due"]).toLocal(),
        done = map["done"] is bool ? map["done"] : map["done"] == 1,
        important = map["important"],
        repeat = Repeat.values[map["repeat"]],
        color = map["color"],
        googleTasksTaskId = map["googleTasksTaskId"],
        canvasPlannableId = map["canvasPlannableId"],
        repeatSubmissionCreated = map["repeatSubmissionCreated"];
}

enum Repeat {
  none,
  weekly,
  monthly,
}

extension RepeatToLocaleString on Repeat {
  String toLocaleString() {
    switch (this) {
      case Repeat.none:
        return "なし";
      case Repeat.weekly:
        return "毎週";
      case Repeat.monthly:
        return "毎月";
    }
  }
}

class SubmissionProvider extends IsarProvider<Submission> {
  @override
  Future<void> use(
      Future<void> Function(SubmissionProvider provider) callback) async {
    await open();
    try {
      await callback(this);
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrint(st.toString());
      rethrow;
    }
  }

  Future<List<Submission>> getUndoneSubmissions() {
    return this.collection
        .filter()
        .doneEqualTo(false)
        .sortByImportantDesc()
        .thenByDue()
        .findAll();
  }

  Future<List<Submission>> getDoneSubmissions() {
    return this.collection.filter().doneEqualTo(true).sortByDueDesc().findAll();
  }

  Future<void> invertDone(Submission data) {
    return put(data..done = !data.done);
  }

  @Deprecated("Use deleteItem")
  @override
  Future<void> delete(int id) async {
    await super.delete(id);
  }

  ///
  /// [writeTransaction] でラップしないこと。
  ///
  Future<void> deleteItem(int id) async {
    await writeTransaction(() async {
      // ignore: deprecated_member_use_from_same_package
      await delete(id);
    });
    await DigestiveProvider().use((provider) async {
      await provider.deleteBySubmissionId(id);
    });
  }

  static void deleteFromGoogleTasks(String? taskId) {
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
  Future<void> setFirestore(Submission data, int id) {
    return FirestoreProvider.submission
        .set(id.toString(), data.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteFirestore(int id) {
    return FirestoreProvider.submission.delete(id.toString());
  }

  @override
  void firestoreUpdated() {
    GeneralApi().updateWidgets();
  }
}
