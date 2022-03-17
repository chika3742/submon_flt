import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/sql_provider.dart';

const tableTimetableCustomSubject = "timetableCustomSubject";
const colId = "id";
const colTitle = "title";

class TimetableCustomSubject {
  int? id;
  String title;

  TimetableCustomSubject({
    required this.title,
    this.id,
  });
}

class TimetableCustomSubjectProvider
    extends SqlProvider<TimetableCustomSubject> {
  @override
  String tableName() => tableTimetableCustomSubject;

  @override
  List<SqlField> columns() {
    return [
      SqlField(colId, DataType.integer, isPrimaryKey: true),
      SqlField(colTitle, DataType.string),
    ];
  }

  @override
  mapToObj(Map<String, dynamic> map) {
    return TimetableCustomSubject(
      id: map[colId],
      title: map[colTitle],
    );
  }

  @override
  Map<String, Object?> objToMap(data) {
    return {
      colId: data.id,
      colTitle: data.title,
    };
  }

  @override
  void setFirestore(data) {
    FirestoreProvider.timetableCustomSubject
        .set(data.id.toString(), objToMap(data), SetOptions(merge: true));
  }

  @override
  void deleteFirestore(int id) {
    FirestoreProvider.timetableCustomSubject.delete(id.toString());
  }

  @override
  void deleteAllFirestore() {}

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {}
}
