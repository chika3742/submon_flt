import 'package:flutter/material.dart';

extension DateTimeUtils on DateTime {
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
