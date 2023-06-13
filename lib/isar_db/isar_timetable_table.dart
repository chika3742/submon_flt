import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/isar_db/isar_provider.dart';

part '../generated/isar_db/isar_timetable_table.g.dart';

@Collection()
class TimetableTable {
  Id? id;
  late String title;

  TimetableTable();

  TimetableTable.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"];

  TimetableTable.from({this.id, required this.title});
}

class TimetableTableProvider extends IsarProvider<TimetableTable> {
  @override
  Future<void> setFirestore(TimetableTable data, int id) {
    return FirestoreProvider.timetable.set(
        id.toString(),
        {
          "title": data.title,
        },
        SetOptions(merge: true));
  }

  @override
  Future<void> deleteFirestore(int id) {
    return FirestoreProvider.timetable.delete(id.toString());
  }

  @override
  Future<void> use(
      Future<void> Function(TimetableTableProvider provider) callback) async {
    await open();
    await callback(this);
  }
}
