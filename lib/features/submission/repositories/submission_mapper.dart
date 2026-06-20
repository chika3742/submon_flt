import "../models/submission.dart";

/// [Submission] ドメインモデルと Firestore 永続化表現（DTO）の相互変換を担う mapper。
///
/// Firestore のキー文字列・直列化フォーマットはサーバ互換のため一切変更しない。
extension SubmissionFirestoreMapper on Submission {
  /// Firestore 永続化用の Map へ変換する。
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "details": details,
      "due": due.toUtc().toIso8601String(),
      "done": done,
      "important": important,
      "repeat": repeat.index,
      "color": color,
      "googleTasksTaskId": googleTasksTaskId,
      "canvasPlannableId": canvasPlannableId,
      "repeatSubmissionCreated": repeatSubmissionCreated,
    };
  }
}

/// Firestore の Map から [Submission] を復元する。
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
