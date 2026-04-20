// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'digestive.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Digestive {

@insertableIgnore int get id; int? get submissionId;@insertableIgnore bool get done; DateTime get startAt; int get minute; String get content;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Digestive&&(identical(other.id, id) || other.id == id)&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.done, done) || other.done == done)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,submissionId,done,startAt,minute,content);

@override
String toString() {
  return 'Digestive(id: $id, submissionId: $submissionId, done: $done, startAt: $startAt, minute: $minute, content: $content)';
}


}





/// @nodoc


class _Digestive implements Digestive {
  const _Digestive({@insertableIgnore required this.id, required this.submissionId, @insertableIgnore this.done = false, required this.startAt, required this.minute, required this.content});
  

@override@insertableIgnore final  int id;
@override final  int? submissionId;
@override@JsonKey()@insertableIgnore final  bool done;
@override final  DateTime startAt;
@override final  int minute;
@override final  String content;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Digestive&&(identical(other.id, id) || other.id == id)&&(identical(other.submissionId, submissionId) || other.submissionId == submissionId)&&(identical(other.done, done) || other.done == done)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,submissionId,done,startAt,minute,content);

@override
String toString() {
  return 'Digestive(id: $id, submissionId: $submissionId, done: $done, startAt: $startAt, minute: $minute, content: $content)';
}


}




// dart format on
