import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String getWeekdayString(int weekday) {
  var weekdays = ["月", "火", "水", "木", "金", "土", "日"];
  return weekdays[weekday];
}

String getRemainingString(int days) {
  if (days < 7) {
    return "$days 日";
  } else if (days < 28) {
    return "${(days / 7).floor()} 週間";
  } else {
    return "${(days / 28).floor()} ヶ月";
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