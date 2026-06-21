import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/features/timetable/models/timetable_class_time.dart";

/// Golden serialization tests for `TimetableClassTime`.
/// start/end are stored as "H:m" strings. The computed properties
/// startTime/endTime (@ignore) are not serialized.
void main() {
  group("TimetableClassTime.toMap", () {
    test("returns fixed key names and values (Firestore compatible)", () {
      final classTime = TimetableClassTime.from(
        period: 1,
        start: const TimeOfDay(hour: 8, minute: 30),
        end: const TimeOfDay(hour: 9, minute: 20),
      );
      final map = classTime.toMap();

      expect(map, containsPair("period", 1));
      expect(map, containsPair("start", "8:30"));
      expect(map, containsPair("end", "9:20"));
    });

    test("key set is only period/start/end (no computed properties)", () {
      final classTime = TimetableClassTime.from(
        period: 1,
        start: const TimeOfDay(hour: 8, minute: 30),
        end: const TimeOfDay(hour: 9, minute: 20),
      );

      expect(classTime.toMap().keys.toSet(), {"period", "start", "end"});
      expect(classTime.toMap().containsKey("startTime"), isFalse);
      expect(classTime.toMap().containsKey("endTime"), isFalse);
    });
  });

  group("TimetableClassTime round-trip", () {
    test("preserves period/start/end", () {
      final original = TimetableClassTime.from(
        period: 2,
        start: const TimeOfDay(hour: 10, minute: 5),
        end: const TimeOfDay(hour: 11, minute: 0),
      );
      final restored = TimetableClassTime.fromMap(original.toMap());

      expect(restored.period, original.period);
      expect(restored.start, original.start);
      expect(restored.end, original.end);
    });

    test("startTime/endTime are restored as TimeOfDay", () {
      final restored = TimetableClassTime.fromMap({
        "period": 3,
        "start": "13:15",
        "end": "14:0",
      });

      expect(restored.startTime, const TimeOfDay(hour: 13, minute: 15));
      expect(restored.endTime, const TimeOfDay(hour: 14, minute: 0));
    });
  });
}
