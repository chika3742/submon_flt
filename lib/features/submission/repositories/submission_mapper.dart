import "../models/submission.dart";

/// Bidirectional mapper between the [Submission] domain model and its Firestore
/// persistence representation (DTO).
///
/// Both directions are plain top-level functions so the call style stays
/// symmetric (`submissionToMap` / `submissionFromMap`). Firestore key strings
/// and the serialization format must never change (server compatibility).

/// Converts a [Submission] into its Firestore persistence [Map].
Map<String, dynamic> submissionToMap(Submission submission) {
  return {
    "id": submission.id,
    "title": submission.title,
    "details": submission.details,
    "due": submission.due.toUtc().toIso8601String(),
    "done": submission.done,
    "important": submission.important,
    "repeat": submission.repeat.index,
    "color": submission.color,
    "googleTasksTaskId": submission.googleTasksTaskId,
    "canvasPlannableId": submission.canvasPlannableId,
    "repeatSubmissionCreated": submission.repeatSubmissionCreated,
  };
}

/// Restores a [Submission] from a Firestore [Map].
Submission submissionFromMap(Map<String, dynamic> map) {
  return Submission.from(
    id: map["id"],
    title: map["title"],
    details: map["details"],
    due: DateTime.parse(map["due"]).toLocal(),
    color: map["color"],
  )
    ..done = map["done"] is bool ? map["done"] : map["done"] == 1
    ..important = map["important"]
    ..repeat = Repeat.values[map["repeat"]]
    ..googleTasksTaskId = map["googleTasksTaskId"]
    ..canvasPlannableId = map["canvasPlannableId"]
    ..repeatSubmissionCreated = map["repeatSubmissionCreated"];
}
