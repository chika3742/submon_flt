import 'package:sqflite_common/sqlite_api.dart';
import 'package:submon/db/sql_provider.dart';

const tableTimetable = "timetable";
const colId = "id";
const colSubject = "subject";
const colNote = "note";

class Timetable {
  int? id;
  String subject;
  String note;

  static var undoList = <Map<int, Timetable>>[];
  static var redoList = <Map<int, Timetable>>[];

  Timetable({
    this.id,
    this.subject = "",
    this.note = "",
  });

  @override
  String toString() {
    return {
      "id": id,
      "subject": subject,
      "note": note,
    }.toString();
  }
}

class TimetableProvider extends SqlProvider<Timetable> {
  @override
  String tableName() => tableTimetable;

  @override
  List<SqlField> columns() {
    return [
      SqlField(colId, DataType.integer, isPrimaryKey: true),
      SqlField(colSubject, DataType.string),
      SqlField(colNote, DataType.string),
    ];
  }

  @override
  void migrate(Database db, int oldVersion, int newVersion) {}

  @override
  Timetable mapToObj(Map map) {
    return Timetable(
      id: map[colId],
      subject: map[colSubject],
      note: map[colNote],
    );
  }

  @override
  Map<String, Object?> objToMap(Timetable data) {
    return {
      colId: data.id,
      colSubject: data.subject,
      colNote: data.note,
    };
  }
}