import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/features/timetable/data/models/isar_timetable_class_time.dart";
import "package:submon/features/timetable/domain/models/timetable_class_time.dart";

void main() {
  group("IsarTimetableClassTime mapper", () {
    test("TimetableClassTimePeriod round-trips through Isar", () {
      final TimetableClassTimePeriod classTime = TimetableClassTimePeriod(
        period: 1,
        start: const TimeOfDay(hour: 8, minute: 45),
        end: const TimeOfDay(hour: 9, minute: 35),
      );

      final IsarTimetableClassTime isar = classTime.toIsar();
      final TimetableClassTimePeriod roundTripped = isar.toDomain();

      expect(roundTripped, classTime);
      expect(isar.start, "08:45");
      expect(isar.end, "09:35");
    });
  });
}
