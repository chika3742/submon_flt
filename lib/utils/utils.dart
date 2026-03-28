import "package:flutter/material.dart";

import "../pages/submission_create_page.dart";
import "ui.dart";

const screenShotMode = bool.fromEnvironment("SCREENSHOT_MODE");

int getTimetableCellId(int period, int weekday) {
  return period * 6 + weekday;
}

void showFirestoreReadFailedDialog(
  BuildContext context,
  String message, {
  required VoidCallback onSignOut,
  required VoidCallback onShowAnnouncements,
}) {
  showSimpleDialog(
    context,
    "エラー",
    "$message\n\nアカウントがすでに削除されたか、サーバーメンテナンス中である可能性があります。",
    allowCancel: false,
    showCancel: true,
    cancelText: "ログアウト",
    onCancelPressed: onSignOut,
    okText: "お知らせを開く",
    onOKPressed: onShowAnnouncements,
  );
}

void createNewSubmissionForTimetable(
    BuildContext context, int weekday, String name) {
  var now = DateTime.now();
  now = DateTime(now.year, now.month, now.day, 23, 59);
  DateTime deadline;
  if (now.weekday == weekday + 1) {
    deadline = now.add(const Duration(days: 7));
  } else {
    deadline = now;
    while (deadline.weekday != weekday + 1) {
      deadline = deadline.add(const Duration(days: 1));
    }
  }
  Navigator.of(context, rootNavigator: true)
      .pushNamed(CreateSubmissionPage.routeName, arguments: CreateSubmissionPageArguments(
    initialTitle: name,
    initialDeadline: deadline,
  ));
}

extension TimeOfDayToMinutes on TimeOfDay {
  int toMinutes() {
    return hour * 60 + minute;
  }

  bool isInsideRange(TimeOfDay start, TimeOfDay end) {
    return start.toMinutes() <= toMinutes() && toMinutes() < end.toMinutes();
  }
}

Iterable<int> range(int start, int end, [int step = 1]) sync* {
  if (step == 0) throw ArgumentError("step cannot be 0");
  if (step < 0) throw ArgumentError("step cannot be negative");

  for (int value = start; value <= end; value += step) {
    yield value;
  }
}
