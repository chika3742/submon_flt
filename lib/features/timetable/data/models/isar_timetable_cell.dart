import "package:isar_community/isar.dart";
import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

import "../../domain/models/timetable_cell.dart";

part "isar_timetable_cell.g.dart";

@Collection()
@Name("TimetableCell")
@IsarMap(domain: TimetableCell)
class IsarTimetableCell {
  Id get id => encodeId();
  late int tableId;
  late int period;
  late int weekday;
  late String subject;
  late String classroom;
  late String teacher;
  late String note;

  IsarTimetableCell();

  int encodeId() {
    assert(tableId < (1 << 51) && period < (1 << 8) && weekday < (1 << 4));
    return (tableId << 12) | (period << 4) | weekday;
  }
}
