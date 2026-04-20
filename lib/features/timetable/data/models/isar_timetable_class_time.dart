import "package:flutter/material.dart";
import "package:isar_community/isar.dart";
import "package:isar_mapper_annotation/isar_mapper_annotation.dart";

import "../../domain/models/timetable_class_time.dart";

part "isar_timetable_class_time.g.dart";

@Collection()
@Name("TimetableClassTime")
@IsarMap(domain: TimetableClassTimePeriod)
class IsarTimetableClassTime {
  late Id period;
  @ConvertDomainField<_TimeOfDayConverter>()
  late String start;
  @ConvertDomainField<_TimeOfDayConverter>()
  late String end;

  IsarTimetableClassTime();
}

class _TimeOfDayConverter extends DomainFieldConverter<TimeOfDay, String> {
  const _TimeOfDayConverter();

  @override
  String fromDomain(TimeOfDay value) {
    return "${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}";
  }

  @override
  TimeOfDay toDomain(String value) {
    final parts = value.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
