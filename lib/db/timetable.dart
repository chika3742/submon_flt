import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:submon/db/firestore.dart';
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
  Timetable mapToObj(Map map) {
    return Timetable(
      id: map[colId],
      subject: map[colSubject],
      note: map[colNote],
    );
  }

  @override
  Map<String, Object?> objToMap(Timetable data) {
    return objToMapStatic(data);
  }

  static Map<String, Object?> objToMapStatic(Timetable data) {
    return {
      colId: data.id,
      colSubject: data.subject,
      colNote: data.note,
    };
  }

  @override
  void setFirestore(Timetable data) {
    FirestoreProvider.timetable.set(
        "data", {data.id.toString(): objToMap(data)}, SetOptions(merge: true));
  }

  @override
  void deleteFirestore(int id) {
    FirestoreProvider.timetable.set(
        "data", {id.toString(): FieldValue.delete()}, SetOptions(merge: true));
  }

  @override
  void deleteAllFirestore() {
    FirestoreProvider.timetable.delete("data");
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {
    FirestoreProvider.timetable.set(
        "data",
        Map.fromIterables(
            list.map((e) => e["id"].toString()), list.map((e) => e)));
  }
}