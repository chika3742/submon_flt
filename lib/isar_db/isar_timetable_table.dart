import "package:isar_community/isar.dart";

part "isar_timetable_table.g.dart";

@Collection()
class TimetableTable {
  Id? id;
  late String title;

  TimetableTable();

  TimetableTable.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"];

  TimetableTable.from({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
    };
  }
}
