import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_timetable_table.dart";

/// Golden serialization tests for `TimetableTable`.
void main() {
  group("TimetableTable.toMap", () {
    test("returns fixed key names and values (Firestore compatible)", () {
      final map = TimetableTable.from(id: 5, title: "Year 1").toMap();

      expect(map, containsPair("id", 5));
      expect(map, containsPair("title", "Year 1"));
    });

    test("has a fixed key set", () {
      expect(
        TimetableTable.from(id: 5, title: "x").toMap().keys.toSet(),
        {"id", "title"},
      );
    });
  });

  test("round-trip preserves all fields", () {
    final original = TimetableTable.from(id: 9, title: "Second term");
    final restored = TimetableTable.fromMap(original.toMap());

    expect(restored.id, original.id);
    expect(restored.title, original.title);
  });
}
