import "package:cloud_firestore/cloud_firestore.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../core/pref_key.dart";
import "../user_config.dart";
import "../utils/batch_operation.dart";
import "core_providers.dart";

part "firestore_providers.g.dart";

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```
@riverpod
class FirestoreNotifier extends _$FirestoreNotifier {
  DocumentReference<Map<String, dynamic>>? _userDoc;
  late String _collectionId;

  @override
  void build(String collectionId) {
    _collectionId = collectionId;
    _userDoc = ref.watch(userDocProvider);
  }

  CollectionReference<Map<String, dynamic>>? get _collectionRef =>
      _userDoc?.collection(_collectionId);

  // --- CRUD ---

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
    await BatchOperation.commit(operations);
    await _updateTimestamp();
  }

  // --- Timestamp ---

  Future<void> _updateTimestamp() async {
    final timestamp = Timestamp.now();
    ref.updatePref(
      PrefKey.firestoreLastChanged,
      timestamp.toDate().microsecondsSinceEpoch,
    );
    await _userDoc?.set({"lastChanged": timestamp}, SetOptions(merge: true));
  }
}

/// Firestore 上のユーザー設定 (UserConfig) を取得する Provider。
@riverpod
Future<UserConfig?> userConfig(Ref ref) async {
  final doc = ref.watch(userDocProvider);
  if (doc == null) return null;
  return (await doc
          .withConverter<UserConfig>(
            fromFirestore: UserConfig.fromFirestore,
            toFirestore: (config, options) => config.toFirestore(),
          )
          .get())
      .data();
}

/// リモートに未同期の変更があるかを判定する。
///
/// [config] が null または lastChanged が未設定の場合は `true` を返す
/// (初回起動やデータ未作成)。
bool hasRemoteChanges(UserConfig? config, int localTimestampMicros) {
  if (config == null || config.lastChanged == null) return true;
  return config.lastChanged!.toDate().microsecondsSinceEpoch >
      localTimestampMicros;
}
