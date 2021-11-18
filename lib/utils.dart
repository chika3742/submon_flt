import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String getWeekdayString(int weekday) {
  var weekdays = ["月", "火", "水", "木", "金", "土", "日"];
  return weekdays[weekday];
}

List<String> getRemainingString(Duration diff, bool weekView) {
  if (diff.inDays == 0) {
    return "${diff.inHours} 時間".split(" ");
  } else if (diff.inDays < 7 || !weekView) {
    return "${diff.inDays} 日".split(" ");
  } else if (diff.inDays < 28) {
    return "${(diff.inDays / 7).floor()} 週間".split(" ");
  } else {
    return "${(diff.inDays / 28).floor()} ヶ月".split(" ");
  }
}

Color getRemainingDateColor(int remainingDate) {
  if (remainingDate < 0) {
    return Colors.red;
  } else if (0 <= remainingDate && remainingDate <= 2) {
    return Colors.orange;
  } else {
    return Colors.green;
  }
}

void pushPage(BuildContext context, Widget page) {
  PageRoute route;
  if (Platform.isIOS || Platform.isMacOS) {
    route = CupertinoPageRoute(builder: (settings) => page);
  } else {
    route = MaterialPageRoute(builder: (settings) => page);
  }
  Navigator.of(context, rootNavigator: true).push(route);
}

void showSnackBar(BuildContext context, String text, {Duration duration = const Duration(seconds: 5), SnackBarAction? action}) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(text),
    duration: duration,
    action: action,
  ));
}