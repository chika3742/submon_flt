import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/isar_db/isar_digestive.dart';
import 'package:submon/isar_db/isar_provider.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/isar_db/isar_timetable.dart';
import 'package:submon/isar_db/isar_timetable_class_time.dart';
import 'package:submon/isar_db/isar_timetable_table.dart';
import 'package:submon/main.dart';
import 'package:submon/src/pigeons.g.dart';
import 'package:submon/utils/batch_operation.dart';
import 'package:submon/utils/firestore.dart';
import 'package:submon/utils/ui.dart';

import '../user_config.dart';

class FirestoreProvider {
  FirestoreProvider(this.collectionId);

  final String collectionId;

  static FirestoreProvider get submission => FirestoreProvider("submission");

  static FirestoreProvider get digestive => FirestoreProvider("digestive");

  static FirestoreProvider get timetable => FirestoreProvider("timetable");

  static FirestoreProvider get timetableClassTime =>
      FirestoreProvider("timetableClassTime");

  static FirestoreProvider get memorizeCard =>
      FirestoreProvider("memorizeCard");

  Future<void> set(String docId, dynamic data, [SetOptions? setOptions]) async {
    await userDoc?.collection(collectionId).doc(docId).set(data, setOptions);
    await updateTimestamp();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> get() async {
    assert(userDoc != null);
    return await userDoc!.collection(collectionId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(String id) async {
    assert(userDoc != null);
    return await userDoc!.collection(collectionId).doc(id).get();
  }

  Future<bool?> exists(String docId) async {
    return (await userDoc?.collection(collectionId).doc(docId).get())?.exists;
  }

  Future<void> delete(String docId) async {
    await userDoc?.collection(collectionId).doc(docId).delete();
    await updateTimestamp();
  }

  static Future<void> updateTimestamp() async {
    final timestamp = Timestamp.now();
    SharedPrefs.use((prefs) {
      prefs.firestoreLastChanged = timestamp.toDate();
    });
    await userDoc?.set({"lastChanged": timestamp}, SetOptions(merge: true));
  }

  static Future<CheckTimestampResult> checkTimestamp() async {
    final data = (await userDoc!.withConverter<UserConfig>(
      fromFirestore: UserConfig.fromFirestore,
      toFirestore: (userConfig, options) => userConfig.toFirestore(),
    ).get()).data();
    if (data != null && data.lastChanged != null) {
      var prefs = SharedPrefs(await SharedPreferences.getInstance());
      return CheckTimestampResult(
        changed: data.lastChanged!
            .toDate()
            .compareTo(prefs.firestoreLastChanged) > 0,
        configData: data,
      );
    } else {
      return CheckTimestampResult(
        changed: true,
        configData: data,
      );
    }
  }

  static Future<void> saveNotificationToken(String? token) async {
    if (userDoc != null && token != null) {
      await userDoc!.set({
        "notificationTokens": FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));
    }
  }

  static Future<void> removeNotificationToken() async {
    var token = await MessagingApi().getToken();
    if (userDoc != null && token != null) {
      await userDoc!.set({
        "notificationTokens": FieldValue.arrayRemove([token])
      }, SetOptions(merge: true));
    }
  }

  /// If [time] is null, unregisters.
  static Future<void> setReminderNotificationTime(TimeOfDay? time) async {
    if (userDoc != null) {
      String? timeString;
      if (time != null) {
        timeString = "${time.hour}:${time.minute}";
      }
      await userDoc!.set(
          {"reminderNotificationTime": timeString}, SetOptions(merge: true));
    }
  }

  static Future<void> setTimetableNotificationTime(TimeOfDay? time) async {
    if (userDoc != null) {
      await userDoc!.set({
        "timetableNotificationTime": time != null ? "${time.hour}:${time.minute}" : null,
      }, SetOptions(merge: true));
    }
  }

  static Future<void> setTimetableNotificationId(int id) async {
    if (userDoc != null) {
      await userDoc!.set({
        "timetableNotificationId": id,
      }, SetOptions(merge: true));
    }
  }

  static Future<void> addDigestiveNotification(int? id) async {
    if (userDoc != null && id != null) {
      await userDoc!.set({
        "digestiveNotifications": FieldValue.arrayUnion(
            [userDoc!.collection("digestive").doc(id.toString())])
      }, SetOptions(merge: true));
    }
  }

  static Future<void> removeDigestiveNotification(int? id) async {
    if (userDoc != null && id != null) {
      await userDoc!.set({
        "digestiveNotifications": FieldValue.arrayRemove(
            [userDoc!.collection("digestive").doc(id.toString())])
      }, SetOptions(merge: true));
    }
  }

  static Future<void> setDigestiveNotificationTimeBefore(int value) async {
    if (userDoc != null) {
      await userDoc!.set(
          {"digestiveNotificationTimeBefore": value}, SetOptions(merge: true));
    }
  }

  static Future<void> disconnectCanvasLms() async {
    await FirebaseFunctions.instanceFor(region: "asia-northeast1")
        .httpsCallable("disconnectCanvas")();
  }

  static Future<void> clearCanvasLmsSyncExcludeList() async {
    await userDoc?.set({
      "lms": {
        "canvas": {
          "excludedPlannableIds": [],
        },
      },
    }, SetOptions(merge: true));
  }

  static Future<void> setCanvasLmsSubmissionColor(Color color) async {
    await userDoc?.set({
      "lms": {
        "canvas": {
          "submissionColor": color.value,
        },
      },
    }, SetOptions(merge: true));
  }

  static Future<void> updateUserConfig(String field, dynamic data) async {
    await userDoc?.update({
      field: data,
    });
  }

  static Future<UserConfig?> get config async {
    if (userDoc != null) {
      return (await userDoc!
          .withConverter<UserConfig>(fromFirestore: UserConfig.fromFirestore,
          toFirestore: (config, options) => config.toFirestore()).get()).data();
    } else {
      return null;
    }
  }

  static Future<void> initializeUser() async {
    await FirebaseFunctions.instanceFor(region: "asia-northeast1")
        .httpsCallable("createUser")
        .call();
    await userDoc!.set({"schemaVersion": schemaVersion});
  }

  static Future<bool> checkMigration() async {
    if (userDoc == null) return false;
    var snapshot = await userDoc!.get();

    var serverSchemaVersion = (snapshot.data() as dynamic)?["schemaVersion"];

    if (serverSchemaVersion == null) {
      await userDoc!
          .set({"schemaVersion": schemaVersion}, SetOptions(merge: true));
      return false;
    } else {
      if (serverSchemaVersion < schemaVersion) {
        showLoadingModal(globalContext!);

        // migrate (server side?)
        await _migrate(serverSchemaVersion, snapshot.data() as dynamic);

        await userDoc!
            .set({"schemaVersion": schemaVersion}, SetOptions(merge: true));

        Navigator.of(globalContext!, rootNavigator: true).pop();

        return true;
      } else if (serverSchemaVersion > schemaVersion) {
        throw SchemaVersionMismatchException(
            serverSchemaVersion, schemaVersion);
      }
      return false;
    }
  }

  static Future<void> _migrate(int oldVersion, Map<String, dynamic> userConfig) async {
    if (oldVersion == 4) {
      var operations = <BatchOperation>[];

      if (userConfig["timetableNotificationId"] == null) {
        operations.add(BatchOperation.set(doc: userDoc!, data: {
          "timetableNotificationId": -1
        }, setOptions: SetOptions(merge: true)));
      }

      var submissions = await submission.get();
      for (var item in submissions.docs) {
        var data = item.data();
        data["details"] = data["detail"];
        data["due"] = data["date"];
        data["done"] = data["done"] == 1;
        data["important"] = data["important"] == 1;
        data.remove("detail");
        data.remove("date");
        operations.add(BatchOperation.set(
          doc: userDoc!.collection("submission").doc(item.id),
          data: data,
        ));
      }

      var digestives = await digestive.get();
      for (var item in digestives.docs) {
        operations.add(BatchOperation.set(
          doc: item.reference,
          data: {
            "done": item.data()["done"] == 1,
          },
          setOptions: SetOptions(merge: true),
        ));
      }

      var mainTimetable = await timetable.getDoc("main");
      if (mainTimetable.exists) {
        var data = mainTimetable.data()!;
        if (data["cells"] != null) {
          data["cells"] = (data["cells"] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value..["tableId"] = -1));
        }
        operations.add(BatchOperation.set(
          doc: userDoc!.collection("timetable").doc("-1"),
          data: data,
        ));
        operations.add(BatchOperation.delete(
          doc: userDoc!.collection("timetable").doc("main"),
        ));
      }

      var timetableClassTimes = await timetableClassTime.get();
      for (var item in timetableClassTimes.docs) {
        var data = item.data();
        data["period"] = data["id"];
        data.remove("id");

        operations.add(BatchOperation.set(
            doc: userDoc!.collection("timetableClassTime").doc(item.id),
            data: data));
      }

      await BatchOperation.commit(operations);

      oldVersion++;
    }
    if (oldVersion == 5) {
      var sp = SharedPrefs(await SharedPreferences.getInstance());
      await userDoc!.update({
        UserConfig.pathIsSEEnabled: sp.isSEEnabled,
        UserConfig.pathTimetableShowSaturday: sp.timetableShowSaturday,
        UserConfig.pathTimetablePeriodCountToDisplay: sp.timetablePeriodCountToDisplay,
      });
      oldVersion++;
    }
    if (oldVersion == 6) {
      // do nothing
      oldVersion++;
    }
  }

  static void setLastAppOpenedToCurrentTime() {
    userDoc?.set({"lastAppOpened": FieldValue.serverTimestamp()},
        SetOptions(merge: true));
  }

  ///
  /// if value is changed, true will be returned.
  ///
  static Future<bool> fetchData({bool force = false}) async {
    var shouldUpdateLocalData = await FirestoreProvider.checkMigration();

    var checkTimestampResult = await FirestoreProvider.checkTimestamp();
    if (shouldUpdateLocalData == false) {
      shouldUpdateLocalData = !force ? checkTimestampResult.changed : true;
    }

    setLastAppOpenedToCurrentTime();

    if (shouldUpdateLocalData == true) {
      final submissionSnapshot = await submission.get();
      final digestiveSnapshot = await digestive.get();
      final timetableSnapshot = await timetable.get();
      final timetableClassTimeDataSnapshot = await timetableClassTime.get();

      await SubmissionProvider().use((provider) async {
        await provider.writeTransaction(() async {
          await provider.isar.clear();

          await provider.putAllLocalOnly(submissionSnapshot.docs
              .map((e) => Submission.fromMap(e.data()))
              .toList());
        });
      });

      await DigestiveProvider().use((provider) async {
        await provider.writeTransaction(() async {
          await provider.putAllLocalOnly(digestiveSnapshot.docs
              .map((e) => Digestive.fromMap(e.data()))
              .toList());
        });
      });

      var timetableTables = timetableSnapshot.docs
          .where((e) => e.id != "-1")
          .map((e) => TimetableTable.fromMap({
                "id": int.parse(e.id),
                "title": e.data()["title"],
              }))
          .toList();

      await TimetableTableProvider().use((provider) async {
        await provider.writeTransaction(() async {
          await provider.putAllLocalOnly(timetableTables);
        });
      });

      await TimetableProvider().use((provider) async {
        await provider.writeTransaction(() async {
          for (var e in timetableSnapshot.docs) {
            var list = ((e.data()["cells"] as Map<String, dynamic>?) ?? {})
                .values
                .map((e) => Timetable.fromMap(e))
                .toList();
            await provider.putAllLocalOnly(list);
          }
        });
      });

      await TimetableClassTimeProvider().use((provider) async {
        await provider.writeTransaction(() async {
          await provider.putAllLocalOnly(timetableClassTimeDataSnapshot.docs
              .map((e) => TimetableClassTime.fromMap(e.data()))
              .toList());
        });
      });

      // await MemorizeCardFolderProvider().use((provider) async {
      //   await provider.setAllLocally(memorizeCardSnapshot.docs
      //       .map((e) => {
      //     "id": e.data()["id"],
      //     "title": e.data()["title"],
      //   })
      //       .toList());
      // });

      if (checkTimestampResult.configData?.lastChanged != null) {
        SharedPrefs.use((prefs) {
          prefs.firestoreLastChanged = checkTimestampResult.configData!.lastChanged!.toDate();
        });
      } else {
        await updateTimestamp();
      }
    }

    SharedPrefs.use((prefs) {
      var timetableConfig = checkTimestampResult.configData?.timetable;
      if (timetableConfig?.showSaturday != null) {
        prefs.timetableShowSaturday = timetableConfig!.showSaturday!;
      }
      if (timetableConfig?.periodCountToDisplay != null) {
        prefs.timetablePeriodCountToDisplay = timetableConfig!.periodCountToDisplay!;
      }
      if (checkTimestampResult.configData?.isSEEnabled != null) {
        prefs.isSEEnabled = checkTimestampResult.configData!.isSEEnabled!;
      }
    });

    return shouldUpdateLocalData == true;
  }
}

class CheckTimestampResult {
  bool changed;
  UserConfig? configData;

  CheckTimestampResult({required this.changed, required this.configData});
}

class SchemaVersionMismatchException {
  final int serverVersion;
  final int expectedVersion;

  SchemaVersionMismatchException(this.expectedVersion, this.serverVersion);

  @override
  String toString() =>
      "Current schema version $expectedVersion is lower than server side version $serverVersion.";
}
