import "package:flutter_test/flutter_test.dart";
import "package:submon/features/submission/models/submission.dart";
import "package:submon/features/submission/repositories/submission_mapper.dart";

/// Golden serialization tests for `Submission`.
///
/// Firestore key names **must not change** (server compatibility). To detect
/// typos or renames of keys, assert key names literally with `containsPair`.
void main() {
  Submission buildSubmission() {
    return Submission.from(
      id: 42,
      title: "Report",
      details: "Up to chapter 3",
      due: DateTime(2024, 1, 2, 3, 4, 5),
      color: 0xFF112233,
    )
      ..done = true
      ..important = true
      ..repeat = Repeat.weekly
      ..googleTasksTaskId = "task-1"
      ..canvasPlannableId = 99
      ..repeatSubmissionCreated = true;
  }

  group("Submission.toMap", () {
    test("returns fixed key names and values (Firestore compatible)", () {
      final map = buildSubmission().toMap();

      expect(map, containsPair("id", 42));
      expect(map, containsPair("title", "Report"));
      expect(map, containsPair("details", "Up to chapter 3"));
      expect(map, containsPair("done", true));
      expect(map, containsPair("important", true));
      expect(map, containsPair("repeat", Repeat.weekly.index));
      expect(map, containsPair("color", 0xFF112233));
      expect(map, containsPair("googleTasksTaskId", "task-1"));
      expect(map, containsPair("canvasPlannableId", 99));
      expect(map, containsPair("repeatSubmissionCreated", true));
      // due is a UTC ISO8601 string
      expect(map["due"], isA<String>());
    });

    test("has a fixed key set (detects added/removed keys)", () {
      expect(
        buildSubmission().toMap().keys.toSet(),
        {
          "id",
          "title",
          "details",
          "due",
          "done",
          "important",
          "repeat",
          "color",
          "googleTasksTaskId",
          "canvasPlannableId",
          "repeatSubmissionCreated",
        },
      );
    });

    test("serializes due as a UTC string via toUtc().toIso8601String()", () {
      final due = DateTime(2024, 1, 2, 3, 4, 5);
      final submission = Submission.from(
        id: 1,
        title: "t",
        details: "d",
        due: due,
        color: 0,
      );

      expect(submission.toMap()["due"], due.toUtc().toIso8601String());
      // Confirm it is UTC notation (trailing Z)
      expect((submission.toMap()["due"] as String).endsWith("Z"), isTrue);
    });
  });

  group("Submission round-trip (fromMap(toMap()))", () {
    test("preserves all fields", () {
      final original = buildSubmission();
      final restored = submissionFromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.details, original.details);
      expect(restored.due, original.due);
      expect(restored.done, original.done);
      expect(restored.important, original.important);
      expect(restored.repeat, original.repeat);
      expect(restored.color, original.color);
      expect(restored.googleTasksTaskId, original.googleTasksTaskId);
      expect(restored.canvasPlannableId, original.canvasPlannableId);
      expect(restored.repeatSubmissionCreated, original.repeatSubmissionCreated);
    });

    test("keeps nullable fields null across a round-trip", () {
      final submission = Submission.from(
        id: null,
        title: "t",
        details: "d",
        due: DateTime(2024, 6, 1),
        color: 0,
      );
      final restored = submissionFromMap(submission.toMap());

      expect(restored.id, isNull);
      expect(restored.googleTasksTaskId, isNull);
      expect(restored.canvasPlannableId, isNull);
      expect(restored.repeatSubmissionCreated, isNull);
    });

    test("due is the same instant after the UTC<->local round-trip", () {
      final due = DateTime(2024, 7, 15, 23, 59);
      final submission = Submission.from(
        id: 1,
        title: "t",
        details: "d",
        due: due,
        color: 0,
      );

      final restored = submissionFromMap(submission.toMap());
      expect(restored.due, due);
      expect(restored.due.isUtc, isFalse); // converted back via toLocal
    });
  });

  group("Submission.fromMap done backward compatibility", () {
    Map<String, dynamic> baseMap(Object done) => {
          "id": 1,
          "title": "t",
          "details": "d",
          "due": DateTime(2024, 1, 1).toUtc().toIso8601String(),
          "done": done,
          "important": false,
          "repeat": 0,
          "color": 0,
          "googleTasksTaskId": null,
          "canvasPlannableId": null,
          "repeatSubmissionCreated": null,
        };

    test("done as bool(true) -> true", () {
      expect(submissionFromMap(baseMap(true)).done, isTrue);
    });

    test("done as bool(false) -> false", () {
      expect(submissionFromMap(baseMap(false)).done, isFalse);
    });

    test("done as int(1) -> true (legacy schema compatibility)", () {
      expect(submissionFromMap(baseMap(1)).done, isTrue);
    });

    test("done as int(0) -> false (legacy schema compatibility)", () {
      expect(submissionFromMap(baseMap(0)).done, isFalse);
    });
  });

  group("Submission.repeat enum round-trip", () {
    for (final repeat in Repeat.values) {
      test("$repeat round-trips via its index", () {
        final submission = Submission.from(
          id: 1,
          title: "t",
          details: "d",
          due: DateTime(2024, 1, 1),
          color: 0,
        )..repeat = repeat;

        expect(submission.toMap()["repeat"], repeat.index);
        expect(submissionFromMap(submission.toMap()).repeat, repeat);
      });
    }
  });
}
