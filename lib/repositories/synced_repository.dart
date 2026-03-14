import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:isar_community/isar.dart";

import "../db/firestore_provider.dart";
import "../utils/utils.dart";

/// Isar ↔ Firestore 同期を自動化する Repository 基底クラス。
///
/// サブクラスは [collection], [firestoreProvider], [toFirestoreMap] を実装する。
/// [put] / [delete] を呼ぶだけで Firestore 側も自動的に同期される。
/// Firestore 同期なしでローカルに書き込む場合は [putAllLocalOnly] を使う。
abstract class SyncedRepository<T> {
  SyncedRepository(this.isar);

  final Isar isar;

  IsarCollection<T> get collection;

  FirestoreProvider get firestoreProvider;

  Map<String, dynamic> toFirestoreMap(T data);

  /// Firestore 同期完了後に呼ばれるフック。Widget 更新などに使う。
  void onFirestoreUpdated() {}

  // --- Read ---

  Future<T?> get(int id) => collection.get(id);

  Future<List<T>> getAll() => collection.where().findAll();

  // --- Write (自動同期) ---

  @protected
  Future<int> put(T data) async {
    final id = await isar.writeTxn(() => collection.put(data));
    _syncSet(data, id);
    return id;
  }

  @protected
  Future<List<int>> putAll(List<T> list) async {
    final ids = await isar.writeTxn(() => collection.putAll(list));
    _syncBatchSet(list, ids);
    return ids;
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() => collection.delete(id));
    _syncDelete(id);
  }

  /// Firestore に同期せずローカルのみに書き込む。
  /// [FirestoreProvider.fetchData] からの一括インポート用。
  Future<void> putAllLocalOnly(List<T> list) {
    return isar.writeTxn(() => collection.putAll(list));
  }

  // --- Firestore sync (private) ---

  void _syncSet(T data, int id) {
    _wrapFirestoreUpdate(
      firestoreProvider.set(
        id.toString(),
        toFirestoreMap(data),
        SetOptions(merge: true),
      ),
    );
  }

  void _syncBatchSet(List<T> list, List<int> ids) {
    final entries = {
      for (var i = 0; i < list.length; i++)
        ids[i].toString(): toFirestoreMap(list[i]),
    };
    _wrapFirestoreUpdate(
      firestoreProvider.batchSet(entries, SetOptions(merge: true)),
    );
  }

  void _syncDelete(int id) {
    _wrapFirestoreUpdate(
      firestoreProvider.delete(id.toString()),
    );
  }

  void _wrapFirestoreUpdate(Future<void> future) {
    future.catchError((e, st) {
      debugPrint("Firestore sync error: $e");
      recordErrorToCrashlytics(e, st);
    }).then((_) {
      onFirestoreUpdated();
    });
  }
}
