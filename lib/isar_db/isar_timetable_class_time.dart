import "package:flutter/material.dart";
import "package:isar_community/isar.dart";

part "isar_timetable_class_time.g.dart";

@Collection()
class TimetableClassTime {
  late Id period;
  late String start;
  late String end;

  TimetableClassTime();

  TimetableClassTime.fromStartEnd(TimeOfDay start, TimeOfDay end) {
    startTime = start;
    endTime = end;
  }

  @ignore
  TimeOfDay get startTime {
    return parseTime(start);
  }
  set startTime(TimeOfDay time) {
    start = "${time.hour}:${time.minute}";
  }

  @ignore
  TimeOfDay get endTime {
    return parseTime(end);
  }
  set endTime(TimeOfDay time) {
    end = "${time.hour}:${time.minute}";
  }

  TimeOfDay parseTime(String time) {
    final split = time.split(":");
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
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
    startTime = start;
    endTime = end;
  }
}
