import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/sql_provider.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/events.dart';
import 'package:submon/utils/firestore.dart';

class FirestoreProvider {
  FirestoreProvider(this.collectionId);

  final String collectionId;

  static FirestoreProvider get submission => FirestoreProvider("submission");

  static FirestoreProvider get timetable => FirestoreProvider("timetable");

  Future<void> set(String docId, dynamic data, [SetOptions? setOptions]) async {
    await userDoc!.collection(collectionId).doc(docId).set(data, setOptions);
    await updateTimestamp();
  }

  Future<void> delete(String docId) async {
    await userDoc!.collection(collectionId).doc(docId).delete();
    await updateTimestamp();
  }

  static Future<void> updateTimestamp() async {
    final timestamp = Timestamp.now();
    SharedPrefs.use((prefs) {
      prefs.firestoreLastChanged = timestamp.toDate();
    });
    await userDoc?.set({"lastChanged": timestamp}, SetOptions(merge: true));
  }

  static Future<bool?> checkTimestamp() async {
    final data = (await userDoc!.get()).data() as dynamic;
    if (data != null && data["lastChanged"] != null) {
      var prefs = SharedPrefs(await SharedPreferences.getInstance());
      print(
          "${(data["lastChanged"] as Timestamp).toDate()} vs ${prefs.firestoreLastChanged}");
      return (data["lastChanged"] as Timestamp)
              .toDate()
              .compareTo(prefs.firestoreLastChanged) >
          0;
    } else {
      return null;
    }
  }

  static Future<void> checkMigration() async {
    if (userDoc == null) return;
    var snapshot = await userDoc!.get();

    if (snapshot.data() == null) {
      await userDoc!.set({"schemaVersion": schemaVer}, SetOptions(merge: true));
    } else {
      var schemaVersion = (snapshot.data() as dynamic)["schemaVersion"];
      print(schemaVersion);
    }
  }

  static Future<bool> fetchData() async {
    await FirestoreProvider.checkMigration();

    var changed = await FirestoreProvider.checkTimestamp();

    if (changed == true) {
      final submissionSnapshot = await userDoc!.collection("submission").get();
      final timetableDataSnapshot =
          await userDoc!.collection("timetable").doc("data").get();
      final configSnapshot = await userDoc!.get();

      await SubmissionProvider().use((provider) async {
        await provider.setAllLocalOnly(
            submissionSnapshot.docs.map((e) => e.data()).toList());
        eventBus.fire(SubmissionFetched());
      });

      if (timetableDataSnapshot.exists) {
        await TimetableProvider().use((provider) async {
          await provider.setAllLocalOnly(timetableDataSnapshot
              .data()!
              .values
              .map((e) => Map.castFrom<dynamic, dynamic, String, dynamic>(e))
              .toList());
        });
      }

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