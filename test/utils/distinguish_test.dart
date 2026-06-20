import "package:flutter_test/flutter_test.dart";
import "package:submon/utils/distinguish.dart";

/// `Distinguish` wraps a value so that identical values are treated as
/// distinct events.
void main() {
  group("Distinguish", () {
    test("holds the value", () {
      expect(Distinguish<int>(42).value, 42);
    });

    test("distinct instances even with equal values", () {
      final a = Distinguish<String>("x");
      final b = Distinguish<String>("x");

      // Values are equal, but the instances are distinct (== is not overridden)
      expect(a.value, b.value);
      expect(identical(a, b), isFalse);
      expect(a == b, isFalse);
    });
  });
}
