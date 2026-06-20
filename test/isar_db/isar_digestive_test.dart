import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_digestive.dart";

/// `Digestive` のシリアライズ・ゴールデンテスト。
/// Firestore キー名はサーバ互換のため変更不可。
void main() {
  Digestive buildDigestive() {
    return Digestive.from(
      id: 7,
      submissionId: 42,
      done: true,
      startAt: DateTime(2024, 5, 6, 7, 8, 9),
      minute: 30,
      content: "数学の復習",
    );
  }

  group("Digestive.toMap", () {
    test("固定キー名と値を返す (Firestore 互換)", () {
      final map = buildDigestive().toMap();

      expect(map, containsPair("id", 7));
      expect(map, containsPair("submissionId", 42));
      expect(map, containsPair("done", true));
      expect(map, containsPair("minute", 30));
      expect(map, containsPair("content", "数学の復習"));
      expect(map["startAt"], isA<String>());
    });

    test("キー集合が固定されている", () {
      expect(
        buildDigestive().toMap().keys.toSet(),
        {"id", "submissionId", "done", "startAt", "minute", "content"},
      );
    });

    test("startAt は UTC ISO8601 文字列化される", () {
      final startAt = DateTime(2024, 5, 6, 7, 8, 9);
      final digestive = Digestive.from(
        startAt: startAt,
        minute: 0,
        content: "",
      );

      expect(digestive.toMap()["startAt"], startAt.toUtc().toIso8601String());
      expect((digestive.toMap()["startAt"] as String).endsWith("Z"), isTrue);
    });
  });

  group("Digestive round-trip", () {
    test("全フィールドが保存される", () {
      final original = buildDigestive();
      final restored = Digestive.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.submissionId, original.submissionId);
      expect(restored.done, original.done);
      expect(restored.startAt, original.startAt);
      expect(restored.minute, original.minute);
      expect(restored.content, original.content);
    });

    test("startAt の UTC↔ローカル往復で同一時刻になる", () {
      final startAt = DateTime(2024, 12, 31, 12, 0);
      final digestive = Digestive.from(
        startAt: startAt,
        minute: 15,
        content: "x",
      );

      final restored = Digestive.fromMap(digestive.toMap());
      expect(restored.startAt, startAt);
      expect(restored.startAt.isUtc, isFalse);
    });

    test("submissionId が null のまま round-trip する", () {
      final digestive = Digestive.from(
        submissionId: null,
        startAt: DateTime(2024, 1, 1),
        minute: 0,
        content: "",
      );
      expect(Digestive.fromMap(digestive.toMap()).submissionId, isNull);
    });
  });
}
