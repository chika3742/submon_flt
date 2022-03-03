import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      await userDoc!.firestore.runTransaction((transaction) async {
        var data = (await transaction.get(userDoc!)).data() as dynamic;
        if (data == null ||
            data["notificationTokens"] == null ||
            !(data["notificationTokens"] as List).contains(token)) {
          await userDoc!.set({
            "notificationTokens": FieldValue.arrayUnion([token])
          }, SetOptions(merge: true));
        }
      });
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

  static Future<TimeOfDay?> fetchReminderNotificationTime() async {
    if (userDoc != null) {
      var timeString = ((await userDoc!.get()).data()
          as dynamic)["reminderNotificationTime"] as String?;
      if (timeString != null) {
        var split = timeString.split(":");
        return TimeOfDay(
            hour: int.parse(split[0]), minute: int.parse(split[1]));
      }
    }
    return null;
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
      final timetableDataSnapshot =
          await userDoc!.collection("timetable").get();
      final timetableCustomSubjectsSnapshot =
          await userDoc!.collection("timetableCustomSubject").get();
      final configSnapshot = await userDoc!.get();

      await SubmissionProvider().use((provider) async {
        await provider.setAllLocalOnly(
            submissionSnapshot.docs.map((e) => e.data()).toList());
        eventBus.fire(SubmissionFetched());
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

      if (configSnapshot.exists) {
        var configData =
            ConfigData.fromMap(configSnapshot.data() as Map<String, dynamic>);
        if (configData.lastChanged != null) {
          SharedPrefs.use((prefs) {
            prefs.firestoreLastChanged = configData.lastChanged!.toDate();
          });
        }
      }
    }

    return changed == true;
  }
}

class ConfigData {
  ConfigData({this.lastChanged, this.schemaVersion});

  Timestamp? lastChanged;
  int? schemaVersion;

  static ConfigData fromMap(Map<String, dynamic> map) {
    return ConfigData(
        lastChanged: map["lastChanged"], schemaVersion: map["schemaVersion"]);
  }
}