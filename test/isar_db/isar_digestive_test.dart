import "package:flutter_test/flutter_test.dart";
import "package:submon/features/digestive/models/isar_digestive.dart";

/// Golden serialization tests for `Digestive`.
/// Firestore key names must not change (server compatibility).
void main() {
  Digestive buildDigestive() {
    return Digestive.from(
      id: 7,
      submissionId: 42,
      done: true,
      startAt: DateTime(2024, 5, 6, 7, 8, 9),
      minute: 30,
      content: "Math review",
    );
  }

  group("Digestive.toMap", () {
    test("returns fixed key names and values (Firestore compatible)", () {
      final map = buildDigestive().toMap();

      expect(map, containsPair("id", 7));
      expect(map, containsPair("submissionId", 42));
      expect(map, containsPair("done", true));
      expect(map, containsPair("minute", 30));
      expect(map, containsPair("content", "Math review"));
      expect(map["startAt"], isA<String>());
    });

    test("has a fixed key set", () {
      expect(
        buildDigestive().toMap().keys.toSet(),
        {"id", "submissionId", "done", "startAt", "minute", "content"},
      );
    });

    test("serializes startAt as a UTC ISO8601 string", () {
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
    test("preserves all fields", () {
      final original = buildDigestive();
      final restored = Digestive.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.submissionId, original.submissionId);
      expect(restored.done, original.done);
      expect(restored.startAt, original.startAt);
      expect(restored.minute, original.minute);
      expect(restored.content, original.content);
    });

    test("startAt is the same instant after the UTC<->local round-trip", () {
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

    test("keeps submissionId null across a round-trip", () {
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
