import "package:freezed_annotation/freezed_annotation.dart";

part "timetable_cell.freezed.dart";

typedef TimetableCells = Map<({int period, int weekday}), TimetableCell>;

@freezed
sealed class TimetableCell with _$TimetableCell {
  @Assert("subject.isNotEmpty")
  factory TimetableCell({
    required int tableId,
    required int period,
    required int weekday, // 1 = Monday, ..., 7 = Sunday
    required String subject,
    required String teacher,
    required String classroom,
    required String note,
  }) = _TimetableCell;
}
