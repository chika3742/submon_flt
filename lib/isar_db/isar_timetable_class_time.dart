import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/isar_db/isar_provider.dart';

part '../generated/isar_db/isar_timetable_class_time.g.dart';

@Collection()
class TimetableClassTime {
  @Id()
  late int period;
  @TimeOfDayConverter()
  late TimeOfDay start;
  @TimeOfDayConverter()
  late TimeOfDay end;

  TimetableClassTime();

  TimetableClassTime.fromMap(Map<String, dynamic> map)
      : period = map["period"],
        start = const TimeOfDayConverter().fromIsar(map["start"]),
        end = const TimeOfDayConverter().fromIsar(map["end"]);

  Map<String, dynamic> toMap() {
    return {
      "period": period,
      "start": const TimeOfDayConverter().toIsar(start),
      "end": const TimeOfDayConverter().toIsar(end),
    };
  }

  TimetableClassTime.from({
    required this.period,
    required this.start,
    required this.end,
  });
}

class TimeOfDayConverter extends TypeConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromIsar(String object) {
    var split = object.split(":");
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }

  @override
  String toIsar(TimeOfDay object) {
    return "${object.hour}:${object.minute}";
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
