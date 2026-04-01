// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserConfig {

 int? get schemaVersion;// ignore: invalid_annotation_target
@JsonKey(includeFromJson: false, includeToJson: false) Timestamp? get lastChanged;@TimeOfDayConverter() TimeOfDay? get reminderNotificationTime;@TimeOfDayConverter() TimeOfDay? get timetableNotificationTime; int? get timetableNotificationId; int? get digestiveNotificationTimeBefore; TimetableConfig? get timetable; List<String> get digestiveNotifications;
/// Create a copy of UserConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserConfigCopyWith<UserConfig> get copyWith => _$UserConfigCopyWithImpl<UserConfig>(this as UserConfig, _$identity);

  /// Serializes this UserConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserConfig&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.lastChanged, lastChanged) || other.lastChanged == lastChanged)&&(identical(other.reminderNotificationTime, reminderNotificationTime) || other.reminderNotificationTime == reminderNotificationTime)&&(identical(other.timetableNotificationTime, timetableNotificationTime) || other.timetableNotificationTime == timetableNotificationTime)&&(identical(other.timetableNotificationId, timetableNotificationId) || other.timetableNotificationId == timetableNotificationId)&&(identical(other.digestiveNotificationTimeBefore, digestiveNotificationTimeBefore) || other.digestiveNotificationTimeBefore == digestiveNotificationTimeBefore)&&(identical(other.timetable, timetable) || other.timetable == timetable)&&const DeepCollectionEquality().equals(other.digestiveNotifications, digestiveNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,lastChanged,reminderNotificationTime,timetableNotificationTime,timetableNotificationId,digestiveNotificationTimeBefore,timetable,const DeepCollectionEquality().hash(digestiveNotifications));

@override
String toString() {
  return 'UserConfig(schemaVersion: $schemaVersion, lastChanged: $lastChanged, reminderNotificationTime: $reminderNotificationTime, timetableNotificationTime: $timetableNotificationTime, timetableNotificationId: $timetableNotificationId, digestiveNotificationTimeBefore: $digestiveNotificationTimeBefore, timetable: $timetable, digestiveNotifications: $digestiveNotifications)';
}


}

/// @nodoc
abstract mixin class $UserConfigCopyWith<$Res>  {
  factory $UserConfigCopyWith(UserConfig value, $Res Function(UserConfig) _then) = _$UserConfigCopyWithImpl;
@useResult
$Res call({
 int? schemaVersion,@JsonKey(includeFromJson: false, includeToJson: false) Timestamp? lastChanged,@TimeOfDayConverter() TimeOfDay? reminderNotificationTime,@TimeOfDayConverter() TimeOfDay? timetableNotificationTime, int? timetableNotificationId, int? digestiveNotificationTimeBefore, TimetableConfig? timetable, List<String> digestiveNotifications
});


$TimetableConfigCopyWith<$Res>? get timetable;

}
/// @nodoc
class _$UserConfigCopyWithImpl<$Res>
    implements $UserConfigCopyWith<$Res> {
  _$UserConfigCopyWithImpl(this._self, this._then);

  final UserConfig _self;
  final $Res Function(UserConfig) _then;

/// Create a copy of UserConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = freezed,Object? lastChanged = freezed,Object? reminderNotificationTime = freezed,Object? timetableNotificationTime = freezed,Object? timetableNotificationId = freezed,Object? digestiveNotificationTimeBefore = freezed,Object? timetable = freezed,Object? digestiveNotifications = null,}) {
  return _then(_self.copyWith(
schemaVersion: freezed == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int?,lastChanged: freezed == lastChanged ? _self.lastChanged : lastChanged // ignore: cast_nullable_to_non_nullable
as Timestamp?,reminderNotificationTime: freezed == reminderNotificationTime ? _self.reminderNotificationTime : reminderNotificationTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,timetableNotificationTime: freezed == timetableNotificationTime ? _self.timetableNotificationTime : timetableNotificationTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,timetableNotificationId: freezed == timetableNotificationId ? _self.timetableNotificationId : timetableNotificationId // ignore: cast_nullable_to_non_nullable
as int?,digestiveNotificationTimeBefore: freezed == digestiveNotificationTimeBefore ? _self.digestiveNotificationTimeBefore : digestiveNotificationTimeBefore // ignore: cast_nullable_to_non_nullable
as int?,timetable: freezed == timetable ? _self.timetable : timetable // ignore: cast_nullable_to_non_nullable
as TimetableConfig?,digestiveNotifications: null == digestiveNotifications ? _self.digestiveNotifications : digestiveNotifications // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of UserConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableConfigCopyWith<$Res>? get timetable {
    if (_self.timetable == null) {
    return null;
  }

  return $TimetableConfigCopyWith<$Res>(_self.timetable!, (value) {
    return _then(_self.copyWith(timetable: value));
  });
}
}



/// @nodoc
@JsonSerializable()

class _UserConfig implements UserConfig {
  const _UserConfig({this.schemaVersion, @JsonKey(includeFromJson: false, includeToJson: false) this.lastChanged, @TimeOfDayConverter() this.reminderNotificationTime, @TimeOfDayConverter() this.timetableNotificationTime, this.timetableNotificationId, this.digestiveNotificationTimeBefore, this.timetable, final  List<String> digestiveNotifications = const []}): _digestiveNotifications = digestiveNotifications;
  factory _UserConfig.fromJson(Map<String, dynamic> json) => _$UserConfigFromJson(json);

@override final  int? schemaVersion;
// ignore: invalid_annotation_target
@override@JsonKey(includeFromJson: false, includeToJson: false) final  Timestamp? lastChanged;
@override@TimeOfDayConverter() final  TimeOfDay? reminderNotificationTime;
@override@TimeOfDayConverter() final  TimeOfDay? timetableNotificationTime;
@override final  int? timetableNotificationId;
@override final  int? digestiveNotificationTimeBefore;
@override final  TimetableConfig? timetable;
 final  List<String> _digestiveNotifications;
@override@JsonKey() List<String> get digestiveNotifications {
  if (_digestiveNotifications is EqualUnmodifiableListView) return _digestiveNotifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_digestiveNotifications);
}


/// Create a copy of UserConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserConfigCopyWith<_UserConfig> get copyWith => __$UserConfigCopyWithImpl<_UserConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserConfig&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.lastChanged, lastChanged) || other.lastChanged == lastChanged)&&(identical(other.reminderNotificationTime, reminderNotificationTime) || other.reminderNotificationTime == reminderNotificationTime)&&(identical(other.timetableNotificationTime, timetableNotificationTime) || other.timetableNotificationTime == timetableNotificationTime)&&(identical(other.timetableNotificationId, timetableNotificationId) || other.timetableNotificationId == timetableNotificationId)&&(identical(other.digestiveNotificationTimeBefore, digestiveNotificationTimeBefore) || other.digestiveNotificationTimeBefore == digestiveNotificationTimeBefore)&&(identical(other.timetable, timetable) || other.timetable == timetable)&&const DeepCollectionEquality().equals(other._digestiveNotifications, _digestiveNotifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,lastChanged,reminderNotificationTime,timetableNotificationTime,timetableNotificationId,digestiveNotificationTimeBefore,timetable,const DeepCollectionEquality().hash(_digestiveNotifications));

@override
String toString() {
  return 'UserConfig(schemaVersion: $schemaVersion, lastChanged: $lastChanged, reminderNotificationTime: $reminderNotificationTime, timetableNotificationTime: $timetableNotificationTime, timetableNotificationId: $timetableNotificationId, digestiveNotificationTimeBefore: $digestiveNotificationTimeBefore, timetable: $timetable, digestiveNotifications: $digestiveNotifications)';
}


}

/// @nodoc
abstract mixin class _$UserConfigCopyWith<$Res> implements $UserConfigCopyWith<$Res> {
  factory _$UserConfigCopyWith(_UserConfig value, $Res Function(_UserConfig) _then) = __$UserConfigCopyWithImpl;
@override @useResult
$Res call({
 int? schemaVersion,@JsonKey(includeFromJson: false, includeToJson: false) Timestamp? lastChanged,@TimeOfDayConverter() TimeOfDay? reminderNotificationTime,@TimeOfDayConverter() TimeOfDay? timetableNotificationTime, int? timetableNotificationId, int? digestiveNotificationTimeBefore, TimetableConfig? timetable, List<String> digestiveNotifications
});


@override $TimetableConfigCopyWith<$Res>? get timetable;

}
/// @nodoc
class __$UserConfigCopyWithImpl<$Res>
    implements _$UserConfigCopyWith<$Res> {
  __$UserConfigCopyWithImpl(this._self, this._then);

  final _UserConfig _self;
  final $Res Function(_UserConfig) _then;

/// Create a copy of UserConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = freezed,Object? lastChanged = freezed,Object? reminderNotificationTime = freezed,Object? timetableNotificationTime = freezed,Object? timetableNotificationId = freezed,Object? digestiveNotificationTimeBefore = freezed,Object? timetable = freezed,Object? digestiveNotifications = null,}) {
  return _then(_UserConfig(
schemaVersion: freezed == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int?,lastChanged: freezed == lastChanged ? _self.lastChanged : lastChanged // ignore: cast_nullable_to_non_nullable
as Timestamp?,reminderNotificationTime: freezed == reminderNotificationTime ? _self.reminderNotificationTime : reminderNotificationTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,timetableNotificationTime: freezed == timetableNotificationTime ? _self.timetableNotificationTime : timetableNotificationTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,timetableNotificationId: freezed == timetableNotificationId ? _self.timetableNotificationId : timetableNotificationId // ignore: cast_nullable_to_non_nullable
as int?,digestiveNotificationTimeBefore: freezed == digestiveNotificationTimeBefore ? _self.digestiveNotificationTimeBefore : digestiveNotificationTimeBefore // ignore: cast_nullable_to_non_nullable
as int?,timetable: freezed == timetable ? _self.timetable : timetable // ignore: cast_nullable_to_non_nullable
as TimetableConfig?,digestiveNotifications: null == digestiveNotifications ? _self._digestiveNotifications : digestiveNotifications // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of UserConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimetableConfigCopyWith<$Res>? get timetable {
    if (_self.timetable == null) {
    return null;
  }

  return $TimetableConfigCopyWith<$Res>(_self.timetable!, (value) {
    return _then(_self.copyWith(timetable: value));
  });
}
}


/// @nodoc
mixin _$TimetableConfig {

 bool? get showSaturday; int? get periodCountToDisplay;
/// Create a copy of TimetableConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableConfigCopyWith<TimetableConfig> get copyWith => _$TimetableConfigCopyWithImpl<TimetableConfig>(this as TimetableConfig, _$identity);

  /// Serializes this TimetableConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableConfig&&(identical(other.showSaturday, showSaturday) || other.showSaturday == showSaturday)&&(identical(other.periodCountToDisplay, periodCountToDisplay) || other.periodCountToDisplay == periodCountToDisplay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showSaturday,periodCountToDisplay);

@override
String toString() {
  return 'TimetableConfig(showSaturday: $showSaturday, periodCountToDisplay: $periodCountToDisplay)';
}


}

/// @nodoc
abstract mixin class $TimetableConfigCopyWith<$Res>  {
  factory $TimetableConfigCopyWith(TimetableConfig value, $Res Function(TimetableConfig) _then) = _$TimetableConfigCopyWithImpl;
@useResult
$Res call({
 bool? showSaturday, int? periodCountToDisplay
});




}
/// @nodoc
class _$TimetableConfigCopyWithImpl<$Res>
    implements $TimetableConfigCopyWith<$Res> {
  _$TimetableConfigCopyWithImpl(this._self, this._then);

  final TimetableConfig _self;
  final $Res Function(TimetableConfig) _then;

/// Create a copy of TimetableConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showSaturday = freezed,Object? periodCountToDisplay = freezed,}) {
  return _then(_self.copyWith(
showSaturday: freezed == showSaturday ? _self.showSaturday : showSaturday // ignore: cast_nullable_to_non_nullable
as bool?,periodCountToDisplay: freezed == periodCountToDisplay ? _self.periodCountToDisplay : periodCountToDisplay // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _TimetableConfig implements TimetableConfig {
  const _TimetableConfig({this.showSaturday, this.periodCountToDisplay});
  factory _TimetableConfig.fromJson(Map<String, dynamic> json) => _$TimetableConfigFromJson(json);

@override final  bool? showSaturday;
@override final  int? periodCountToDisplay;

/// Create a copy of TimetableConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableConfigCopyWith<_TimetableConfig> get copyWith => __$TimetableConfigCopyWithImpl<_TimetableConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableConfig&&(identical(other.showSaturday, showSaturday) || other.showSaturday == showSaturday)&&(identical(other.periodCountToDisplay, periodCountToDisplay) || other.periodCountToDisplay == periodCountToDisplay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showSaturday,periodCountToDisplay);

@override
String toString() {
  return 'TimetableConfig(showSaturday: $showSaturday, periodCountToDisplay: $periodCountToDisplay)';
}


}

/// @nodoc
abstract mixin class _$TimetableConfigCopyWith<$Res> implements $TimetableConfigCopyWith<$Res> {
  factory _$TimetableConfigCopyWith(_TimetableConfig value, $Res Function(_TimetableConfig) _then) = __$TimetableConfigCopyWithImpl;
@override @useResult
$Res call({
 bool? showSaturday, int? periodCountToDisplay
});




}
/// @nodoc
class __$TimetableConfigCopyWithImpl<$Res>
    implements _$TimetableConfigCopyWith<$Res> {
  __$TimetableConfigCopyWithImpl(this._self, this._then);

  final _TimetableConfig _self;
  final $Res Function(_TimetableConfig) _then;

/// Create a copy of TimetableConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showSaturday = freezed,Object? periodCountToDisplay = freezed,}) {
  return _then(_TimetableConfig(
showSaturday: freezed == showSaturday ? _self.showSaturday : showSaturday // ignore: cast_nullable_to_non_nullable
as bool?,periodCountToDisplay: freezed == periodCountToDisplay ? _self.periodCountToDisplay : periodCountToDisplay // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
