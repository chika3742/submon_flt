import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/isar_db/isar_provider.dart';

part '../generated/isar_db/isar_digestive.g.dart';

@Collection()
class Digestive {
  Id? id;
  int? submissionId;
  bool done = false;
  late DateTime startAt;
  late int minute;
  late String content;

  Digestive();

  Digestive.from({
    this.id,
    this.submissionId,
    this.done = false,
    required this.startAt,
    required this.minute,
    required this.content,
  });

  Digestive.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        submissionId = map["submissionId"],
        done = map["done"],
        startAt = DateTime.parse(map["startAt"]).toLocal(),
        minute = map["minute"],
        content = map["content"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "submissionId": submissionId,
      "done": done,
      "startAt": startAt.toUtc().toIso8601String(),
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
    var items = await this
        .collection
        .filter()
        .submissionIdEqualTo(submissionId)
        .findAll();

    await writeTransaction(() {
      return this.collection.deleteAll(items.map((e) => e.id!).toList());
    });
  }

  Future<List<Digestive>> getUndoneDigestives() {
    return this
        .collection
        .filter()
        .doneEqualTo(false)
        .sortByStartAt()
        .findAll();
  }

  Future<List<Digestive>> getDoneDigestives() {
    return this
        .collection
        .filter()
        .doneEqualTo(true)
        .sortByStartAtDesc()
        .findAll();
  }

  Future<List<Digestive>> getDigestivesBySubmissionId(int submissionId) {
    return this
        .collection
        .filter()
        .submissionIdEqualTo(submissionId)
        .sortByStartAt()
        .findAll();
  }

  @override
  Future<int> put(Digestive data) {
    if (data.done) {
      FirestoreProvider.removeDigestiveNotification(data.id);
    } else if (data.startAt.isAfter(DateTime.now())) {
      FirestoreProvider.addDigestiveNotification(data.id);
    }
    return super.put(data);
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


