import "package:googleapis/tasks/v1.dart";

import "../../../isar_db/isar_submission.dart";
import "../../../utils/app_links.dart";

Task createTaskFromSubmission(Submission submission, {required String uid}) {
  return Task(
    id: submission.googleTasksTaskId,
    title: "${submission.title} (Submon)",
    notes: "Submon アプリ内で開く→${createSubmissionLink(submission.id!, uid: uid)}",
    due: submission.due.toUtc().toIso8601String(),
  );
}
