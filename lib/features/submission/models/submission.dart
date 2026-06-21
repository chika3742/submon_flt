import "package:flutter/material.dart";
import "package:isar_community/isar.dart";

part "submission.g.dart";

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

  Color getColor() {
    return Color(color);
  }
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
