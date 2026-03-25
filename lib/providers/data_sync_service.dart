import "package:cloud_firestore/cloud_firestore.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../core/pref_key.dart";
import "../isar_db/isar_digestive.dart";
import "../isar_db/isar_submission.dart";
import "../isar_db/isar_timetable.dart";
import "../isar_db/isar_timetable_class_time.dart";
import "../isar_db/isar_timetable_table.dart";
import "../user_config.dart";
import "../utils/batch_operation.dart";
import "core_providers.dart";
import "firestore_providers.dart";

part "data_sync_service.g.dart";

/// Firestore → Isar のデータ同期を行うサービス。Stateは同期状態を表す。
///
/// 旧 `FirestoreProvider.fetchData` / `checkMigration` / `_migrate` を置き換える。
@riverpod
class DataSyncService extends _$DataSyncService {
  @override
  Future<void> build() async {}

  /// Firestore からデータを取得し、ローカル (Isar) を全件更新する。
  Future<void> fetchData({bool force = false}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _doFetchData(force: force));
  }

  Future<void> _doFetchData({required bool force}) async {
    if (ref.read(userDocProvider) == null) return;

    var shouldUpdate = await _runMigrationIfNeeded();

    final config = await ref.read(firestoreUserConfigProvider.future);
    final localTimestamp = ref.readPref(PrefKey.firestoreLastChanged);
    if (!shouldUpdate) {
      shouldUpdate = force || hasRemoteChanges(config, localTimestamp);
    }

    if (shouldUpdate) {
      final submissionFs =
          ref.read(firestoreCollectionProvider("submission").notifier);
      final digestiveFs =
          ref.read(firestoreCollectionProvider("digestive").notifier);
      final timetableFs =
          ref.read(firestoreCollectionProvider("timetable").notifier);
      final timetableClassTimeFs =
          ref.read(firestoreCollectionProvider("timetableClassTime").notifier);

      final results = await Future.wait([
        submissionFs.get(),
        digestiveFs.get(),
        timetableFs.get(),
        timetableClassTimeFs.get(),
      ]);

      final submissionSnapshot = results[0];
      final digestiveSnapshot = results[1];
      final timetableSnapshot = results[2];
      final timetableClassTimeSnapshot = results[3];

      final submissions = submissionSnapshot.docs
          .map((e) => Submission.fromMap(e.data()))
          .toList();
      final digestives = digestiveSnapshot.docs
          .map((e) => Digestive.fromMap(e.data()))
          .toList();
      final timetableTables = timetableSnapshot.docs
          .where((e) => e.id != "-1")
          .map((e) => TimetableTable.fromMap({
                "id": int.parse(e.id),
                "title": e.data()["title"],
              }))
          .toList();
      final timetables = <Timetable>[];
      for (final doc in timetableSnapshot.docs) {
        final cells = (doc.data()["cells"] as Map<String, dynamic>?) ?? {};
        timetables.addAll(cells.values.map((v) => Timetable.fromMap(v)));
      }
      final classTimes = timetableClassTimeSnapshot.docs
          .map((e) => TimetableClassTime.fromMap(e.data()))
          .toList();

      final isar = ref.read(isarProvider).requireValue;
      await isar.writeTxn(() async {
        await isar.clear();
        await isar.submissions.putAll(submissions);
        await isar.digestives.putAll(digestives);
        await isar.timetableTables.putAll(timetableTables);
        await isar.timetables.putAll(timetables);
        await isar.timetableClassTimes.putAll(classTimes);
      });

      if (config?.lastChanged != null) {
        ref.updatePref(
          PrefKey.firestoreLastChanged,
          config!.lastChanged!.toDate().microsecondsSinceEpoch,
        );
      } else {
        await ref.read(firestoreUserConfigProvider.notifier).updateTimestamp();
      }
    }

    final timetableConfig = config?.timetable;
    if (timetableConfig?.showSaturday != null) {
      ref.updatePref(
        PrefKey.timetableShowSaturday,
        timetableConfig!.showSaturday!,
      );
    }
    if (timetableConfig?.periodCountToDisplay != null) {
      ref.updatePref(
        PrefKey.timetablePeriodCountToDisplay,
        timetableConfig!.periodCountToDisplay!,
      );
    }
  }

  /// マイグレーションが必要か確認し、必要なら実行する。
  ///
  /// マイグレーションが実行された場合は `true` を返す。
  /// `true` の場合、Firestore 上のデータ構造が変わっているため
  /// ローカルの全件再インポートが必要。
  Future<bool> _runMigrationIfNeeded() async {
    final userDoc = ref.read(userDocProvider);
    if (userDoc == null) return false;

    final snapshot = await userDoc.get();
    final serverSchemaVersion =
        (snapshot.data() as dynamic)?["schemaVersion"] as int?;

    if (serverSchemaVersion == null) {
      await userDoc
          .set({"schemaVersion": schemaVersion}, SetOptions(merge: true));
      return false;
    }

    if (serverSchemaVersion < schemaVersion) {
      await _migrate(serverSchemaVersion, snapshot.data()!, userDoc);
      await userDoc
          .set({"schemaVersion": schemaVersion}, SetOptions(merge: true));
      return true;
    }

    if (serverSchemaVersion > schemaVersion) {
      throw SchemaVersionMismatchException(
        serverSchemaVersion,
        schemaVersion,
      );
    }

    return false;
  }

  Future<void> _migrate(
    int oldVersion,
    Map<String, dynamic> userConfigData,
    DocumentReference<Map<String, dynamic>> userDoc,
  ) async {
    if (oldVersion == 4) {
      final operations = <BatchOperation>[];

      if (userConfigData["timetableNotificationId"] == null) {
        operations.add(BatchOperation.set(
          doc: userDoc,
          data: {"timetableNotificationId": -1},
          setOptions: SetOptions(merge: true),
        ));
      }

      final submissions = await ref
          .read(firestoreCollectionProvider("submission").notifier)
          .get();
      for (final item in submissions.docs) {
        final data = item.data();
        data["details"] = data["detail"];
        data["due"] = data["date"];
        data["done"] = data["done"] == 1;
        data["important"] = data["important"] == 1;
        data.remove("detail");
        data.remove("date");
        operations.add(BatchOperation.set(
          doc: userDoc.collection("submission").doc(item.id),
          data: data,
        ));
      }

      final digestives = await ref
          .read(firestoreCollectionProvider("digestive").notifier)
          .get();
      for (final item in digestives.docs) {
        operations.add(BatchOperation.set(
          doc: item.reference,
          data: {"done": item.data()["done"] == 1},
          setOptions: SetOptions(merge: true),
        ));
      }

      final mainTimetable = await ref
          .read(firestoreCollectionProvider("timetable").notifier)
          .getDoc("main");
      if (mainTimetable.exists) {
        final data = mainTimetable.data()!;
        if (data["cells"] != null) {
          data["cells"] = (data["cells"] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value..["tableId"] = -1));
        }
        operations.add(BatchOperation.set(
          doc: userDoc.collection("timetable").doc("-1"),
          data: data,
        ));
        operations.add(BatchOperation.delete(
          doc: userDoc.collection("timetable").doc("main"),
        ));
      }

      final timetableClassTimes = await ref
          .read(firestoreCollectionProvider("timetableClassTime").notifier)
          .get();
      for (final item in timetableClassTimes.docs) {
        final data = item.data();
        data["period"] = data["id"];
        data.remove("id");
        operations.add(BatchOperation.set(
          doc: userDoc.collection("timetableClassTime").doc(item.id),
          data: data,
        ));
      }

      await BatchOperation.commit(operations);
      oldVersion++;
    }

    if (oldVersion == 5) {
      await userDoc.update({
        UserConfig.pathTimetableShowSaturday:
            ref.readPref(PrefKey.timetableShowSaturday),
        UserConfig.pathTimetablePeriodCountToDisplay:
            ref.readPref(PrefKey.timetablePeriodCountToDisplay),
      });
      oldVersion++;
    }

    if (oldVersion == 6) {
      oldVersion++;
    }
  }
}

class SchemaVersionMismatchException implements Exception {
  SchemaVersionMismatchException(this.serverVersion, this.expectedVersion);

  final int serverVersion;
  final int expectedVersion;

  @override
  String toString() =>
      "Current schema version $expectedVersion is lower than "
      "server side version $serverVersion.";
}
