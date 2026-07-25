import "dart:ui";

import "package:isar_community/isar.dart";
import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

import "../../domain/models/submission.dart";

part "isar_submission.g.dart";

class SubmissionColorConverter implements DomainFieldConverter<Color, int> {
  const SubmissionColorConverter();

  @override
  int fromDomain(Color value) => value.toARGB32();

  @override
  Color toDomain(int value) => Color(value);
}

@Collection()
@Name("Submission")
@IsarMap(domain: Submission, insertable: SubmissionInsertable)
class IsarSubmission {
  Id? id;
  late String title;
  late String details;
  late DateTime due;
  bool done = false;
  bool important = false;

  @enumerated
  late RepeatType repeat;

  @ConvertDomainField<SubmissionColorConverter>()
  int color = 0xFFFFFFFF;

  String? googleTasksTaskId;

  bool repeatSubmissionCreated = false;
}
