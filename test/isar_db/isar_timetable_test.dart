import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_timetable.dart";

/// `Timetable` (セル) のシリアライズ・ゴールデンテスト。
/// Firestore キー名はサーバ互換のため変更不可。
void main() {
  Timetable buildTimetable() {
    final t = Timetable()
      ..id = 3
      ..tableId = -1
      ..cellId = 12
      ..subject = "国語"
      ..room = "A101"
      ..teacher = "山田"
      ..note = "教科書持参";
    return t;
  }

  group("Timetable.toMap", () {
    test("固定キー名と値を返す (Firestore 互換)", () {
      final map = buildTimetable().toMap();

      expect(map, containsPair("id", 3));
      expect(map, containsPair("tableId", -1));
      expect(map, containsPair("cellId", 12));
      expect(map, containsPair("subject", "国語"));
      expect(map, containsPair("room", "A101"));
      expect(map, containsPair("teacher", "山田"));
      expect(map, containsPair("note", "教科書持参"));
    });

    test("キー集合が固定されている", () {
      expect(
        buildTimetable().toMap().keys.toSet(),
        {"id", "tableId", "cellId", "subject", "room", "teacher", "note"},
      );
    });
  });

  group("Timetable round-trip", () {
    test("全フィールドが保存される", () {
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
