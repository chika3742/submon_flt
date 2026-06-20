import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/utils/date_time_utils.dart";

/// `DateTimeUtils.applied` のテスト。
void main() {
  group("DateTime.applied", () {
    test("日付に TimeOfDay の時刻を適用する (未来日)", () {
      final date = DateTime(2099, 6, 15, 1, 2, 3);
      final result = date.applied(const TimeOfDay(hour: 8, minute: 30));

      expect(result.year, 2099);
      expect(result.month, 6);
      expect(result.day, 15);
      expect(result.hour, 8);
      expect(result.minute, 30);
      expect(result.second, 0); // 秒は切り捨てられる
    });

    test("過去日でも同じ日の時刻を返す (現状挙動: +1日 は適用されない)", () {
      // 実装は newDT.add(Duration(days:1)) の結果を破棄しているため、
      // 過去日でも翌日には繰り上がらない。この挙動を安全網として固定する。
      final date = DateTime(2000, 1, 1);
      final result = date.applied(const TimeOfDay(hour: 9, minute: 0));

      expect(result.day, 1);
      expect(result.month, 1);
      expect(result.year, 2000);
      expect(result.hour, 9);
    });
  });
}
