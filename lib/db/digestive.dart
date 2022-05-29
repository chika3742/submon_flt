import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';

const tableDigestive = "digestive";
const colSubmissionId = "submissionId";
const colStartAt = "startAt";
const colMinute = "minute";
const colContent = "content";

class Digestive {
  int? id;
  int? submissionId;
  DateTime startAt;
  int minute;
  String content;
  bool done;

  Digestive({
    this.id,
    required this.submissionId,
    required this.startAt,
    required this.minute,
    required this.content,
    required this.done,
  });
}

class DigestiveProvider extends SqlProvider<Digestive> {
  DigestiveProvider({Database? db}) : super(db: db);

  @override
  String tableName() => tableDigestive;

  @override
  List<SqlField> columns() {
    return [
      SqlField(colId, DataType.integer, isPrimaryKey: true),
      SqlField(colSubmissionId, DataType.integer, isNonNull: false),
      SqlField(colStartAt, DataType.string),
      SqlField(colMinute, DataType.integer),
      SqlField(colContent, DataType.string),
      SqlField(colDone, DataType.integer),
    ];
  }

  @override
  Digestive mapToObj(Map<String, dynamic> map) {
    return Digestive(
        id: map[colId],
        submissionId: map[colSubmissionId],
        startAt: DateTime.parse(map[colStartAt]),
        minute: map[colMinute],
        content: map[colContent],
        done: map[colDone] == 1);
  }

  @override
  Map<String, Object?> objToMap(Digestive data) {
    return {
      colId: data.id,
      colSubmissionId: data.submissionId,
      colStartAt: data.startAt.toIso8601String(),
      colMinute: data.minute,
      colContent: data.content,
      colDone: data.done ? 1 : 0,
    };
  }

  @override
  Future<void> setFirestore(data) async {
    await FirestoreProvider.digestive
        .set(data.id.toString(), objToMap(data), SetOptions(merge: true));
    await FirestoreProvider.addDigestiveNotification(data.id);
  }

  @override
  Future<void> deleteFirestore(int id) async {
    await FirestoreProvider.digestive.delete(id.toString());
    await FirestoreProvider.removeDigestiveNotification(id);
  }

  Future<void> deleteForSubmissionId(int submissionId) async {
    var items =
        await getAll(where: "$colSubmissionId = ?", whereArgs: [submissionId]);
    for (var e in items) {
      await delete(e.id!);
    }
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {}

  @override
  void deleteAllFirestore() {}
}
