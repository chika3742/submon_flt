import "package:flutter_test/flutter_test.dart";
import "package:submon/utils/batch_operation.dart";

/// Tests for the `List.partition` chunking logic.
/// Used to split Firestore batches by the 500-operation limit.
void main() {
  group("List.partition", () {
    test("returns a single chunk when length equals chunkSize", () {
      final result = List.generate(3, (i) => i).partition(3);
      expect(result, [
        [0, 1, 2],
      ]);
    });

    test("splits into multiple chunks when length exceeds chunkSize", () {
      final result = List.generate(7, (i) => i).partition(3);
      expect(result, [
        [0, 1, 2],
        [3, 4, 5],
        [6],
      ]);
    });

    test("500 boundary: 501 items -> 2 chunks (500 + 1)", () {
      final result = List.generate(501, (i) => i).partition(500);
      expect(result.length, 2);
      expect(result[0].length, 500);
      expect(result[1].length, 1);
    });

    test("empty list returns a single empty chunk (current behavior)", () {
      expect(<int>[].partition(500), [<int>[]]);
    });
  });
}
