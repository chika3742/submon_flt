import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:insertable_annotation/insertable_annotation.dart";

part "submission.freezed.dart";
part "submission.g.dart";

@freezed
@generateInsertable
sealed class Submission with _$Submission {
  @Assert("title.isNotEmpty")
  factory Submission({
    @insertableIgnore required int id,
    required String title,
    required String details,
    required DateTime due,
    @insertableIgnore @Default(false) bool done,
    @insertableIgnore @Default(false) bool important,
    required RepeatType repeat,
    @insertableIgnore @Default(false) bool repeatSubmissionCreated,
    required Color color,
    @insertableIgnore String? googleTasksTaskId,
  }) = _Submission;
}

enum RepeatType {
  none,
  weekly,
  monthly,
}
