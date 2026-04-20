import "package:isar_community/isar.dart";
import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

import "../../domain/models/timetable_table.dart";

part "isar_timetable_table.g.dart";

@Collection()
@Name("TimetableTable")
@IsarMap(domain: TimetableTable, insertable: TimetableTableInsertable)
class IsarTimetableTable {
  Id? id;
  late String title;

  IsarTimetableTable();
}
