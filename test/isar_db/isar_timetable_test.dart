import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_timetable.dart";

/// Golden serialization tests for `Timetable` (a cell).
/// Firestore key names must not change (server compatibility).
void main() {
  Timetable buildTimetable() {
    final t = Timetable()
      ..id = 3
      ..tableId = -1
      ..cellId = 12
      ..subject = "Japanese"
      ..room = "A101"
      ..teacher = "Yamada"
      ..note = "Bring textbook";
    return t;
  }

  group("Timetable.toMap", () {
    test("returns fixed key names and values (Firestore compatible)", () {
      final map = buildTimetable().toMap();

      expect(map, containsPair("id", 3));
      expect(map, containsPair("tableId", -1));
      expect(map, containsPair("cellId", 12));
      expect(map, containsPair("subject", "Japanese"));
      expect(map, containsPair("room", "A101"));
      expect(map, containsPair("teacher", "Yamada"));
      expect(map, containsPair("note", "Bring textbook"));
    });

    test("has a fixed key set", () {
      expect(
        buildTimetable().toMap().keys.toSet(),
        {"id", "tableId", "cellId", "subject", "room", "teacher", "note"},
      );
    });
  });

  group("Timetable round-trip", () {
    test("preserves all fields", () {
      final original = buildTimetable();
      final restored = Timetable.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.tableId, original.tableId);
      expect(restored.cellId, original.cellId);
      expect(restored.subject, original.subject);
      expect(restored.room, original.room);
      expect(restored.teacher, original.teacher);
      expect(restored.note, original.note);
    });
  });
}
