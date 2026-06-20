import "package:flutter_test/flutter_test.dart";
import "package:submon/utils/batch_operation.dart";

/// `List.partition` のチャンク分割ロジックのテスト。
/// Firestore バッチの 500 件上限分割に使われる。
void main() {
  group("List.partition", () {
    test("chunkSize ちょうどなら 1 チャンク", () {
      final result = List.generate(3, (i) => i).partition(3);
      expect(result, [
        [0, 1, 2],
      ]);
    });

    test("chunkSize を超えると複数チャンクに分割される", () {
      final result = List.generate(7, (i) => i).partition(3);
      expect(result, [
        [0, 1, 2],
        [3, 4, 5],
        [6],
      ]);
    });

    test("500 件境界: 501 件は 2 チャンク (500 + 1)", () {
      final result = List.generate(501, (i) => i).partition(500);
      expect(result.length, 2);
      expect(result[0].length, 500);
      expect(result[1].length, 1);
    });

    test("空リストは空チャンク 1 個を返す (現状挙動)", () {
      expect(<int>[].partition(500), [<int>[]]);
    });
  });
}
