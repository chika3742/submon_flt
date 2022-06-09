import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserConfig {
  int? schemaVersion;
  Timestamp? lastChanged;
  Timestamp? lastAppOpened;
  TimeOfDay? reminderNotificationTime;
  TimeOfDay? timetableNotificationTime;
  int? timetableNotificationId;
  int? digestiveNotificationTimeBefore;
  Lms? lms;
  TimetableConfig? timetable;
  bool? isSEEnabled;

  static const pathTimetableShowSaturday = "timetable.showSaturday";
  static const pathTimetablePeriodCountToDisplay = "timetable.periodCountToDisplay";
  static const pathIsSEEnabled = "isSEEnabled";

  UserConfig({
    this.schemaVersion,
    this.lastChanged,
    this.lastAppOpened,
    this.reminderNotificationTime,
    this.timetableNotificationTime,
    this.timetableNotificationId,
    this.digestiveNotificationTimeBefore,
    this.lms,
    this.timetable,
    this.isSEEnabled,
  });

  factory UserConfig.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();
    return UserConfig(
      schemaVersion: data?["schemaVersion"],
      lastChanged: data?["lastChanged"],
      lastAppOpened: data?["lastAppOpened"],
      reminderNotificationTime: () {
        final spilt = (data?["reminderNotificationTime"] as String?)?.split(":");
        return spilt != null ? TimeOfDay(hour: int.parse(spilt[0]), minute: int.parse(spilt[1])) : null;
      }(),
      timetableNotificationTime: () {
        final spilt = (data?["timetableNotificationTime"] as String?)?.split(":");
        return spilt != null ?TimeOfDay(hour: int.parse(spilt[0]), minute: int.parse(spilt[1])) : null;
      }(),
      timetableNotificationId: data?["timetableNotificationId"],
      digestiveNotificationTimeBefore: data?["digestiveNotificationTimeBefore"],
      lms: Lms.fromMap(data?["lms"]),
      timetable: TimetableConfig.fromMap(data?["timetable"]),
      isSEEnabled: data?["isSEEnabled"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {};
  }
}

class Lms {
  Canvas? canvas;

  Lms({this.canvas});

  static Lms? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Lms(
      canvas: Canvas.fromMap(map["canvas"]),
    );
  }
}

class Canvas {
  int? universityId;
  Timestamp? lastSync;
  bool? hasError;
  List<dynamic>? excludedPlannableIds;
  int? submissionColor;

  Canvas({
    this.universityId,
    this.lastSync,
    this.hasError,
    this.excludedPlannableIds,
    this.submissionColor,
  });

  static Canvas? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Canvas(
      universityId: map["universityId"],
      lastSync: map["lastSync"],
      hasError: map["hasError"],
      excludedPlannableIds: map["excludedPlannableIds"],
      submissionColor: map["submissionColor"],
    );
  }
}

class TimetableConfig {
  bool? showSaturday;
  int? periodCountToDisplay;

  TimetableConfig({this.showSaturday, this.periodCountToDisplay});

  static TimetableConfig? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return TimetableConfig(
      showSaturday: map["showSaturday"],
      periodCountToDisplay: map["periodCountToDisplay"],
    );
  }
}
