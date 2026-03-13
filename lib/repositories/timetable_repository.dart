import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:isar_community/isar.dart";

import "../db/firestore_provider.dart";
import "../isar_db/isar_timetable.dart";
import "../utils/utils.dart";

/// Timetable (セル) のリポジトリ。
///
/// Firestore 上では `timetable/{tableId}` ドキュメント内の `cells` マップに
/// ネストして保存されるため、[SyncedRepository] は使わず独自に同期する。
class TimetableRepository {
  TimetableRepository(this.isar);

  final Isar isar;

  IsarCollection<Timetable> get collection => isar.timetables;

  // --- Read ---

  Future<List<Timetable>> getByTableId(int tableId) {
    return collection.filter().tableIdEqualTo(tableId).findAll();
  }

  // --- Write ---

  /// セルを作成して Firestore に同期。
  Future<int> create(Timetable data) async {
    final id = await collection.put(data);
    _syncSetCell(data);
    return id;
  }

  /// 既存セルを更新して Firestore に同期。
  Future<void> update(Timetable data) async {
    await collection.put(data);
    _syncSetCell(data);
  }

  /// 指定テーブルの特定セルを削除。
  Future<void> deleteCell(int tableId, int cellId) async {
    await collection
        .filter()
        .cellIdEqualTo(cellId)
        .and()
        .tableIdEqualTo(tableId)
        .deleteFirst();
    _syncDeleteCell(tableId, cellId);
  }

  /// 指定テーブルの全セルをローカルから削除。
  Future<void> clearTableLocalOnly(int tableId) async {
    await collection.filter().tableIdEqualTo(tableId).deleteAll();
  }

  /// 指定テーブルの全セルを削除 (Firestore も含む)。
  Future<void> clearTable(int tableId) async {
    await collection.filter().tableIdEqualTo(tableId).deleteAll();
    _wrapFirestoreUpdate(
      FirestoreProvider.timetable.set(
        tableId.toString(),
        {"cells": FieldValue.delete()},
        SetOptions(merge: true),
      ),
    );
  }

  /// テーブルの全セルを一括でローカルに書き込む (Firestore 同期なし)。
  Future<void> putAllLocalOnly(List<Timetable> list) {
    return collection.putAll(list);
  }

  /// スナップショットからテーブルを復元 (Undo/Redo 用)。
  /// ローカルをクリアし、全セルを書き込み、Firestore に同期する。
  Future<void> restoreSnapshot(
    int tableId,
    Map<int, Timetable> snapshot,
  ) async {
    await clearTableLocalOnly(tableId);
    final items = snapshot.values.toList();
    await collection.putAll(items);
    for (final item in items) {
      _syncSetCell(item);
    }
  }

  // --- Firestore sync (private) ---

  void _syncSetCell(Timetable data) {
    _wrapFirestoreUpdate(
      FirestoreProvider.timetable.set(
        data.tableId.toString(),
        {
          "cells": {data.cellId.toString(): data.toMap()},
        },
        SetOptions(merge: true),
      ),
    );
  }

  void _syncDeleteCell(int tableId, int cellId) {
    _wrapFirestoreUpdate(
      FirestoreProvider.timetable.set(
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
      recordErrorToCrashlytics(e, st);
    });
  }
}
