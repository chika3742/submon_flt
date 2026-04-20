import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/features/submission/data/models/isar_submission.dart";
import "package:submon/features/submission/domain/models/submission.dart";

void main() {
  group("IsarSubmission mapper", () {
    test("Submission round-trips through Isar", () {
      final Submission submission = Submission(
        id: 42,
        title: "数学",
        details: "課題",
        due: DateTime(2026, 4, 20, 9),
        done: true,
        important: true,
        repeat: RepeatType.weekly,
        color: const Color(0xFF123456),
        googleTasksTaskId: "task-1",
        repeatSubmissionCreated: true,
      );

      final Submission roundTripped = submission.toIsar().toDomain();

      expect(roundTripped, submission);
    });

    test("SubmissionInsertable keeps repeat and converted color during toIsar", () {
      final SubmissionInsertable insertable = SubmissionInsertable(
        title: "英語",
        details: "宿題",
        due: DateTime(2026, 4, 21, 8),
        repeat: RepeatType.monthly,
        color: const Color(0xFF654321),
      );

      final IsarSubmission isar = insertable.toIsar();

      expect(isar.repeat, RepeatType.monthly);
      expect(isar.color, const Color(0xFF654321).toARGB32());
    });
  });
}
