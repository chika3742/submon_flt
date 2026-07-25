// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digestive.dart';

// **************************************************************************
// InsertableGenerator
// **************************************************************************

class DigestiveInsertable {
  const DigestiveInsertable({
    required this.submissionId,
    required this.startAt,
    required this.minute,
    required this.content,
  });

  final int? submissionId;
  final DateTime startAt;
  final int minute;
  final String content;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigestiveInsertable &&
          submissionId == other.submissionId &&
          startAt == other.startAt &&
          minute == other.minute &&
          content == other.content;

  @override
  int get hashCode => Object.hash(submissionId, startAt, minute, content);

  @override
  String toString() =>
      "DigestiveInsertable(submissionId: $submissionId, startAt: $startAt, minute: $minute, content: $content)";
}
