import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_timetable_table.dart";

/// `TimetableTable` のシリアライズ・ゴールデンテスト。
void main() {
  group("TimetableTable.toMap", () {
    test("固定キー名と値を返す (Firestore 互換)", () {
      final map = TimetableTable.from(id: 5, title: "1年生").toMap();

      expect(map, containsPair("id", 5));
      expect(map, containsPair("title", "1年生"));
    });

    test("キー集合が固定されている", () {
      expect(
        TimetableTable.from(id: 5, title: "x").toMap().keys.toSet(),
        {"id", "title"},
      );
    });
  });

  test("round-trip で全フィールドが保存される", () {
    final original = TimetableTable.from(id: 9, title: "後期");
    final restored = TimetableTable.fromMap(original.toMap());

    expect(restored.id, original.id);
    expect(restored.title, original.title);
  });
}
