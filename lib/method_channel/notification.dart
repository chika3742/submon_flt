import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/submission.dart';

class NotificationMethodChannel {
  static const mc = MethodChannel("submon/notification");

  static Future<bool?> isGranted() {
    return mc.invokeMethod<bool>("isGranted");
  }

  static Future<PendingAction?> getPendingAction() async {
    var pa = await mc.invokeMethod<String>("getPendingAction");
    if (pa != null) {
      try {
        return PendingAction.values.firstWhere((element) => element.name == pa);
      } on StateError {
        return null;
      }
    }
  }

  /// Registers reminder notification.
  ///
  /// [hour] and [minute] used for repeating notification daily.
  static void registerReminder() async {
    await unregisterReminder();
    var pref = await SharedPreferences.getInstance();
    var sp = SharedPrefs(pref);
    if (sp.reminderTime != null) {
      var prov = SubmissionProvider();
      await prov.open();

      var notifyTime = DateTime.now().applied(sp.reminderTime!);

      String title;
      String body;

      var submissions =
          await prov.getAll(where: "$colDone = ?", whereArgs: [0]);
      var nearList = submissions.where((e) =>
          !e.date!.difference(notifyTime).isNegative &&
          e.date!.difference(notifyTime).inDays < 2);

      // TODO: テキストのカスタム
      // TODO: 期限が近いとして扱う日数のカスタム

      if (nearList.isEmpty) {
        title = "リマインダー通知";
        body = "提出物リストを見るのを忘れていませんか？未完了の提出物をチェックしましょう！";
      } else {
        title = "期限が近い提出物があります";
        body = "${nearList.map((e) => e.title).join(", ")} の期限は2日以内です";
      }

      mc.invokeMethod("registerReminder", {
        "title": title,
        "body": body,
        "hour": sp.reminderTime!.hour,
        "minute": sp.reminderTime!.minute,
      });
    }
  }

  static Future<void> unregisterReminder() async {
    await mc.invokeMethod("unregisterReminder");
  }

  static const chReminder = "reminder";
  static const chTimetable = "timetable";
}

extension DateTimeExt on DateTime {
  DateTime applied(TimeOfDay timeOfDay) {
    var newDT = DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
    if (newDT.isBefore(DateTime.now())) {
      newDT.add(const Duration(days: 1));
    }
    return newDT;
  }
}

enum PendingAction { createNew }
