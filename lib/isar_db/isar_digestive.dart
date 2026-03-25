import "package:isar_community/isar.dart";

part "isar_digestive.g.dart";

@Collection()
class Digestive {
  Id? id;
  int? submissionId;
  bool done = false;
  late DateTime startAt;
  late int minute;
  late String content;

  Digestive();

  Digestive.from({
    this.id,
    this.submissionId,
    this.done = false,
    required this.startAt,
    required this.minute,
    required this.content,
  });

  Digestive.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        submissionId = map["submissionId"],
        done = map["done"],
        startAt = DateTime.parse(map["startAt"]).toLocal(),
        minute = map["minute"],
        content = map["content"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "submissionId": submissionId,
      "done": done,
      "startAt": startAt.toUtc().toIso8601String(),
      "minute": minute,
      "content": content,
    };
  }
}
