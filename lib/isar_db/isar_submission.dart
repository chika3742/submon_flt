import "package:flutter/material.dart";
import "package:isar_community/isar.dart";


part "isar_submission.g.dart";

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
  int color = Colors.white.toARGB32();
  String? googleTasksTaskId;
  int? canvasPlannableId;
  bool? repeatSubmissionCreated;

  Submission() {
    final nextDate = DateTime.now()..add(const Duration(days: 1)).toLocal();
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
