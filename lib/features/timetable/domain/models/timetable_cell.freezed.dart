// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimetableCell {

 int get tableId; int get period; int get weekday;// 1 = Monday, ..., 7 = Sunday
 String get subject; String get teacher; String get classroom; String get note;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableCell&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.period, period) || other.period == period)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,tableId,period,weekday,subject,teacher,classroom,note);

@override
String toString() {
  return 'TimetableCell(tableId: $tableId, period: $period, weekday: $weekday, subject: $subject, teacher: $teacher, classroom: $classroom, note: $note)';
}


}





/// @nodoc


class _TimetableCell implements TimetableCell {
   _TimetableCell({required this.tableId, required this.period, required this.weekday, required this.subject, required this.teacher, required this.classroom, required this.note}): assert(subject.isNotEmpty);
  

@override final  int tableId;
@override final  int period;
@override final  int weekday;
// 1 = Monday, ..., 7 = Sunday
@override final  String subject;
@override final  String teacher;
@override final  String classroom;
@override final  String note;




@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableCell&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.period, period) || other.period == period)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.classroom, classroom) || other.classroom == classroom)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,tableId,period,weekday,subject,teacher,classroom,note);

@override
String toString() {
  return 'TimetableCell(tableId: $tableId, period: $period, weekday: $weekday, subject: $subject, teacher: $teacher, classroom: $classroom, note: $note)';
}


}




// dart format on
