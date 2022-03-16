import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/dotime.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/db/timetable_custom_subject.dart';
import 'package:submon/db/timetable_table.dart';
import 'package:submon/events.dart';
import 'package:submon/utils/firestore.dart';

class FirestoreProvider {
  FirestoreProvider(this.collectionId);

  final String collectionId;

  static FirestoreProvider get submission => FirestoreProvider("submission");

  static FirestoreProvider get doTime => FirestoreProvider("doTime");

  static FirestoreProvider get timetable => FirestoreProvider("timetable");

  static FirestoreProvider get timetableCustomSubject =>
      FirestoreProvider("timetableCustomSubject");

  Future<void> set(String docId, dynamic data, [SetOptions? setOptions]) async {
    await userDoc?.collection(collectionId).doc(docId).set(data, setOptions);
    await updateTimestamp();
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

  static Future<void> addDoTimeNotification(DocumentReference? ref) async {
    if (userDoc != null && ref != null) {
      await userDoc!.set({
        "doTimeNotifications": FieldValue.arrayUnion([ref])
      }, SetOptions(merge: true));
    }
  }

  static Future<void> removeDoTimeNotification(DocumentReference? ref) async {
    if (userDoc != null && ref != null) {
      await userDoc!.set({
        "doTimeNotifications": FieldValue.arrayRemove([ref])
      }, SetOptions(merge: true));
    }
  }

  static Future<void> setDoTimeNotificationTimeBefore(int value) async {
    if (userDoc != null) {
      await userDoc!.set(
          {"doTimeNotificationTimeBefore": value}, SetOptions(merge: true));
    }
  }

  static Future<ConfigData?> get config async {
    if (userDoc != null) {
      return ConfigData.fromMap(
          (await userDoc!.get()).data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<void> checkMigration() async {
    if (userDoc == null) return;
    var snapshot = await userDoc!.get();

    if (snapshot.data() == null) {
      await userDoc?.set({"schemaVersion": schemaVer}, SetOptions(merge: true));
    } else {
      var schemaVersion = (snapshot.data() as dynamic)["schemaVersion"];
    }
  }

  static Future<bool> fetchData({bool force = false}) async {
    await FirestoreProvider.checkMigration();

    var changed = !force ? await FirestoreProvider.checkTimestamp() : true;

    if (changed == true) {
      final submissionSnapshot = await userDoc!.collection("submission").get();
      final doTimeSnapshot = await userDoc!.collection("doTime").get();
      final timetableDataSnapshot =
          await userDoc!.collection("timetable").get();
      final timetableCustomSubjectsSnapshot =
          await userDoc!.collection("timetableCustomSubject").get();
      final configData = await config;

      await SubmissionProvider().use((provider) async {
        await provider.setAllLocalOnly(
            submissionSnapshot.docs.map((e) => e.data()).toList());
        eventBus.fire(SubmissionFetched());
      });

      await DoTimeProvider().use((provider) async {
        await provider
            .setAllLocalOnly(doTimeSnapshot.docs.map((e) => e.data()).toList());
      });

      var timetableTables = timetableDataSnapshot.docs
          .where((e) => e.id != "main")
          .map((e) => {
                "id": int.parse(e.id),
                "title": e.data()["title"],
              })
          .toList();

      await TimetableTableProvider().use((provider) async {
        await provider.setAllLocalOnly(timetableTables);
      });

      await TimetableProvider().use((provider) async {
        await provider.deleteAllLocalOnly();
        for (var e in timetableDataSnapshot.docs) {
          for (var value in ((e.data()["cells"] as Map?) ?? {}).values) {
            await provider.insertLocalOnly(provider.mapToObj(value));
          }
        }
      });

      await TimetableCustomSubjectProvider().use((provider) async {
        await provider.setAllLocalOnly(
            timetableCustomSubjectsSnapshot.docs.map((e) => e.data()).toList());
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
  ConfigData(
      {this.lastChanged,
      this.schemaVersion,
      this.reminderNotificationTime,
      this.timetableNotification,
      this.doTimeNotificationTimeBefore});

  Timestamp? lastChanged;
  int? schemaVersion;
  TimeOfDay? reminderNotificationTime;
  TimetableNotification? timetableNotification;
  int? doTimeNotificationTimeBefore;

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
      doTimeNotificationTimeBefore: map["doTimeNotificationTimeBefore"],
    );
  }
}

class TimetableNotification {
  TimetableNotification({this.time, this.id});

  TimeOfDay? time;
  int? id;
}