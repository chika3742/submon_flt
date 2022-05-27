import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/digestive.dart';
import 'package:submon/db/memorize_card_folder.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/db/timetable_class_time.dart';
import 'package:submon/db/timetable_table.dart';
import 'package:submon/events.dart';
import 'package:submon/utils/firestore.dart';

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

  static Future<bool> checkTimestamp() async {
    final data = (await userDoc!.get()).data() as dynamic;
    if (data != null && data["lastChanged"] != null) {
      var prefs = SharedPrefs(await SharedPreferences.getInstance());
      return (data["lastChanged"] as Timestamp)
              .toDate()
              .compareTo(prefs.firestoreLastChanged) >
          0;
    } else {
      return true;
    }
  }

  static Future<void> saveNotificationToken(String? token) async {
    if (userDoc != null && token != null) {
      userDoc!.set({
        "notificationTokens": FieldValue.arrayUnion([token])
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

  static Future<void> setTimetableNotification(
      TimetableNotification data) async {
    if (userDoc != null) {
      String? timeString;
      if (data.time != null) {
        timeString = "${data.time!.hour}:${data.time!.minute}";
      }
      await userDoc!.set({
        "timetableNotificationTime": timeString,
        "timetableNotificationId": data.id
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

  static Future<ConfigData?> get config async {
    if (userDoc != null) {
      var snapshot = await userDoc!.get();
      return ConfigData.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<void> initializeUser() async {
    await FirebaseFunctions.instanceFor(region: "asia-northeast1")
        .httpsCallable("createUser")
        .call();
    await userDoc!.set({"schemaVersion": schemaVer});
  }

  static Future<void> checkMigration() async {
    if (userDoc == null) return;
    var snapshot = await userDoc!.get();

    var schemaVersion = (snapshot.data() as dynamic)?["schemaVersion"];

    if (schemaVersion == null) {
      await userDoc!.set({"schemaVersion": schemaVer}, SetOptions(merge: true));
    } else {
      if (schemaVersion < schemaVer) {
        // migrate (server side?)
        await userDoc!
            .set({"schemaVersion": schemaVer}, SetOptions(merge: true));
      } else if (schemaVersion > schemaVer) {
        throw SchemaVersionMismatchException(schemaVer, schemaVersion);
      }
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
    await FirestoreProvider.checkMigration();

    setLastAppOpenedToCurrentTime();

    var changed = !force ? await FirestoreProvider.checkTimestamp() : true;

    if (changed == true) {
      final configData = await config;
      final submissionSnapshot = await submission.get();
      final digestiveSnapshot = await digestive.get();
      final timetableDataSnapshot = await timetable.get();
      final timetableClassTimeDataSnapshot = await timetableClassTime.get();
      final memorizeCardSnapshot = await memorizeCard.get();

      await SubmissionProvider().use((provider) async {
        await provider.setAllLocally(
            submissionSnapshot.docs.map((e) => e.data()).toList());
        eventBus.fire(SubmissionFetched());
      });

      await DigestiveProvider().use((provider) async {
        await provider.setAllLocally(
            digestiveSnapshot.docs.map((e) => e.data()).toList());
      });

      var timetableTables = timetableDataSnapshot.docs
          .where((e) => e.id != "main")
          .map((e) => {
        "id": int.parse(e.id),
        "title": e.data()["title"],
      })
          .toList();

      await TimetableTableProvider().use((provider) async {
        await provider.setAllLocally(timetableTables);
      });

      await TimetableProvider().use((provider) async {
        await provider.deleteAllLocal();
        for (var e in timetableDataSnapshot.docs) {
          for (var value
              in ((e.data()["cells"] as Map<String, dynamic>?) ?? {}).values) {
            await provider.insertLocalOnly(provider.mapToObj(value));
          }
        }
      });

      await TimetableClassTimeProvider().use((provider) async {
        await provider.setAllLocally(
            timetableClassTimeDataSnapshot.docs.map((e) => e.data()).toList());
      });

      await MemorizeCardFolderProvider().use((provider) async {
        await provider.setAllLocally(memorizeCardSnapshot.docs
            .map((e) => {
                  "id": e.data()["id"],
                  "title": e.data()["title"],
                })
            .toList());
      });

      if (configData?.lastChanged != null) {
        SharedPrefs.use((prefs) {
          prefs.firestoreLastChanged = configData?.lastChanged!.toDate();
        });
      }
    }

    return changed == true;
  }
}

class ConfigData {
  ConfigData({
    this.lastChanged,
    this.schemaVersion,
    this.reminderNotificationTime,
    this.timetableNotification,
    this.digestiveNotificationTimeBefore,
    this.lms,
  });

  Timestamp? lastChanged;
  int? schemaVersion;
  TimeOfDay? reminderNotificationTime;
  TimetableNotification? timetableNotification;
  int? digestiveNotificationTimeBefore;
  Lms? lms;

  static ConfigData fromMap(Map<String, dynamic>? map) {
    if (map == null) return ConfigData();
    var reminderNotificationTimeSpilt =
        (map["reminderNotificationTime"] as String?)?.split(":");
    var timetableNotificationTimeSpilt =
        (map["timetableNotificationTime"] as String?)?.split(":");
    return ConfigData(
      lastChanged: map["lastChanged"],
      schemaVersion: map["schemaVersion"],
      reminderNotificationTime: reminderNotificationTimeSpilt != null
          ? TimeOfDay(
              hour: int.parse(reminderNotificationTimeSpilt[0]),
              minute: int.parse(reminderNotificationTimeSpilt[1]),
            )
          : null,
      timetableNotification: TimetableNotification(
        time: timetableNotificationTimeSpilt != null
            ? TimeOfDay(
                hour: int.parse(timetableNotificationTimeSpilt[0]),
                minute: int.parse(timetableNotificationTimeSpilt[1]),
              )
            : null,
        id: map["timetableNotificationId"],
      ),
      digestiveNotificationTimeBefore: map["digestiveNotificationTimeBefore"],
      lms: Lms.fromMap(map["lms"]),
    );
  }
}

class Lms {
  CanvasLms? canvas;

  Lms(Map<String, dynamic> map) : canvas = CanvasLms.fromMap(map["canvas"]);

  static fromMap(Map<String, dynamic>? map) {
    if (map != null) {
      return Lms(map);
    }
    return null;
  }
}

class CanvasLms {
  int universityId;
  Timestamp? lastSync;
  bool hasError;
  List<dynamic> excludedPlannableIds;
  int submissionColor;

  CanvasLms(Map<String, dynamic> map)
      : universityId = map["universityId"],
        lastSync = map["lastSync"],
        hasError = map["hasError"],
        excludedPlannableIds = map["excludedPlannableIds"],
        submissionColor = map["submissionColor"];

  static fromMap(Map<String, dynamic>? map) {
    if (map != null) {
      return CanvasLms(map);
    }
    return null;
  }
}

class TimetableNotification {
  TimetableNotification({this.time, this.id});

  TimeOfDay? time;
  int? id;
}

class SchemaVersionMismatchException {
  final int serverVersion;
  final int expectedVersion;

  SchemaVersionMismatchException(this.expectedVersion, this.serverVersion);

  @override
  String toString() =>
      "Current schema version $expectedVersion is lower than server side version $serverVersion.";
}
