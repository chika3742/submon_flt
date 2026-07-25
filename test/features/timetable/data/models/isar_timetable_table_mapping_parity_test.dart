import "package:flutter_test/flutter_test.dart";
import "package:submon/features/timetable/data/models/isar_timetable_table.dart";
import "package:submon/features/timetable/domain/models/timetable_table.dart";

void main() {
  group("IsarTimetableTable mapper", () {
    test("TimetableTable round-trips through Isar", () {
      final TimetableTable table = TimetableTable(
        id: 7,
        title: "前期",
      );

      final TimetableTable roundTripped = table.toIsar().toDomain();

      expect(roundTripped, table);
    });

    test("TimetableTableInsertable keeps fields during toIsar", () {
      final TimetableTableInsertable insertable = TimetableTableInsertable(
        title: "後期",
      );

      final IsarTimetableTable isar = insertable.toIsar();

      expect(isar.title, insertable.title);
    });
  });
}
