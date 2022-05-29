import 'package:isar/isar.dart';

part '../generated/isar_db/isar_timetable_table.g.dart';

@Collection()
class TimetableTable {
  int? id;
  late String title;

  TimetableTable();
}
