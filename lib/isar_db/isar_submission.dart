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
import 'package:submon/method_channel/main.dart';

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
  @Enumerated(EnumType.value, 'value')
  Repeat repeat = Repeat.none;
  @Enumerated(EnumType.value, 'value')
  SubmissionColor color = SubmissionColor.white;
  String? googleTasksTaskId;
  int? canvasPlannableId;
  bool? repeatSubmissionCreated;

  @ignore
  Color get uiColor => Color(color.value);

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
      "repeat": repeat.value,
      "color": color.value,
      "googleTasksTaskId": googleTasksTaskId,
      "canvasPlannableId": canvasPlannableId,
      "repeatSubmissionCreated": repeatSubmissionCreated,
    };
  }

  Color getColorToDisplay(SharedPrefs? pref) {
    if (canvasPlannableId != null && color.value == 0xFFFFFFFF) {
      return pref?.colorSubmissionsAddedFromLms ?? Color(color.value);
    }
    return Color(color.value);
  }

  Submission.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        details = map["details"],
        due = DateTime.parse(map["due"]).toLocal(),
        done = map["done"] is bool ? map["done"] : map["done"] == 1,
        important = map["important"],
        repeat = Repeat.of(map["repeat"]),
        color = SubmissionColor.of(map["color"]),
        googleTasksTaskId = map["googleTasksTaskId"],
        canvasPlannableId = map["canvasPlannableId"],
        repeatSubmissionCreated = map["repeatSubmissionCreated"];
}

enum Repeat {
  none(0),
  weekly(1),
  monthly(2);

  const Repeat(this.value);

  factory Repeat.of(short value) {
    return Repeat.values.firstWhere((e) => e.value == value);
  }

  final short value;
}

enum SubmissionColor {
  white(0xFFFFFFFF),
  pink(0xFFE91E63),
  red(0xFFF44336),
  deepOrange(0xFFFF5722),
  orange(0xFFFF9800),
  amber(0xFFFFC107),
  lime(0xFFCDDC39),
  lightGreen(0xFF8BC34A),
  green(0xFF4CAF50),
  teal(0xFF009688),
  cyan(0xFF00BCD4),
  blue(0xFF2196F3);

  const SubmissionColor(this.value);

  factory SubmissionColor.of(short value) {
    return SubmissionColor.values.firstWhere((e) => e.value == value);
  }

  final int value;
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
    return this
        .collection
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
    MainMethodPlugin.updateWidgets();
  }
}
