import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences? pref;

  SharedPrefs(this.pref) {
    if (pref!.containsKey("timetableHour")) {
      // ignore: deprecated_member_use_from_same_package
      timetablePeriodCountToDisplay = timetableHour;
      pref!.remove("timetableHour");
    }
  }

  // bool

  // isAnalyticsEnabled
  bool get isAnalyticsEnabled => pref!.getBool("isAnalyticsEnabled") ?? true;

  set isAnalyticsEnabled(bool value) =>
      pref!.setBool("isAnalyticsEnabled", value);

  /// 時間割が1回以上挿入されたことを示すフラグ。バナー表示用。
  bool get isTimetableInsertedOnce =>
      pref!.getBool("isTimetableInsertedOnce") ?? false;

  set isTimetableInsertedOnce(bool value) =>
      pref!.setBool("isTimetableInsertedOnce", value);

  /// 「時間割を長押しで・・・」バナー表示フラグ。
  bool get isTimetableTipsDisplayed =>
      pref!.getBool("isTimetableTipsDisplayed") ?? false;

  set isTimetableTipsDisplayed(bool value) =>
      pref!.setBool("isTimetableTipsDisplayed", value);

  // isSubmissionTipsDisplayed
  bool get isSubmissionTipsDisplayed =>
      pref!.getBool("isSubmissionTipsDisplayed") ?? false;

  set isSubmissionTipsDisplayed(bool value) =>
      pref!.setBool("isSubmissionTipsDisplayed", value);

  /// Google Tasks同期スイッチのデフォルト設定バナー表示フラグ
  bool get isWriteToGoogleTasksTipsDisplayed =>
      pref!.getBool("isWriteToGoogleTasksTipsDisplayed") ?? false;

  set isWriteToGoogleTasksTipsDisplayed(bool value) =>
      pref!.setBool("isWriteToGoogleTasksTipsDisplayed", value);

  // isCameraPrivacyPolicyDisplayed
  bool get isCameraPrivacyPolicyDisplayed =>
      pref!.getBool("isCameraPrivacyPolicyDisplayed") ?? false;

  set isCameraPrivacyPolicyDisplayed(bool value) =>
      pref!.setBool("isCameraPrivacyPolicyDisplayed", value);

  /// Google Tasks同期スイッチのデフォルト設定
  bool get isWriteToGoogleTasksByDefault =>
      pref!.getBool("isWriteToGoogleTasksByDefault") ?? false;

  set isWriteToGoogleTasksByDefault(bool value) =>
      pref!.setBool("isWriteToGoogleTasksByDefault", value);

  // showTimetableMenu
  bool get showTimetableMenu => pref!.getBool("showTimetableMenu") ?? true;

  set showTimetableMenu(bool value) =>
      pref!.setBool("showTimetableMenu", value);

  // showMemorizeMenu
  bool get showMemorizeMenu => pref!.getBool("showMemorizeMenu") ?? true;

  set showMemorizeMenu(bool value) => pref!.setBool("showMemorizeMenu", value);

  // showReviewBtn
  bool get showReviewBtn => pref!.getBool("showReviewBtn") ?? true;

  set showReviewBtn(bool value) => pref!.setBool("showReviewBtn", value);

  // timetableShowSaturday
  bool get timetableShowSaturday =>
      pref!.getBool("timetableShowSaturday") ?? true;

  set timetableShowSaturday(bool value) =>
      pref!.setBool("timetableShowSaturday", value);

  // timetableShowClassTime
  bool get timetableShowClassTime =>
      pref!.getBool("timetableShowClassTime") ?? true;

  set timetableShowClassTime(bool value) =>
      pref!.setBool("timetableShowClassTime", value);

  // timetableShowTimeMarker
  bool get timetableShowTimeMarker =>
      pref!.getBool("timetableShowTimeMarker") ?? true;

  set timetableShowTimeMarker(bool value) =>
      pref!.setBool("timetableShowTimeMarker", value);

  // String

  // emailForUrlSignIn
  String? get emailForUrlLogin => pref!.getString("emailForUrlSignIn");

  set emailForUrlLogin(String? value) =>
      pref!.setString("emailForUrlSignIn", value!);

  // currentTimetableId
  @Deprecated("Use intCurrentTimetableId instead.")
  String get currentTimetableId =>
      pref!.getString("currentTimetableId") ?? "main";

  @Deprecated("Use intCurrentTimetableId instead.")
  set currentTimetableId(String value) =>
      pref!.setString("currentTimetableId", value);

  // intCurrentTimetableId
  int get intCurrentTimetableId => pref!.getInt("intCurrentTimetableId") ?? -1;

  set intCurrentTimetableId(int value) =>
      pref!.setInt("intCurrentTimetableId", value);

  // string list

  // timetableHistory
  List<String> get timetableHistory =>
      pref!.getStringList("timetableHistory") ?? [];

  set timetableHistory(List<String> value) =>
      pref!.setStringList("timetableHistory", value);

  // int

  // timetableHour
  @Deprecated("Use timetablePeriodCount instead.")
  int get timetableHour => pref!.getInt("timetableHour") ?? 6;
  @Deprecated("Use timetablePeriodCount instead.")
  set timetableHour(int? value) => pref!.setInt("timetableHour", value!);

  // timetablePeriodCount
  int get timetablePeriodCountToDisplay => pref!.getInt("timetablePeriodCountToDisplay") ?? 6;

  set timetablePeriodCountToDisplay(int value) => pref!.setInt("timetablePeriodCountToDisplay", value);

  // submissionCreationCount
  int get submissionCreationCount =>
      pref!.getInt("submissionCreationCount") ?? 0;

  void incrementSubmissionCreationCount() {
    pref!.setInt("submissionCreationCount", submissionCreationCount + 1);
  }

  // firestoreLastChanged
  DateTime get firestoreLastChanged => DateTime.fromMicrosecondsSinceEpoch(
      pref!.getInt("firestoreLastChanged") ?? 0);

  set firestoreLastChanged(DateTime? value) => value != null
      ? pref!.setInt("firestoreLastChanged", value.microsecondsSinceEpoch)
      : pref!.remove("firestoreLastChanged");

  // timetableNotificationTime_
  TimeOfDay? get timetableNotificationTime {
    final hour = pref!.getInt("timetableNotificationTimeHour");
    final minute = pref!.getInt("timetableNotificationTimeMinute");
    if (hour == null || minute == null) {
      return null;
    } else {
      return TimeOfDay(hour: hour, minute: minute);
    }
  }

  set timetableNotificationTime(TimeOfDay? value) {
    if (value != null) {
      pref!.setInt("timetableNotificationTimeHour", value.hour);
      pref!.setInt("timetableNotificationTimeMinute", value.minute);
    } else {
      pref!.remove("timetableNotificationTimeHour");
      pref!.remove("timetableNotificationTimeMinute");
    }
  }

  // lastVersionCode
  int? get lastVersionCode => pref!.getInt("lastVersionCode");
  set lastVersionCode(int? value) => pref!.setInt("lastVersionCode", value!);

  static Future<void> use(dynamic Function(SharedPrefs prefs) callback) {
    return SharedPreferences.getInstance().then((pref) async {
      var prefs = SharedPrefs(pref);
      await callback(prefs);
    });
  }
}
