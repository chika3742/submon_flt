import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;
import 'package:isar/isar.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/isar_db/isar_provider.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/main.dart';

part '../generated/isar_db/isar_submission.g.dart';

@Collection()
class Submission {
  @Id()
  int? id;

  late String title;
  late String details;
  late DateTime due;
  bool done = false;
  bool important = false;
  @RepeatConverter()
  Repeat repeat = Repeat.none;
  @ColorConverter()
  late Color color;
  String? googleTasksTaskId;
  int? canvasPlannableId;

  Submission();

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "details": details,
      "due": due.toUtc().toIso8601String(),
      "done": done,
      "important": important,
      "repeat": const RepeatConverter().toIsar(repeat),
      "color": const ColorConverter().toIsar(color),
      "googleTasksTaskId": googleTasksTaskId,
      "canvasPlannableId": canvasPlannableId,
    };
  }

  Submission.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        details = map["details"],
        due = DateTime.parse(map["due"]).toLocal(),
        done = map["done"],
        important = map["important"],
        repeat = const RepeatConverter().fromIsar(map["repeat"]),
        color = const ColorConverter().fromIsar(map["color"]),
        googleTasksTaskId = map["googleTasksTaskId"],
        canvasPlannableId = map["canvasPlannableId"];
}

class RepeatConverter extends TypeConverter<Repeat, int> {
  const RepeatConverter();

  @override
  Repeat fromIsar(int object) {
    return Repeat.values[object];
  }

  @override
  int toIsar(Repeat object) {
    return object.index;
  }
}

enum Repeat {
  none,
  weekly,
  monthly,
}

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromIsar(int object) {
    return Color(object);
  }

  @override
  int toIsar(Color object) {
    return object.value;
  }
}

class SubmissionProvider extends IsarProvider<Submission> {
  @override
  Future<void> use(void Function(SubmissionProvider provider) callback) async {
    await open();
    callback(this);
  }

  Future<List<Submission>> getUndoneSubmissions() {
    return isar.submissions.filter().doneEqualTo(false).sortByDue().findAll();
  }

  Future<List<Submission>> getDoneSubmissions() {
    return isar.submissions
        .filter()
        .doneEqualTo(true)
        .sortByDueDesc()
        .findAll();
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
  Future<void> setFirestore(Submission data) {
    return FirestoreProvider.submission
        .set(data.id.toString(), data, SetOptions(merge: true));
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
