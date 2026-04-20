import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "timetable_class_time.freezed.dart";

typedef TimetableClassTimes = Map<int, TimetableClassTimePeriod>;

@freezed
sealed class TimetableClassTimePeriod with _$TimetableClassTimePeriod {
  const factory TimetableClassTimePeriod({
    required int period,
    required TimeOfDay start,
    required TimeOfDay end,
  }) = _TimetableClassTimePeriod;
}
