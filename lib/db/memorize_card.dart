import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';

const tableMemorizeCard = "memorizeCard";

const colFront = "front";
const colBack = "back";
const colFolderId = "folderId";
const colLastDisplayed = "lastDisplayed";
const colCorrectRate = "correctRate";

class MemorizeCard {
  int? id;
  String front;
  String back;
  int folderId;
  DateTime? lastDisplayed;
  double? correctRate;

  MemorizeCard(
      {this.id,
      required this.front,
      required this.back,
      required this.folderId,
      this.lastDisplayed,
      this.correctRate});
}

class MemorizeCardProvider extends SqlProvider<MemorizeCard> {
  @override
  String tableName() => tableMemorizeCard;

  @override
  List<SqlField> columns() => [
        SqlField(colId, DataType.integer, isPrimaryKey: true),
        SqlField(colFront, DataType.string),
        SqlField(colBack, DataType.string),
        SqlField(colFolderId, DataType.integer),
        SqlField(colLastDisplayed, DataType.string, isNonNull: false),
        SqlField(colCorrectRate, DataType.real, isNonNull: false),
      ];

  @override
  void deleteAllFirestore() {
    // TODO: implement deleteAllFirestore
  }

  @override
  MemorizeCard mapToObj(Map<String, dynamic> map) {
    return MemorizeCard(
      id: map[colId],
      front: map[colFront],
      back: map[colBack],
      folderId: map[colFolderId],
      lastDisplayed: DateTime.parse(map[colLastDisplayed]),
      correctRate: map[colCorrectRate],
    );
  }

  @override
  Map<String, Object?> objToMap(MemorizeCard data) {
    return {
      colId: data.id,
      colFront: data.front,
      colBack: data.back,
      colFolderId: data.folderId,
      colLastDisplayed: data.lastDisplayed?.toIso8601String(),
      colCorrectRate: data.correctRate,
    };
  }

  @override
  void setAllFirestore(List<Map<String, dynamic>> list) {
    // TODO: implement setAllFirestore
  }

  @override
  Future<void> setFirestore(MemorizeCard data) async {
    // TODO: implement setFirestore
  }

  @override
  Future<void> deleteFirestore(int id) async {
    // TODO: implement deleteFirestore
  }
}
