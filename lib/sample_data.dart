import 'package:flutter/material.dart';
import 'package:submon/utils/date_time_utils.dart';

import 'isar_db/isar_digestive.dart';
import 'isar_db/isar_submission.dart';
import 'isar_db/isar_timetable.dart';

class SampleData {
  SampleData._();

  static final submissions = [
    Submission.from(
        id: 0,
        title: "提出物1",
        details: "p.40〜44",
        due: DateTime.now()
            .add(const Duration(hours: 10))
            .applied(const TimeOfDay(hour: 17, minute: 0)),
        color: Colors.white),
    Submission.from(
        id: 1,
        title: "提出物2",
        details: "p.40〜44",
        due: DateTime.now()
            .add(const Duration(days: 1))
            .applied(const TimeOfDay(hour: 23, minute: 59)),
        color: Colors.red),
    Submission.from(
        id: 2,
        title: "提出物3",
        details: "p.40〜44",
        due: DateTime.now()
            .add(const Duration(days: 8))
            .applied(const TimeOfDay(hour: 23, minute: 59)),
        color: Colors.blue),
  ];

  static final timetable = [
    Timetable.from(
      cellId: 0,
      subject: "国語",
      room: "3-1",
      teacher: "佐藤",
    ),
    Timetable.from(
      cellId: 6,
      subject: "数学",
      room: "3-2",
      teacher: "鈴木",
    ),
    Timetable.from(
      cellId: 12,
      subject: "化学",
      room: "3-3",
      teacher: "高橋",
    ),
    Timetable.from(
      cellId: 18,
      subject: "世界史",
      room: "3-4",
      teacher: "田中",
    ),
    Timetable.from(
      cellId: 0,
      subject: "(一例です)",
      room: "",
      teacher: "出典: 名字由来net",
    ),
  ];

  static final digestives = [
    Digestive.from(
      id: 0,
      submissionId: 0,
      startAt: DateTime.now()
          .add(const Duration(days: 1))
          .applied(const TimeOfDay(hour: 16, minute: 0)),
      minute: 30,
      content: "p.40〜42",
    ),
    Digestive.from(
      id: 1,
      submissionId: 1,
      startAt: DateTime.now()
          .add(const Duration(days: 1))
          .applied(const TimeOfDay(hour: 18, minute: 0)),
      minute: 45,
      content: "p.55〜70",
    ),
    Digestive.from(
      id: 2,
      submissionId: 1,
      startAt: DateTime.now()
          .add(const Duration(days: 1))
          .applied(const TimeOfDay(hour: 18, minute: 0)),
      minute: 20,
      content: "p.71〜76",
    ),
    Digestive.from(
      id: 3,
      startAt: DateTime.now()
          .add(const Duration(days: 1))
          .applied(const TimeOfDay(hour: 20, minute: 0)),
      minute: 20,
      content: "数学の復習",
    ),
  ];
}
