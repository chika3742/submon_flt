import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_timetable_class_time.dart";

/// `TimetableClassTime` のシリアライズ・ゴールデンテスト。
/// start/end は "H:m" 文字列で保存される。計算プロパティ startTime/endTime
/// (@ignore) はシリアライズ対象外。
void main() {
  group("TimetableClassTime.toMap", () {
    test("固定キー名と値を返す (Firestore 互換)", () {
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

    test("キー集合は period/start/end のみ (計算プロパティは含まない)", () {
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
    test("period/start/end が保存される", () {
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

    test("startTime/endTime が TimeOfDay として復元される", () {
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
