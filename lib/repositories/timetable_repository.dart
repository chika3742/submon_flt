import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:isar_community/isar.dart";

import "../isar_db/isar_timetable.dart";
import "../providers/firestore_providers.dart";

/// Timetable (セル) のリポジトリ。
///
/// Firestore 上では `timetable/{tableId}` ドキュメント内の `cells` マップに
/// ネストして保存されるため、[SyncedRepository] は使わず独自に同期する。
class TimetableRepository {
  TimetableRepository(this.isar, this.firestore, this.crashlytics);

  final Isar isar;
  final FirestoreCollectionNotifier firestore;
  final FirebaseCrashlytics crashlytics;

  IsarCollection<Timetable> get collection => isar.timetables;

  // --- Read ---

  Future<List<Timetable>> getByTableId(int tableId) {
    return collection.filter().tableIdEqualTo(tableId).findAll();
  }

  // --- Write ---

  /// セルを作成して Firestore に同期。
  Future<int> create(Timetable data) async {
    final id = await isar.writeTxn(() => collection.put(data));
    _syncSetCell(data);
    return id;
  }

  /// 既存セルを更新して Firestore に同期。
  Future<void> update(Timetable data) async {
    await isar.writeTxn(() => collection.put(data));
    _syncSetCell(data);
  }

  /// 指定テーブルの特定セルを削除。
  Future<void> deleteCell(int tableId, int cellId) async {
    await isar.writeTxn(
      () => collection
          .filter()
          .cellIdEqualTo(cellId)
          .and()
          .tableIdEqualTo(tableId)
          .deleteFirst(),
    );
    _syncDeleteCell(tableId, cellId);
  }

  /// 指定テーブルの全セルをローカルから削除。
  Future<void> clearTableLocalOnly(int tableId) async {
    await isar.writeTxn(
      () => collection.filter().tableIdEqualTo(tableId).deleteAll(),
    );
  }

  /// 指定テーブルの全セルを削除 (Firestore も含む)。
  Future<void> clearTable(int tableId) async {
    await isar.writeTxn(
      () => collection.filter().tableIdEqualTo(tableId).deleteAll(),
    );
    _wrapFirestoreUpdate(
      firestore.set(
        tableId.toString(),
        {"cells": FieldValue.delete()},
        SetOptions(merge: true),
      ),
    );
  }

  /// テーブルの全セルを一括でローカルに書き込む (Firestore 同期なし)。
  Future<void> putAllLocalOnly(List<Timetable> list) {
    return isar.writeTxn(() => collection.putAll(list));
  }

  /// スナップショットからテーブルを復元 (Undo/Redo 用)。
  /// ローカルをクリアし、全セルを書き込み、Firestore に同期する。
  Future<void> restoreSnapshot(
    int tableId,
    Map<int, Timetable> snapshot,
  ) async {
    final items = snapshot.values.toList();
    await isar.writeTxn(() async {
      await collection.filter().tableIdEqualTo(tableId).deleteAll();
      await collection.putAll(items);
    });
    _syncSetAllCells(tableId.toString(), items);
  }

  // --- Firestore sync (private) ---

  void _syncSetCell(Timetable data) {
    _wrapFirestoreUpdate(
      firestore.set(
        data.tableId.toString(),
        {
          "cells": {data.cellId.toString(): data.toMap()},
        },
        SetOptions(merge: true),
      ),
    );
  }

  /// [tableId]s in cells are ignored.
  void _syncSetAllCells(String tableId, List<Timetable> data) {
    _wrapFirestoreUpdate(
      firestore.set(
        tableId,
        {
          "cells": {
            for (final item in data) item.cellId.toString(): item.toMap(),
          },
        },
        SetOptions(merge: true),
      ),
    );
  }

  void _syncDeleteCell(int tableId, int cellId) {
    _wrapFirestoreUpdate(
      firestore.set(
        tableId.toString(),
        {
          "cells": {cellId.toString(): FieldValue.delete()},
        },
        SetOptions(merge: true),
      ),
    );
  }

  void _wrapFirestoreUpdate(Future<void> future) {
    future.catchError((e, st) {
      debugPrint("Firestore sync error: $e");
      crashlytics.recordError(e, st);
    });
  }
}
