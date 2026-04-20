import "package:freezed_annotation/freezed_annotation.dart";
import "package:insertable_annotation/insertable_annotation.dart";

part "timetable_table.freezed.dart";
part "timetable_table.g.dart";

@freezed
@generateInsertable
sealed class TimetableTable with _$TimetableTable {
  const factory TimetableTable({
    @insertableIgnore required int id,
    required String title,
  }) = _TimetableTable;
}
