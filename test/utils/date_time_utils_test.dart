import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/utils/date_time_utils.dart";

/// Tests for `DateTimeUtils.applied`.
void main() {
  group("DateTime.applied", () {
    test("applies the TimeOfDay to the date (future date)", () {
      final date = DateTime(2099, 6, 15, 1, 2, 3);
      final result = date.applied(const TimeOfDay(hour: 8, minute: 30));

      expect(result.year, 2099);
      expect(result.month, 6);
      expect(result.day, 15);
      expect(result.hour, 8);
      expect(result.minute, 30);
      expect(result.second, 0); // seconds are dropped
    });

    test("past date still returns the same day (current behavior: no +1 day)",
        () {
      // The implementation discards the result of newDT.add(Duration(days: 1)),
      // so a past date is not rolled over to the next day. Pin this behavior as
      // a safety net.
      final date = DateTime(2000, 1, 1);
      final result = date.applied(const TimeOfDay(hour: 9, minute: 0));

      expect(result.day, 1);
      expect(result.month, 1);
      expect(result.year, 2000);
      expect(result.hour, 9);
    });
  });
}
