import "package:flutter_test/flutter_test.dart";
import "package:submon/providers/data_sync_migration.dart";
import "package:submon/providers/data_sync_service.dart";

/// Golden tests for the schemaVersion 4 -> 5 data migration (pure functions).
///
/// This is the most damaging place to break in the user-data migration code.
/// Feed legacy v4 inputs and pin the conversion to the expected v5 format
/// **field by field**.
void main() {
  group("migrateSubmissionV4", () {
    test("renames detail->details / date->due and removes old keys", () {
      final result = migrateSubmissionV4({
        "detail": "Up to chapter 3",
        "date": "2024-01-02T03:04:05.000Z",
        "done": 0,
        "important": 0,
        "title": "Report",
      });

      expect(result["details"], "Up to chapter 3");
      expect(result["due"], "2024-01-02T03:04:05.000Z");
      // Old keys are removed
      expect(result.containsKey("detail"), isFalse);
      expect(result.containsKey("date"), isFalse);
      // Unrelated keys are preserved
      expect(result["title"], "Report");
    });

    test("done==1 / important==1 -> true", () {
      final result = migrateSubmissionV4({
        "detail": "",
        "date": "",
        "done": 1,
        "important": 1,
      });

      expect(result["done"], isTrue);
      expect(result["important"], isTrue);
    });

    test("done==0 / important==0 -> false", () {
      final result = migrateSubmissionV4({
        "detail": "",
        "date": "",
        "done": 0,
        "important": 0,
      });

      expect(result["done"], isFalse);
      expect(result["important"], isFalse);
    });

    test("missing done/important (null) -> false", () {
      final result = migrateSubmissionV4({
        "detail": "",
        "date": "",
      });

      expect(result["done"], isFalse);
      expect(result["important"], isFalse);
    });
  });

  group("migrateDigestiveV4Done", () {
    test("done==1 -> true", () {
      expect(migrateDigestiveV4Done({"done": 1}), isTrue);
    });

    test("done==0 -> false", () {
      expect(migrateDigestiveV4Done({"done": 0}), isFalse);
    });

    test("missing done (null) -> false", () {
      expect(migrateDigestiveV4Done({}), isFalse);
    });
  });

  group("migrateTimetableCellsV4", () {
    test("adds tableId = -1 to every cell", () {
      final result = migrateTimetableCellsV4({
        "cells": {
          "0": {"cellId": 0, "subject": "Japanese"},
          "1": {"cellId": 1, "subject": "Math"},
        },
      });

      final cells = result["cells"] as Map<String, dynamic>;
      expect(cells["0"]["tableId"], -1);
      expect(cells["1"]["tableId"], -1);
      // Existing fields are preserved
      expect(cells["0"]["subject"], "Japanese");
      expect(cells["1"]["cellId"], 1);
    });

    test("does nothing when cells is null", () {
      final result = migrateTimetableCellsV4({"title": "main"});

      expect(result["cells"], isNull);
      expect(result["title"], "main");
    });
  });

  group("migrateTimetableClassTimeV4", () {
    test("renames id->period and removes the old key", () {
      final result = migrateTimetableClassTimeV4({
        "id": 3,
        "start": "8:30",
        "end": "9:20",
      });

      expect(result["period"], 3);
      expect(result.containsKey("id"), isFalse);
      // Unrelated keys are preserved
      expect(result["start"], "8:30");
      expect(result["end"], "9:20");
    });
  });

  group("SchemaVersionMismatchException", () {
    test("holds the server/expected versions and includes them in toString", () {
      final exception = SchemaVersionMismatchException(9, 7);

      expect(exception.serverVersion, 9);
      expect(exception.expectedVersion, 7);
      expect(exception.toString(), contains("9"));
      expect(exception.toString(), contains("7"));
    });
  });
}
