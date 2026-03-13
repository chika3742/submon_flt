import "package:isar_community/isar.dart";

import "../db/firestore_provider.dart";
import "../isar_db/isar_digestive.dart";
import "../utils/types.dart";
import "synced_repository.dart";

class DigestiveRepository extends SyncedRepository<Digestive> {
  DigestiveRepository(super.isar);

  @override
  IsarCollection<Digestive> get collection => isar.digestives;

  @override
  FirestoreProvider get firestoreProvider => FirestoreProvider.digestive;

  @override
  Map<String, dynamic> toFirestoreMap(Digestive data) => data.toMap();

  @override
  Future<int> put(Digestive data) async {
    final id = await super.put(data);
    _syncNotification(data);
    return id;
  }

  @override
  Future<void> delete(int id) async {
    await super.delete(id);
    FirestoreProvider.removeDigestiveNotification(id);
  }

  // --- Write ---

  Future<void> toggleDone(Digestive digestive) {
    return put(digestive..done = !digestive.done);
  }

  /// submissionId に一致する Digestive を全て削除し、削除されたリストを返す。
  Future<List<Digestive>> deleteBySubmissionId(int submissionId) async {
    final items =
        await collection.filter().submissionIdEqualTo(submissionId).findAll();

    for (final item in items) {
      await delete(item.id!);
    }

    return items;
  }

  /// 削除して元に戻す関数を返す。
  Future<Restorable> deleteItem(int id) async {
    final digestive = await get(id);
    if (digestive == null) return () async {};

    await delete(id);

    return () async {
      await put(digestive);
    };
  }

  // --- Notification (private) ---

  void _syncNotification(Digestive data) {
    if (data.done) {
      FirestoreProvider.removeDigestiveNotification(data.id);
    } else if (data.startAt.isAfter(DateTime.now())) {
      FirestoreProvider.addDigestiveNotification(data.id);
    }
  }
}
