import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/isar_db/isar_provider.dart';

part '../generated/isar_db/isar_digestive.g.dart';

@Collection()
class Digestive {
  int? id;
  int? submissionId;
  bool done = false;
  late DateTime startAt;
  late int minute;
  late String content;

  Digestive();

  Digestive.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        submissionId = map["submissionId"],
        done = map["done"],
        startAt = map["startAt"],
        minute = map["minute"],
        content = map["content"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "submissionId": submissionId,
      "done": done,
      "startAt": startAt,
      "minute": minute,
      "content": content,
    };
  }
}

class DigestiveProvider extends IsarProvider<Digestive> {
  ///
  /// [submissionId]に一致するDigestiveを削除する。
  ///
  /// このメソッドは[writeTransaction]でラップしないこと。
  ///
  Future<void> deleteBySubmissionId(int submissionId) async {
    var items =
        await collection.filter().submissionIdEqualTo(submissionId).findAll();

    await writeTransaction(() {
      return collection.deleteAll(items.map((e) => e.id!).toList());
    });
  }

  Future<List<Digestive>> getUndoneDigestives() {
    return collection.filter().doneEqualTo(false).sortByStartAt().findAll();
  }

  Future<List<Digestive>> getDoneDigestives() {
    return collection.filter().doneEqualTo(true).sortByStartAtDesc().findAll();
  }

  Future<List<Digestive>> getDigestivesBySubmissionId(int submissionId) {
    return collection
        .filter()
        .submissionIdEqualTo(submissionId)
        .sortByStartAt()
        .findAll();
  }

  Future<void> invertDone(Digestive data) {
    return put(data..done = !data.done);
  }

  @override
  Future<void> deleteFirestore(int id) async {
    await FirestoreProvider.digestive.delete(id.toString());
    await FirestoreProvider.removeDigestiveNotification(id);
  }

  @override
  Future<void> setFirestore(Digestive data, id) async {
    await FirestoreProvider.digestive
        .set(id.toString(), data.toMap(), SetOptions(merge: true));
    await FirestoreProvider.addDigestiveNotification(id);
  }

  @override
  Future<void> use(
      Future<void> Function(DigestiveProvider provider) callback) async {
    await open();
    await callback(this);
  }
}
