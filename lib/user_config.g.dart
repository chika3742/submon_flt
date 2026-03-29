// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserConfig _$UserConfigFromJson(Map<String, dynamic> json) => _UserConfig(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt(),
      reminderNotificationTime: const TimeOfDayConverter()
          .fromJson(json['reminderNotificationTime'] as String?),
      timetableNotificationTime: const TimeOfDayConverter()
          .fromJson(json['timetableNotificationTime'] as String?),
      timetableNotificationId:
          (json['timetableNotificationId'] as num?)?.toInt(),
      digestiveNotificationTimeBefore:
          (json['digestiveNotificationTimeBefore'] as num?)?.toInt(),
      timetable: json['timetable'] == null
          ? null
          : TimetableConfig.fromJson(json['timetable'] as Map<String, dynamic>),
      digestiveNotifications: (json['digestiveNotifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserConfigToJson(_UserConfig instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'reminderNotificationTime':
          const TimeOfDayConverter().toJson(instance.reminderNotificationTime),
      'timetableNotificationTime':
          const TimeOfDayConverter().toJson(instance.timetableNotificationTime),
      'timetableNotificationId': instance.timetableNotificationId,
      'digestiveNotificationTimeBefore':
          instance.digestiveNotificationTimeBefore,
      'timetable': instance.timetable,
      'digestiveNotifications': instance.digestiveNotifications,
    };

_TimetableConfig _$TimetableConfigFromJson(Map<String, dynamic> json) =>
    _TimetableConfig(
      showSaturday: json['showSaturday'] as bool?,
      periodCountToDisplay: (json['periodCountToDisplay'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TimetableConfigToJson(_TimetableConfig instance) =>
    <String, dynamic>{
      'showSaturday': instance.showSaturday,
      'periodCountToDisplay': instance.periodCountToDisplay,
    };
