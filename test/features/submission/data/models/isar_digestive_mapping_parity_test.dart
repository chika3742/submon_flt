import "package:flutter_test/flutter_test.dart";
import "package:submon/features/submission/data/models/isar_digestive.dart";
import "package:submon/features/submission/domain/models/digestive.dart";

void main() {
  group("IsarDigestive mapper", () {
    test("Digestive round-trips through Isar", () {
      final Digestive digestive = Digestive(
        id: 42,
        submissionId: null,
        done: true,
        startAt: DateTime(2026, 4, 20, 9, 30),
        minute: 15,
        content: "数学",
      );

      final Digestive roundTripped = digestive.toIsar().toDomain();

      expect(roundTripped, digestive);
    });

    test("DigestiveInsertable keeps fields during toIsar", () {
      final DigestiveInsertable insertable = DigestiveInsertable(
        submissionId: 123,
        startAt: DateTime(2026, 4, 21, 8, 45),
        minute: 20,
        content: "英語",
      );

      final IsarDigestive isar = insertable.toIsar();

      expect(isar.submissionId, insertable.submissionId);
      expect(isar.startAt, insertable.startAt);
      expect(isar.minute, insertable.minute);
      expect(isar.content, insertable.content);
      expect(isar.done, isFalse);
    });
  });
}
