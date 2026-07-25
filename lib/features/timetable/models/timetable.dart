import "package:isar_community/isar.dart";

part "timetable.g.dart";

@Collection()
class Timetable {
  Id? id;

  late int tableId;
  late int cellId;
  late String subject;
  String room = "";
  String teacher = "";
  String note = "";

  Timetable();

  Timetable.from({this.id, required this.cellId, required this.subject, required this.room, required this.teacher});

  Timetable.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        tableId = map["tableId"],
        cellId = map["cellId"],
        subject = map["subject"],
        room = map["room"],
        teacher = map["teacher"],
        note = map["note"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tableId": tableId,
      "cellId": cellId,
      "subject": subject,
      "room": room,
      "teacher": teacher,
      "note": note,
    };
  }
}

/// A snapshot of a timetable keyed by cellId.
typedef TimetableSnapshot = Map<int, Timetable>;

/// Converts a [List<Timetable>] into a [Map] keyed by cellId.
extension TimetableCellIdMap on List<Timetable> {
  TimetableSnapshot toCellIdMap() => {for (final e in this) e.cellId: e};
}
