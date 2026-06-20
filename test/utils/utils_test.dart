import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/utils/utils.dart";

void main() {
  group("getTimetableCellId", () {
    test("period * 6 + weekday を返す", () {
      expect(getTimetableCellId(0, 0), 0);
      expect(getTimetableCellId(0, 5), 5);
      expect(getTimetableCellId(1, 0), 6);
      expect(getTimetableCellId(2, 3), 15);
    });
  });

  group("TimeOfDay.toMinutes", () {
    test("hour * 60 + minute を返す", () {
      expect(const TimeOfDay(hour: 0, minute: 0).toMinutes(), 0);
      expect(const TimeOfDay(hour: 1, minute: 30).toMinutes(), 90);
      expect(const TimeOfDay(hour: 23, minute: 59).toMinutes(), 1439);
    });
  });

  group("TimeOfDay.isInsideRange", () {
    const start = TimeOfDay(hour: 9, minute: 0);
    const end = TimeOfDay(hour: 10, minute: 0);

    test("start 以上 end 未満なら true", () {
      expect(const TimeOfDay(hour: 9, minute: 0).isInsideRange(start, end),
          isTrue);
      expect(const TimeOfDay(hour: 9, minute: 30).isInsideRange(start, end),
          isTrue);
    });

    test("end ちょうどは範囲外 (排他的)", () {
      expect(const TimeOfDay(hour: 10, minute: 0).isInsideRange(start, end),
          isFalse);
    });

    test("start 未満は範囲外", () {
      expect(const TimeOfDay(hour: 8, minute: 59).isInsideRange(start, end),
          isFalse);
    });
  });

  group("range", () {
    test("start から end まで (inclusive) を生成", () {
      expect(range(1, 5).toList(), [1, 2, 3, 4, 5]);
    });

    test("step 指定で間引く", () {
      expect(range(0, 10, 2).toList(), [0, 2, 4, 6, 8, 10]);
    });

    test("start == end なら 1 要素", () {
      expect(range(3, 3).toList(), [3]);
    });

    test("start > end なら空", () {
      expect(range(5, 1).toList(), isEmpty);
    });

    test("step == 0 は ArgumentError", () {
      expect(() => range(0, 10, 0).toList(), throwsArgumentError);
    });

    test("step < 0 は ArgumentError", () {
      expect(() => range(0, 10, -1).toList(), throwsArgumentError);
    });
  });
}
