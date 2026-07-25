import "package:isar_community/isar.dart";
import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

import "../../domain/models/digestive.dart";

part "isar_digestive.g.dart";

@Collection()
@Name("Digestive")
@IsarMap(domain: Digestive, insertable: DigestiveInsertable)
class IsarDigestive {
  Id? id;
  int? submissionId;
  bool done = false;
  late DateTime startAt;
  late int minute;
  late String content;

  IsarDigestive();
}
