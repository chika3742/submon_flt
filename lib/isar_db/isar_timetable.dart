import 'package:isar/isar.dart';

part '../generated/isar_db/isar_timetable.g.dart';

@Collection()
class Timetable {
  int? id;

  late int? tableId;
  late int cellId;
  late String subject;
  late String room;
  late String teacher;
  late String note;

  Timetable();
}
