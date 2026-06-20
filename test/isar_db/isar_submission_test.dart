import "package:flutter_test/flutter_test.dart";
import "package:submon/isar_db/isar_submission.dart";

/// `Submission` のシリアライズ・ゴールデンテスト。
///
/// Firestore キー名は **サーバ互換のため変更不可**。キー名のタイポ/変更を
/// 検出できるよう、`containsPair` でキー名を直書きして固定する。
void main() {
  Submission buildSubmission() {
    return Submission.from(
      id: 42,
      title: "レポート",
      details: "第3章まで",
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
    test("固定キー名と値を返す (Firestore 互換)", () {
      final map = buildSubmission().toMap();

      expect(map, containsPair("id", 42));
      expect(map, containsPair("title", "レポート"));
      expect(map, containsPair("details", "第3章まで"));
      expect(map, containsPair("done", true));
      expect(map, containsPair("important", true));
      expect(map, containsPair("repeat", Repeat.weekly.index));
      expect(map, containsPair("color", 0xFF112233));
      expect(map, containsPair("googleTasksTaskId", "task-1"));
      expect(map, containsPair("canvasPlannableId", 99));
      expect(map, containsPair("repeatSubmissionCreated", true));
      // due は UTC ISO8601 文字列
      expect(map["due"], isA<String>());
    });

    test("キー集合が固定されている (キー追加/削除を検出)", () {
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

    test("due は toUtc().toIso8601String() で UTC 文字列化される", () {
      final due = DateTime(2024, 1, 2, 3, 4, 5);
      final submission = Submission.from(
        id: 1,
        title: "t",
        details: "d",
        due: due,
        color: 0,
      );

      expect(submission.toMap()["due"], due.toUtc().toIso8601String());
      // UTC 表記であることを確認 (末尾 Z)
      expect((submission.toMap()["due"] as String).endsWith("Z"), isTrue);
    });
  });

  group("Submission round-trip (fromMap(toMap()))", () {
    test("全フィールドが保存される", () {
      final original = buildSubmission();
      final restored = Submission.fromMap(original.toMap());

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

    test("nullable フィールドが null のまま round-trip する", () {
      final submission = Submission.from(
        id: null,
        title: "t",
        details: "d",
        due: DateTime(2024, 6, 1),
        color: 0,
      );
      final restored = Submission.fromMap(submission.toMap());

      expect(restored.id, isNull);
      expect(restored.googleTasksTaskId, isNull);
      expect(restored.canvasPlannableId, isNull);
      expect(restored.repeatSubmissionCreated, isNull);
    });

    test("due の UTC↔ローカル往復で同一時刻になる", () {
      final due = DateTime(2024, 7, 15, 23, 59);
      final submission = Submission.from(
        id: 1,
        title: "t",
        details: "d",
        due: due,
        color: 0,
      );

      final restored = Submission.fromMap(submission.toMap());
      expect(restored.due, due);
      expect(restored.due.isUtc, isFalse); // toLocal されている
    });
  });

  group("Submission.fromMap の done 後方互換", () {
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

    test("done が bool(true) → true", () {
      expect(Submission.fromMap(baseMap(true)).done, isTrue);
    });

    test("done が bool(false) → false", () {
      expect(Submission.fromMap(baseMap(false)).done, isFalse);
    });

    test("done が int(1) → true (旧スキーマ互換)", () {
      expect(Submission.fromMap(baseMap(1)).done, isTrue);
    });

    test("done が int(0) → false (旧スキーマ互換)", () {
      expect(Submission.fromMap(baseMap(0)).done, isFalse);
    });
  });

  group("Submission.repeat の enum 往復", () {
    for (final repeat in Repeat.values) {
      test("$repeat が index 経由で往復する", () {
        final submission = Submission.from(
          id: 1,
          title: "t",
          details: "d",
          due: DateTime(2024, 1, 1),
          color: 0,
        )..repeat = repeat;

        expect(submission.toMap()["repeat"], repeat.index);
        expect(Submission.fromMap(submission.toMap()).repeat, repeat);
      });
    }
  });
}
