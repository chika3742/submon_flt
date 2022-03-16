import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:submon/db/firestore.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/utils/firestore.dart';

const tableDoTime = "doTime";
const colSubmissionId = "submissionId";
const colStartAt = "startAt";
const colMinute = "minute";
const colContent = "content";

class DoTime {
  int? id;
  int submissionId;
  DateTime startAt;
  int minute;
  String content;

  DoTime({this.id,
    required this.submissionId,
    required this.startAt,
    required this.minute,
    required this.content});
}

class DoTimeProvider extends SqlProvider<DoTime> {
  @override
  String tableName() => tableDoTime;

  @override
  List<SqlField> columns() {
    return [
      SqlField(colId, DataType.integer, isPrimaryKey: true),
      SqlField(colSubmissionId, DataType.integer),
      SqlField(colStartAt, DataType.string),
      SqlField(colMinute, DataType.integer),
      SqlField(colContent, DataType.string),
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
    );
  }

  @override
  Map<String, Object?> objToMap(DoTime data) {
    return {
      colId: data.id,
      colSubmissionId: data.submissionId,
      colStartAt: data.startAt.toIso8601String(),
      colMinute: data.minute,
      colContent: data.content,
    };
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {
    // TODO: implement
  }

  @override
  void setFirestore(data) {
    FirestoreProvider.doTime
        .set(data.id.toString(), objToMap(data), SetOptions(merge: true));
    FirestoreProvider.addDoTimeNotification(
        userDoc?.collection("doTime").doc(data.id.toString()));
  }

  @override
  void deleteAllFirestore() {
    // TODO: implement deleteAllFirestore
  }

  @override
  void deleteFirestore(int id) {
    FirestoreProvider.doTime.delete(id.toString());
    FirestoreProvider.removeDoTimeNotification(
        userDoc?.collection("doTime").doc(id.toString()));
  }
}
