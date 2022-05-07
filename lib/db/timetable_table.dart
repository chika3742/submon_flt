import 'package:submon/db/firestore_provider.dart';
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
  String tableName() => tableTimetableTable;

  @override
  List<SqlField> columns() {
    return [
      SqlField("id", DataType.integer, isPrimaryKey: true),
      SqlField("title", DataType.string),
    ];
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
  Future<void> setFirestore(TimetableTable data) async {
    await FirestoreProvider.timetable
        .set(data.id.toString(), {"title": data.title});
  }

  @override
  void deleteAllFirestore() {}

  @override
  Future<void> deleteFirestore(int id) async {
    await FirestoreProvider.timetable.delete(id.toString());
  }
}
