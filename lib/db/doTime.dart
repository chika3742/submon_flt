import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';

const tableDoTime = "doTime";
const colSubmissionId = "submissionId";
const colStartAt = "startAt";
const colMinute = "minute";
const colContent = "content";

class DoTime {
  int? id;
  int? submissionId;
  DateTime startAt;
  int minute;
  String content;
  bool done;

  DoTime(
      {this.id,
      required this.submissionId,
      required this.startAt,
      required this.minute,
      required this.content,
      required this.done});
}

class DoTimeProvider extends SqlProvider<DoTime> {
  DoTimeProvider({Database? db}) : super(db: db);

  @override
  String tableName() => tableDoTime;

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
  DoTime mapToObj(Map<String, dynamic> map) {
    return DoTime(
        id: map[colId],
        submissionId: map[colSubmissionId],
        startAt: DateTime.parse(map[colStartAt]),
        minute: map[colMinute],
        content: map[colContent],
        done: map[colDone] == 1);
  }

  @override
  Map<String, Object?> objToMap(DoTime data) {
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
    await FirestoreProvider.doTime
        .set(data.id.toString(), objToMap(data), SetOptions(merge: true));
    await FirestoreProvider.addDoTimeNotification(data.id);
  }

  @override
  Future<void> deleteFirestore(int id) async {
    await FirestoreProvider.doTime.delete(id.toString());
    await FirestoreProvider.removeDoTimeNotification(id);
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
