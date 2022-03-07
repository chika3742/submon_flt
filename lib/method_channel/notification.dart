import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/method_channel/channels.dart';

class NotificationMethodChannel {
  static const mc = MethodChannel(Channels.notification);

  /// Unused.
  static Future<bool?> isGranted() {
    return mc.invokeMethod<bool>("isGranted");
  }

  /// **Unused.**
  ///
  /// Registers reminder notification.
  static void registerReminder() async {
    await unregisterReminder();
    var pref = SharedPrefs(await SharedPreferences.getInstance());
    if (pref.reminderTime != null) {
      var args = {};
      // iOS only
      if (Platform.isIOS) {
        await SubmissionProvider().use((provider) async {
          var notificationTime = DateTime.now().applied(pref.reminderTime!);
          var submissions =
              (await provider.getAll(where: "$colDone = 0")).where((element) {
            var diff = element.date!.difference(notificationTime);
            return !diff.isNegative && diff.inDays < 2;
          });

          String title;
          String body;

          if (submissions.isEmpty) {
            title = "リマインダー通知";
            body = "提出物リストを見るのを忘れていませんか？未完了の提出物をチェックしましょう！";
          } else {
            title = "期限が近い提出物があります！";
            body = "${submissions.map((e) => e.title).join(", ")}の期限は2日を切っています";
          }

          args = {
            "title": title,
            "body": body,
            "notificationHour": notificationTime.hour,
            "notificationMinute": notificationTime.minute
          };
        });
      }
      mc.invokeMethod("registerReminder", args);
    }
  }

  /// **Unused.**
  ///
  /// Unregisters reminder notification.
  static Future<void> unregisterReminder() async {
    await mc.invokeMethod("unregisterReminder");
  }

  /// Registers reminder notification.
  static void registerTimetableNotification() async {
    await unregisterReminder();
    mc.invokeMethod("registerTimetableNotification", {});
  }

  /// Unregisters reminder notification.
  static Future<void> unregisterTimetableNotification() async {
    await mc.invokeMethod("unregisterTimetableNotification");
  }
}

extension DateTimeExt on DateTime {
  /// Applies [TimeOfDay] to [DateTime].
  /// If applied [DateTime] is before current time, adds 1 day.
  DateTime applied(TimeOfDay timeOfDay) {
    var newDT = DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
    if (newDT.isBefore(DateTime.now())) {
      newDT.add(const Duration(days: 1));
    }
    return newDT;
  }
}