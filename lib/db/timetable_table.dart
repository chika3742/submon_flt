import 'package:submon/db/firestore.dart';
import 'package:submon/db/sql_provider.dart';

const tableTimetableTable = "timetableTable";
const colId = "id";
const colTitle = "title";

class TimetableTable {
  /// null means main
  int? id;
  String? title;

  TimetableTable({this.id, this.title});
}

class TimetableTableProvider extends SqlProvider<TimetableTable> {
  @override
  List<SqlField> columns() {
    return [
      SqlField("id", DataType.integer, isPrimaryKey: true),
      SqlField("title", DataType.integer),
    ];
  }

  @override
  void deleteAllFirestore() {}

  @override
  void deleteFirestore(int id) {
    FirestoreProvider.timetable.delete(id.toString());
  }

  @override
  TimetableTable mapToObj(Map<String, dynamic> map) {
    return TimetableTable(title: map[colTitle], id: map[colId]);
  }

  @override
  Map<String, Object?> objToMap(TimetableTable data) {
    return {
      colId: data.id,
      colTitle: data.title,
    };
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {}

  @override
  void setFirestore(TimetableTable data) {
    FirestoreProvider.timetable.set(data.id.toString(), {"title": data.title});
  }

  @override
  String tableName() => tableTimetableTable;
}
