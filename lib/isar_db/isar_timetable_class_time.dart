import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/isar_db/isar_provider.dart';
import 'package:submon/utils/utils.dart';

part '../generated/isar_db/isar_timetable_class_time.g.dart';

@Collection()
class TimetableClassTime {
  late Id period;
  late String start;
  late String end;

  TimetableClassTime();

  @ignore
  TimeOfDay get startTime {
    var split = start.split(":");
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }

  @ignore
  TimeOfDay get endTime {
    var split = end.split(":");
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }

  TimetableClassTime.fromStartEnd(TimeOfDay start, TimeOfDay end) {
    this.start = start.toSimpleString();
    this.end = end.toSimpleString();
  }

  TimetableClassTime.fromMap(Map<String, dynamic> map)
      : period = map["period"],
        start = map["start"],
        end = map["end"];

  Map<String, dynamic> toMap() {
    return {
      "period": period,
      "start": start,
      "end": end,
    };
  }

  TimetableClassTime.from({
    required this.period,
    required TimeOfDay start,
    required TimeOfDay end,
  }) {
    this.start = start.toSimpleString();
    this.end = end.toSimpleString();
  }
}

class TimetableClassTimeProvider extends IsarProvider<TimetableClassTime> {
  @override
  Future<void> deleteFirestore(int id) {
    return FirestoreProvider.timetableClassTime.delete(id.toString());
  }

  @override
  Future<void> setFirestore(TimetableClassTime data, int id) {
    return FirestoreProvider.timetableClassTime
        .set(data.period.toString(), data.toMap());
  }

  @override
  Future<void> use(
      Future<void> Function(TimetableClassTimeProvider provider)
          callback) async {
    await open();
    await callback(this);
  }
}
