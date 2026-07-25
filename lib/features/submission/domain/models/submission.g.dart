// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission.dart';

// **************************************************************************
// InsertableGenerator
// **************************************************************************

class SubmissionInsertable {
  const SubmissionInsertable({
    required this.title,
    required this.details,
    required this.due,
    required this.repeat,
    required this.color,
  });

  final String title;
  final String details;
  final DateTime due;
  final RepeatType repeat;
  final Color color;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmissionInsertable &&
          title == other.title &&
          details == other.details &&
          due == other.due &&
          repeat == other.repeat &&
          color == other.color;

  @override
  int get hashCode => Object.hash(title, details, due, repeat, color);

  @override
  String toString() =>
      "SubmissionInsertable(title: $title, details: $details, due: $due, repeat: $repeat, color: $color)";
}
