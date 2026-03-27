import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../core/pref_key.dart";
import "../user_config.dart";
import "../utils/batch_operation.dart";
import "core_providers.dart";
import "firebase_providers.dart";
import "functions_service.dart";

part "firestore_providers.g.dart";

/// 現在の認証ユーザーに対応する Firestore ドキュメント参照。
/// 未認証時は null。
@Riverpod(keepAlive: true)
DocumentReference<Map<String, dynamic>>? userDoc(Ref ref) {
  final user = ref.watch(firebaseUserProvider).value;
  if (user == null) return null;
  return ref.watch(firestoreProvider).collection("users").doc(user.uid);
}

abstract interface class FirestoreUserConfigUpdater {
  Future<void> saveNotificationToken(String token);
  Future<void> removeNotificationToken(String token);
  Future<void> initializeUser();
}

/// Firestore 上のユーザー設定 (UserConfig) を管理する StreamNotifier。
///
/// `build()` で Firestore ドキュメントの `snapshots()` を購読し、
/// 各メソッドでの書き込みが自動的に state に反映される。
@Riverpod(keepAlive: true)
class FirestoreUserConfigNotifier extends _$FirestoreUserConfigNotifier
    implements FirestoreUserConfigUpdater {
  DocumentReference<Map<String, dynamic>>? get _userDoc =>
      ref.read(userDocProvider);

  @override
  Future<UserConfig?> build() async {
    final doc = ref.watch(userDocProvider)?.withConverter<UserConfig>(
      fromFirestore: UserConfig.fromFirestore,
      toFirestore: (config, options) => config.toFirestore(),
    );
    if (doc == null) return null;
    return (await doc.get()).data();
  }

  /// タイムスタンプを更新する (PrefKey + Firestore)。
  Future<void> updateTimestamp() async {
    final timestamp = Timestamp.now();
    ref.updatePref(
      PrefKey.firestoreLastChanged,
      timestamp.toDate().microsecondsSinceEpoch,
    );
    await _userDoc?.set({"lastChanged": timestamp}, SetOptions(merge: true));
    ref.invalidateSelf();
  }

  /// 最終アプリ起動日時をサーバータイムスタンプで記録する。
  Future<void> setLastAppOpened() async {
    await _userDoc?.set(
      {"lastAppOpened": FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
    ref.invalidateSelf();
  }

  @override
  Future<void> saveNotificationToken(String token) async {
    await _userDoc?.set({
      "notificationTokens": FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true));
    ref.invalidateSelf();
  }

  @override
  Future<void> removeNotificationToken(String token) async {
    await _userDoc?.set({
      "notificationTokens": FieldValue.arrayRemove([token]),
    }, SetOptions(merge: true));
    ref.invalidateSelf();
  }

  Future<void> setReminderNotificationTime(TimeOfDay? time) async {
    String? timeString;
    if (time != null) {
      timeString = "${time.hour}:${time.minute}";
    }
    await _userDoc?.set(
      {"reminderNotificationTime": timeString},
      SetOptions(merge: true),
    );
    ref.invalidateSelf();
  }

  Future<void> setTimetableNotificationTime(TimeOfDay? time) async {
    await _userDoc?.set({
      "timetableNotificationTime":
          time != null ? "${time.hour}:${time.minute}" : null,
    }, SetOptions(merge: true));
    ref.invalidateSelf();
  }

  Future<void> setTimetableNotificationId(int id) async {
    await _userDoc?.set({
      "timetableNotificationId": id,
    }, SetOptions(merge: true));
    ref.invalidateSelf();
  }

  Future<void> addDigestiveNotification(int? id) async {
    if (id == null) return;
    await _userDoc?.set({
      "digestiveNotifications": FieldValue.arrayUnion(
        [_userDoc!.collection("digestive").doc(id.toString())],
      ),
    }, SetOptions(merge: true));
    ref.invalidateSelf();
  }

  Future<void> removeDigestiveNotification(int? id) async {
    if (id == null) return;
    await _userDoc?.set({
      "digestiveNotifications": FieldValue.arrayRemove(
        [_userDoc!.collection("digestive").doc(id.toString())],
      ),
    }, SetOptions(merge: true));
    ref.invalidateSelf();
  }

  Future<void> setDigestiveNotificationTimeBefore(int value) async {
    await _userDoc?.set(
      {"digestiveNotificationTimeBefore": value},
      SetOptions(merge: true),
    );
    ref.invalidateSelf();
  }

  Future<void> setTimetableShowSaturday(bool value) async {
    final doc = _userDoc;
    if (doc == null) {
      throw StateError("Cannot update timetable config: user is not signed in");
    }
    await doc.update({UserConfig.pathTimetableShowSaturday: value});
    ref.invalidateSelf();
  }

  Future<void> setTimetablePeriodCountToDisplay(int value) async {
    final doc = _userDoc;
    if (doc == null) {
      throw StateError("Cannot update timetable config: user is not signed in");
    }
    await doc.update({UserConfig.pathTimetablePeriodCountToDisplay: value});
    ref.invalidateSelf();
  }

  /// ユーザーを初期化する (Cloud Functions 経由)。
  @override
  Future<void> initializeUser() async {
    await ref.read(functionsServiceProvider).createUser();
    await _userDoc!.set({"schemaVersion": schemaVersion});
    ref.invalidateSelf();
  }
}

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreCollectionProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```
@riverpod
class FirestoreCollectionNotifier extends _$FirestoreCollectionNotifier {
  DocumentReference<Map<String, dynamic>>? _userDoc;
  late String _collectionId;

  @override
  void build(String collectionId) {
    _collectionId = collectionId;
    _userDoc = ref.watch(userDocProvider);
  }

  CollectionReference<Map<String, dynamic>>? get _collectionRef =>
      _userDoc?.collection(_collectionId);

  Future<void> set(
    String docId,
    dynamic data, [
    SetOptions? setOptions,
  ]) async {
    await _collectionRef?.doc(docId).set(data, setOptions);
    await _updateTimestamp();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> get() async {
    assert(_userDoc != null);
    return await _userDoc!.collection(_collectionId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(String docId) async {
    assert(_userDoc != null);
    return await _userDoc!.collection(_collectionId).doc(docId).get();
  }

  Future<bool?> exists(String docId) async {
    return (await _collectionRef?.doc(docId).get())?.exists;
  }

  Future<void> delete(String docId) async {
    await _collectionRef?.doc(docId).delete();
    await _updateTimestamp();
  }

  /// 複数ドキュメントを Firestore バッチで一括書き込みする。
  Future<void> batchSet(
    Map<String, dynamic> entries, [
    SetOptions? setOptions,
  ]) async {
    if (_userDoc == null || entries.isEmpty) return;
    final operations = entries.entries
        .map(
          (e) => BatchOperation.set(
            doc: _collectionRef!.doc(e.key),
            data: e.value,
            setOptions: setOptions,
          ),
        )
        .toList();
    await BatchOperation.commit(operations, firestore: ref.read(firestoreProvider));
    await _updateTimestamp();
  }

  Future<void> _updateTimestamp() async {
    await ref
        .read(firestoreUserConfigProvider.notifier)
        .updateTimestamp();
  }
}

/// リモートに未同期の変更があるかを判定する。
///
/// [config] が null または lastChanged が未設定の場合は `true` を返す
/// (初回起動やデータ未作成)。
bool hasRemoteChanges(UserConfig? config, int? localTimestampMicros) {
  if (config == null || config.lastChanged == null || localTimestampMicros == null) return true;
  return config.lastChanged!.toDate().microsecondsSinceEpoch >
      localTimestampMicros;
}
