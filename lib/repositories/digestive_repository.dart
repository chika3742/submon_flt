import "package:isar_community/isar.dart";

import "../isar_db/isar_digestive.dart";
import "../providers/firestore_providers.dart";
import "../utils/types.dart";
import "synced_repository.dart";

class DigestiveRepository extends SyncedRepository<Digestive> {
  DigestiveRepository(super.isar, super.firestore, this._userConfig);

  final FirestoreUserConfigNotifier _userConfig;

  @override
  IsarCollection<Digestive> get collection => isar.digestives;

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
    _userConfig.removeDigestiveNotification(id);
  }

  // --- Write ---

  /// 新規作成。
  Future<int> create(Digestive data) => put(data);

  /// 複数の Digestive を一括作成。
  Future<List<int>> createAll(List<Digestive> list) => putAll(list);

  /// 既存データを更新。
  Future<void> update(Digestive data) async {
    await put(data);
  }

  /// 完了状態を指定値に変更。
  Future<void> markDone(Digestive digestive, {required bool done}) {
    return put(digestive..done = done);
  }

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
      _userConfig.removeDigestiveNotification(data.id);
    } else if (data.startAt.isAfter(DateTime.now())) {
      _userConfig.addDigestiveNotification(data.id);
    }
  }
}
