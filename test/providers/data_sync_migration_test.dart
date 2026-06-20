import "package:flutter_test/flutter_test.dart";
import "package:submon/providers/data_sync_migration.dart";
import "package:submon/providers/data_sync_service.dart";

/// schemaVersion 4 → 5 のデータ移行 (純粋関数) のゴールデンテスト。
///
/// これはユーザーデータ移行コードで最も壊すと痛い箇所。旧 v4 形式の入力を渡し、
/// 期待される v5 形式へ **フィールド単位** で変換されることを固定する。
void main() {
  group("migrateSubmissionV4", () {
    test("detail→details / date→due のリネームと旧キー削除", () {
      final result = migrateSubmissionV4({
        "detail": "第3章まで",
        "date": "2024-01-02T03:04:05.000Z",
        "done": 0,
        "important": 0,
        "title": "レポート",
      });

      expect(result["details"], "第3章まで");
      expect(result["due"], "2024-01-02T03:04:05.000Z");
      // 旧キーは削除される
      expect(result.containsKey("detail"), isFalse);
      expect(result.containsKey("date"), isFalse);
      // 変換対象外のキーは保持される
      expect(result["title"], "レポート");
    });

    test("done==1 / important==1 → true", () {
      final result = migrateSubmissionV4({
        "detail": "",
        "date": "",
        "done": 1,
        "important": 1,
      });

      expect(result["done"], isTrue);
      expect(result["important"], isTrue);
    });

    test("done==0 / important==0 → false", () {
      final result = migrateSubmissionV4({
        "detail": "",
        "date": "",
        "done": 0,
        "important": 0,
      });

      expect(result["done"], isFalse);
      expect(result["important"], isFalse);
    });

    test("done/important が欠落 (null) → false", () {
      final result = migrateSubmissionV4({
        "detail": "",
        "date": "",
      });

      expect(result["done"], isFalse);
      expect(result["important"], isFalse);
    });
  });

  group("migrateDigestiveV4Done", () {
    test("done==1 → true", () {
      expect(migrateDigestiveV4Done({"done": 1}), isTrue);
    });

    test("done==0 → false", () {
      expect(migrateDigestiveV4Done({"done": 0}), isFalse);
    });

    test("done 欠落 (null) → false", () {
      expect(migrateDigestiveV4Done({}), isFalse);
    });
  });

  group("migrateTimetableCellsV4", () {
    test("各セルに tableId = -1 を付与する", () {
      final result = migrateTimetableCellsV4({
        "cells": {
          "0": {"cellId": 0, "subject": "国語"},
          "1": {"cellId": 1, "subject": "数学"},
        },
      });

      final cells = result["cells"] as Map<String, dynamic>;
      expect(cells["0"]["tableId"], -1);
      expect(cells["1"]["tableId"], -1);
      // 既存フィールドは保持される
      expect(cells["0"]["subject"], "国語");
      expect(cells["1"]["cellId"], 1);
    });

    test("cells が null の場合は何もしない", () {
      final result = migrateTimetableCellsV4({"title": "main"});

      expect(result["cells"], isNull);
      expect(result["title"], "main");
    });
  });

  group("migrateTimetableClassTimeV4", () {
    test("id→period のリネームと旧キー削除", () {
      final result = migrateTimetableClassTimeV4({
        "id": 3,
        "start": "8:30",
        "end": "9:20",
      });

      expect(result["period"], 3);
      expect(result.containsKey("id"), isFalse);
      // 変換対象外のキーは保持される
      expect(result["start"], "8:30");
      expect(result["end"], "9:20");
    });
  });

  group("SchemaVersionMismatchException", () {
    test("サーバ/期待バージョンを保持し、メッセージに含める", () {
      final exception = SchemaVersionMismatchException(9, 7);

      expect(exception.serverVersion, 9);
      expect(exception.expectedVersion, 7);
      expect(exception.toString(), contains("9"));
      expect(exception.toString(), contains("7"));
    });
  });
}
