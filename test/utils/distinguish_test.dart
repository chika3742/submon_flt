import "package:flutter_test/flutter_test.dart";
import "package:submon/utils/distinguish.dart";

/// `Distinguish` は同じ値でも別イベントとして扱うためのラッパー。
void main() {
  group("Distinguish", () {
    test("value を保持する", () {
      expect(Distinguish<int>(42).value, 42);
    });

    test("同じ値でもインスタンスは別物として区別される", () {
      final a = Distinguish<String>("x");
      final b = Distinguish<String>("x");

      // 値は等しいが、インスタンスとしては別 (== をオーバーライドしないため)
      expect(a.value, b.value);
      expect(identical(a, b), isFalse);
      expect(a == b, isFalse);
    });
  });
}
