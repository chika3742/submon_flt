// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Submission {

@insertableIgnore int get id; String get title; String get details; DateTime get due;@insertableIgnore bool get done;@insertableIgnore bool get important; RepeatType get repeat;@insertableIgnore bool get repeatSubmissionCreated; Color get color;@insertableIgnore String? get googleTasksTaskId;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Submission&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.details, details) || other.details == details)&&(identical(other.due, due) || other.due == due)&&(identical(other.done, done) || other.done == done)&&(identical(other.important, important) || other.important == important)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.repeatSubmissionCreated, repeatSubmissionCreated) || other.repeatSubmissionCreated == repeatSubmissionCreated)&&(identical(other.color, color) || other.color == color)&&(identical(other.googleTasksTaskId, googleTasksTaskId) || other.googleTasksTaskId == googleTasksTaskId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,details,due,done,important,repeat,repeatSubmissionCreated,color,googleTasksTaskId);

@override
String toString() {
  return 'Submission(id: $id, title: $title, details: $details, due: $due, done: $done, important: $important, repeat: $repeat, repeatSubmissionCreated: $repeatSubmissionCreated, color: $color, googleTasksTaskId: $googleTasksTaskId)';
}


}





/// @nodoc


class _Submission implements Submission {
   _Submission({@insertableIgnore required this.id, required this.title, required this.details, required this.due, @insertableIgnore this.done = false, @insertableIgnore this.important = false, required this.repeat, @insertableIgnore this.repeatSubmissionCreated = false, required this.color, @insertableIgnore this.googleTasksTaskId}): assert(title.isNotEmpty);
  

@override@insertableIgnore final  int id;
@override final  String title;
@override final  String details;
@override final  DateTime due;
@override@JsonKey()@insertableIgnore final  bool done;
@override@JsonKey()@insertableIgnore final  bool important;
@override final  RepeatType repeat;
@override@JsonKey()@insertableIgnore final  bool repeatSubmissionCreated;
@override final  Color color;
@override@insertableIgnore final  String? googleTasksTaskId;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submission&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.details, details) || other.details == details)&&(identical(other.due, due) || other.due == due)&&(identical(other.done, done) || other.done == done)&&(identical(other.important, important) || other.important == important)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.repeatSubmissionCreated, repeatSubmissionCreated) || other.repeatSubmissionCreated == repeatSubmissionCreated)&&(identical(other.color, color) || other.color == color)&&(identical(other.googleTasksTaskId, googleTasksTaskId) || other.googleTasksTaskId == googleTasksTaskId));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,details,due,done,important,repeat,repeatSubmissionCreated,color,googleTasksTaskId);

@override
String toString() {
  return 'Submission(id: $id, title: $title, details: $details, due: $due, done: $done, important: $important, repeat: $repeat, repeatSubmissionCreated: $repeatSubmissionCreated, color: $color, googleTasksTaskId: $googleTasksTaskId)';
}


}




// dart format on
