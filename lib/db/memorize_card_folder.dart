import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';

const tableMemorizeCardFolder = "memorizeCardFolder";

class MemorizeCardFolder {
  int? id;
  String title;

  MemorizeCardFolder({this.id, required this.title});
}

class MemorizeCardFolderProvider extends SqlProvider<MemorizeCardFolder> {
  @override
  String tableName() => tableMemorizeCardFolder;

  @override
  List<SqlField> columns() {
    return [
      SqlField(colId, DataType.integer, isPrimaryKey: true),
      SqlField(colTitle, DataType.string),
    ];
  }

  @override
  MemorizeCardFolder mapToObj(Map<String, dynamic> map) {
    return MemorizeCardFolder(
      id: map["id"],
      title: map["title"],
    );
  }

  @override
  Map<String, Object?> objToMap(MemorizeCardFolder data) {
    return {
      colId: data.id,
      colTitle: data.title,
    };
  }

  @override
  Future<void> setFirestore(MemorizeCardFolder data) async {
    await FirestoreProvider.memorizeCard.set(
      data.id.toString(),
      objToMap(data),
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteFirestore(int id) async {
    await FirestoreProvider.memorizeCard.delete(id.toString());
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {}

  @override
  void deleteAllFirestore() {}
}
