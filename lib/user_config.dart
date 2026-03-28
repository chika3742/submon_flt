import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "user_config.g.dart";
part "user_config.freezed.dart";

@Freezed(copyWith: true)
sealed class UserConfig with _$UserConfig {
  const factory UserConfig({
    int? schemaVersion,
    // ignore: invalid_annotation_target
    @JsonKey(includeFromJson: false, includeToJson: false) Timestamp? lastChanged,
    @TimeOfDayConverter() TimeOfDay? reminderNotificationTime,
    @TimeOfDayConverter() TimeOfDay? timetableNotificationTime,
    int? timetableNotificationId,
    int? digestiveNotificationTimeBefore,
    TimetableConfig? timetable,
    @Default([]) List<String> digestiveNotifications,
  }) = _UserConfig;

  static const pathTimetableShowSaturday = "timetable.showSaturday";
  static const pathTimetablePeriodCountToDisplay = "timetable.periodCountToDisplay";
  static const pathIsSEEnabled = "isSEEnabled";

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      _$UserConfigFromJson(json);
}

class TimeOfDayConverter extends JsonConverter<TimeOfDay?, String?> {
  const TimeOfDayConverter();

  @override
  TimeOfDay? fromJson(String? json) {
    final spilt = json?.split(":");
    return spilt != null
        ? TimeOfDay(
            hour: int.parse(spilt[0]),
            minute: int.parse(spilt[1]),
          )
        : null;
  }

  @override
  String? toJson(TimeOfDay? object) {
    return object != null ? "${object.hour}:${object.minute}" : null;
  }
}

@Freezed(copyWith: true)
sealed class TimetableConfig with _$TimetableConfig {
  const factory TimetableConfig({
    bool? showSaturday,
    int? periodCountToDisplay,
  }) = _TimetableConfig;

  factory TimetableConfig.fromJson(Map<String, dynamic> json) =>
      _$TimetableConfigFromJson(json);
}
