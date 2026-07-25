import "package:flutter_test/flutter_test.dart";
import "package:submon/features/timetable/data/models/isar_timetable_cell.dart";
import "package:submon/features/timetable/domain/models/timetable_cell.dart";

void main() {
  group("IsarTimetableCell mapper", () {
    test("TimetableCell round-trips through Isar", () {
      final TimetableCell cell = TimetableCell(
        tableId: 3,
        period: 2,
        weekday: 4,
        subject: "国語",
        teacher: "佐藤",
        classroom: "2-A",
        note: "持ち物あり",
      );

      final IsarTimetableCell isar = cell.toIsar();
      final TimetableCell roundTripped = isar.toDomain();

      expect(roundTripped, cell);
      expect(isar.id, isar.encodeId());
    });
  });
}
