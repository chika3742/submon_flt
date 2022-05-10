import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences? pref;

  SharedPrefs(this.pref);

  // bool

  // IS_ANALYTICS_ENABLED
  bool get isAnalyticsEnabled => pref!.getBool("IS_ANALYTICS_ENABLED") ?? true;

  set isAnalyticsEnabled(bool value) =>
      pref!.setBool("IS_ANALYTICS_ENABLED", value);

  // IS_SE_ENABLED
  bool get isSEEnabled => pref!.getBool("IS_SE_ENABLED") ?? true;

  set isSEEnabled(bool value) => pref!.setBool("IS_SE_ENABLED", value);

  // DEVICE_CAMERA_UI_SHOULD_BE_USED
  bool get deviceCameraUIShouldBeUsed {
    if (Platform.isAndroid) {
      return pref!.getBool("DEVICE_CAMERA_UI_SHOULD_BE_USED") ?? false;
    }
    return false;
  }

  set deviceCameraUIShouldBeUsed(bool value) =>
      pref!.setBool("DEVICE_CAMERA_UI_SHOULD_BE_USED", value);

  // IS_TIMETABLE_BANNER_1_DISPLAYED
  bool get isTimetableBanner1Displayed =>
      pref!.getBool("IS_TIMETABLE_BANNER_1_DISPLAYED") ?? false;

  set isTimetableBanner1Displayed(bool value) =>
      pref!.setBool("IS_TIMETABLE_BANNER_1_DISPLAYED", value);

  // IS_SUBMISSION_SWIPE_TIPS_DISPLAYED
  bool get isSubmissionSwipeTipsDisplayed =>
      pref!.getBool("IS_SUBMISSION_SWIPE_TIPS_DISPLAYED") ?? false;

  set isSubmissionSwipeTipsDisplayed(bool value) =>
      pref!.setBool("IS_SUBMISSION_SWIPE_TIPS_DISPLAYED", value);

  // IS_SUBMISSION_LONG_PRESS_TIPS_DISPLAYED
  bool get isSubmissionLongPressTipsDisplayed =>
      pref!.getBool("IS_SUBMISSION_LONG_PRESS_TIPS_DISPLAYED") ?? false;

  set isSubmissionLongPressTipsDisplayed(bool value) =>
      pref!.setBool("IS_SUBMISSION_LONG_PRESS_TIPS_DISPLAYED", value);

  // IS_CAMERA_PRIVACY_POLICY_DISPLAYED
  bool get isCameraPrivacyPolicyDisplayed =>
      pref!.getBool("IS_CAMERA_PRIVACY_POLICY_DISPLAYED") ?? false;

  set isCameraPrivacyPolicyDisplayed(bool value) =>
      pref!.setBool("IS_CAMERA_PRIVACY_POLICY_DISPLAYED", value);

  // WRITE_GOOGLE_CALENDAR_BY_DEFAULT
  bool get writeGoogleCalendarByDefault =>
      pref!.getBool("WRITE_GOOGLE_CALENDAR_BY_DEFAULT") ?? false;

  set writeGoogleCalendarByDefault(bool value) =>
      pref!.setBool("WRITE_GOOGLE_CALENDAR_BY_DEFAULT", value);

  // SHOW_TIMETABLE_MENU
  bool get showTimetableMenu => pref!.getBool("SHOW_TIMETABLE_MENU") ?? true;

  set showTimetableMenu(bool value) =>
      pref!.setBool("SHOW_TIMETABLE_MENU", value);

  // SHOW_MEMORIZE_MENU
  bool get showMemorizeMenu => pref!.getBool("SHOW_MEMORIZE_MENU") ?? true;

  set showMemorizeMenu(bool value) =>
      pref!.setBool("SHOW_MEMORIZE_MENU", value);

  // SHOW_REVIEW_BTN
  bool get showReviewBtn => pref!.getBool("SHOW_REVIEW_BTN") ?? true;

  set showReviewBtn(bool value) => pref!.setBool("SHOW_REVIEW_BTN", value);

  // TIMETABLE_SHOW_SATURDAY
  bool get timetableShowSaturday =>
      pref!.getBool("TIMETABLE_SHOW_SATURDAY") ?? true;

  set timetableShowSaturday(bool value) =>
      pref!.setBool("TIMETABLE_SHOW_SATURDAY", value);

  // TIMETABLE_SHOW_CLASS_TIME
  bool get timetableShowClassTime =>
      pref!.getBool("TIMETABLE_SHOW_CLASS_TIME") ?? true;

  set timetableShowClassTime(bool value) =>
      pref!.setBool("TIMETABLE_SHOW_CLASS_TIME", value);

  // TIMETABLE_SHOW_TIME_MARKER
  bool get timetableShowTimeMarker =>
      pref!.getBool("TIMETABLE_SHOW_TIME_MARKER") ?? true;

  set timetableShowTimeMarker(bool value) =>
      pref!.setBool("TIMETABLE_SHOW_TIME_MARKER", value);

  // String

  // EMAIL_FOR_URL_SIGN_IN
  String? get emailForUrlLogin => pref!.getString("EMAIL_FOR_URL_SIGN_IN");

  set emailForUrlLogin(String? value) =>
      pref!.setString("EMAIL_FOR_URL_SIGN_IN", value!);

  // CURRENT_TIMETABLE_ID
  String get currentTimetableId =>
      pref!.getString("CURRENT_TIMETABLE_ID") ?? "main";

  set currentTimetableId(String value) =>
      pref!.setString("CURRENT_TIMETABLE_ID", value);

  // string list

  // TIMETABLE_HISTORY
  List<String> get timetableHistory =>
      pref!.getStringList("TIMETABLE_HISTORY") ?? [];

  set timetableHistory(List<String> value) =>
      pref!.setStringList("TIMETABLE_HISTORY", value);

  // int

  // TIMETABLE_HOUR
  int get timetableHour => pref!.getInt("TIMETABLE_HOUR") ?? 6;

  set timetableHour(int? value) => pref!.setInt("TIMETABLE_HOUR", value!);

  // SUBMISSION_CREATION_COUNT
  int get submissionCreationCount =>
      pref!.getInt("SUBMISSION_CREATION_COUNT") ?? 0;

  void incrementSubmissionCreationCount() {
    pref!.setInt("SUBMISSION_CREATION_COUNT", submissionCreationCount + 1);
  }

  // FIRESTORE_LAST_CHANGED
  DateTime get firestoreLastChanged => DateTime.fromMicrosecondsSinceEpoch(
      pref!.getInt("FIRESTORE_LAST_CHANGED") ?? 0);

  set firestoreLastChanged(DateTime? value) => value != null
      ? pref!.setInt("FIRESTORE_LAST_CHANGED", value.microsecondsSinceEpoch)
      : pref!.remove("FIRESTORE_LAST_CHANGED");

  // REMINDER_TIME_
  TimeOfDay? get reminderTime {
    final hour = pref!.getInt("REMINDER_TIME_HOUR");
    final minute = pref!.getInt("REMINDER_TIME_MINUTE");
    if (hour == null || minute == null) {
      return null;
    } else {
      return TimeOfDay(hour: hour, minute: minute);
    }
  }

  set reminderTime(TimeOfDay? value) {
    if (value != null) {
      pref!.setInt("REMINDER_TIME_HOUR", value.hour);
      pref!.setInt("REMINDER_TIME_MINUTE", value.minute);
    } else {
      pref!.remove("REMINDER_TIME_HOUR");
      pref!.remove("REMINDER_TIME_MINUTE");
    }
  }

  // TIMETABLE_NOTIFICATION_TIME_
  TimeOfDay? get timetableNotificationTime {
    final hour = pref!.getInt("TIMETABLE_NOTIFICATION_TIME_HOUR");
    final minute = pref!.getInt("TIMETABLE_NOTIFICATION_TIME_MINUTE");
    if (hour == null || minute == null) {
      return null;
    } else {
      return TimeOfDay(hour: hour, minute: minute);
    }
  }

  set timetableNotificationTime(TimeOfDay? value) {
    if (value != null) {
      pref!.setInt("TIMETABLE_NOTIFICATION_TIME_HOUR", value.hour);
      pref!.setInt("TIMETABLE_NOTIFICATION_TIME_MINUTE", value.minute);
    } else {
      pref!.remove("TIMETABLE_NOTIFICATION_TIME_HOUR");
      pref!.remove("TIMETABLE_NOTIFICATION_TIME_MINUTE");
    }
  }

  static use(dynamic Function(SharedPrefs prefs) callback) {
    SharedPreferences.getInstance().then((pref) {
      var prefs = SharedPrefs(pref);
      callback(prefs);
    });
  }
}
