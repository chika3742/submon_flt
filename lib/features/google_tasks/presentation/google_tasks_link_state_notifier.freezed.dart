// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_tasks_link_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoogleTasksUser {
  String get email;

  /// Create a copy of GoogleTasksUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoogleTasksUserCopyWith<GoogleTasksUser> get copyWith =>
      _$GoogleTasksUserCopyWithImpl<GoogleTasksUser>(
          this as GoogleTasksUser, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksUser &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @override
  String toString() {
    return 'GoogleTasksUser(email: $email)';
  }
}

/// @nodoc
abstract mixin class $GoogleTasksUserCopyWith<$Res> {
  factory $GoogleTasksUserCopyWith(
          GoogleTasksUser value, $Res Function(GoogleTasksUser) _then) =
      _$GoogleTasksUserCopyWithImpl;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$GoogleTasksUserCopyWithImpl<$Res>
    implements $GoogleTasksUserCopyWith<$Res> {
  _$GoogleTasksUserCopyWithImpl(this._self, this._then);

  final GoogleTasksUser _self;
  final $Res Function(GoogleTasksUser) _then;

  /// Create a copy of GoogleTasksUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [GoogleTasksUser].
extension GoogleTasksUserPatterns on GoogleTasksUser {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GoogleTasksUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoogleTasksUser() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GoogleTasksUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoogleTasksUser():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GoogleTasksUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoogleTasksUser() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String email)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoogleTasksUser() when $default != null:
        return $default(_that.email);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String email) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoogleTasksUser():
        return $default(_that.email);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String email)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoogleTasksUser() when $default != null:
        return $default(_that.email);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GoogleTasksUser implements GoogleTasksUser {
  const _GoogleTasksUser({required this.email});

  @override
  final String email;

  /// Create a copy of GoogleTasksUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoogleTasksUserCopyWith<_GoogleTasksUser> get copyWith =>
      __$GoogleTasksUserCopyWithImpl<_GoogleTasksUser>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoogleTasksUser &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @override
  String toString() {
    return 'GoogleTasksUser(email: $email)';
  }
}

/// @nodoc
abstract mixin class _$GoogleTasksUserCopyWith<$Res>
    implements $GoogleTasksUserCopyWith<$Res> {
  factory _$GoogleTasksUserCopyWith(
          _GoogleTasksUser value, $Res Function(_GoogleTasksUser) _then) =
      __$GoogleTasksUserCopyWithImpl;
  @override
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$GoogleTasksUserCopyWithImpl<$Res>
    implements _$GoogleTasksUserCopyWith<$Res> {
  __$GoogleTasksUserCopyWithImpl(this._self, this._then);

  final _GoogleTasksUser _self;
  final $Res Function(_GoogleTasksUser) _then;

  /// Create a copy of GoogleTasksUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
  }) {
    return _then(_GoogleTasksUser(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$GoogleTasksLinkProcessState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksLinkProcessState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoogleTasksLinkProcessState()';
  }
}

/// @nodoc
class $GoogleTasksLinkProcessStateCopyWith<$Res> {
  $GoogleTasksLinkProcessStateCopyWith(GoogleTasksLinkProcessState _,
      $Res Function(GoogleTasksLinkProcessState) __);
}

/// Adds pattern-matching-related methods to [GoogleTasksLinkProcessState].
extension GoogleTasksLinkProcessStatePatterns on GoogleTasksLinkProcessState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleTasksLinkProcessStateIdle value)? idle,
    TResult Function(GoogleTasksLinkProcessStateLoading value)? loading,
    TResult Function(GoogleTasksLinkProcessStateFailed value)? failed,
    TResult Function(GoogleTasksLinkProcessStateConnected value)? connected,
    TResult Function(GoogleTasksLinkProcessStateDisconnected value)?
        disconnected,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GoogleTasksLinkProcessStateIdle() when idle != null:
        return idle(_that);
      case GoogleTasksLinkProcessStateLoading() when loading != null:
        return loading(_that);
      case GoogleTasksLinkProcessStateFailed() when failed != null:
        return failed(_that);
      case GoogleTasksLinkProcessStateConnected() when connected != null:
        return connected(_that);
      case GoogleTasksLinkProcessStateDisconnected() when disconnected != null:
        return disconnected(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleTasksLinkProcessStateIdle value) idle,
    required TResult Function(GoogleTasksLinkProcessStateLoading value) loading,
    required TResult Function(GoogleTasksLinkProcessStateFailed value) failed,
    required TResult Function(GoogleTasksLinkProcessStateConnected value)
        connected,
    required TResult Function(GoogleTasksLinkProcessStateDisconnected value)
        disconnected,
  }) {
    final _that = this;
    switch (_that) {
      case GoogleTasksLinkProcessStateIdle():
        return idle(_that);
      case GoogleTasksLinkProcessStateLoading():
        return loading(_that);
      case GoogleTasksLinkProcessStateFailed():
        return failed(_that);
      case GoogleTasksLinkProcessStateConnected():
        return connected(_that);
      case GoogleTasksLinkProcessStateDisconnected():
        return disconnected(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleTasksLinkProcessStateIdle value)? idle,
    TResult? Function(GoogleTasksLinkProcessStateLoading value)? loading,
    TResult? Function(GoogleTasksLinkProcessStateFailed value)? failed,
    TResult? Function(GoogleTasksLinkProcessStateConnected value)? connected,
    TResult? Function(GoogleTasksLinkProcessStateDisconnected value)?
        disconnected,
  }) {
    final _that = this;
    switch (_that) {
      case GoogleTasksLinkProcessStateIdle() when idle != null:
        return idle(_that);
      case GoogleTasksLinkProcessStateLoading() when loading != null:
        return loading(_that);
      case GoogleTasksLinkProcessStateFailed() when failed != null:
        return failed(_that);
      case GoogleTasksLinkProcessStateConnected() when connected != null:
        return connected(_that);
      case GoogleTasksLinkProcessStateDisconnected() when disconnected != null:
        return disconnected(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(Object e)? failed,
    TResult Function()? connected,
    TResult Function()? disconnected,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GoogleTasksLinkProcessStateIdle() when idle != null:
        return idle();
      case GoogleTasksLinkProcessStateLoading() when loading != null:
        return loading();
      case GoogleTasksLinkProcessStateFailed() when failed != null:
        return failed(_that.e);
      case GoogleTasksLinkProcessStateConnected() when connected != null:
        return connected();
      case GoogleTasksLinkProcessStateDisconnected() when disconnected != null:
        return disconnected();
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(Object e) failed,
    required TResult Function() connected,
    required TResult Function() disconnected,
  }) {
    final _that = this;
    switch (_that) {
      case GoogleTasksLinkProcessStateIdle():
        return idle();
      case GoogleTasksLinkProcessStateLoading():
        return loading();
      case GoogleTasksLinkProcessStateFailed():
        return failed(_that.e);
      case GoogleTasksLinkProcessStateConnected():
        return connected();
      case GoogleTasksLinkProcessStateDisconnected():
        return disconnected();
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(Object e)? failed,
    TResult? Function()? connected,
    TResult? Function()? disconnected,
  }) {
    final _that = this;
    switch (_that) {
      case GoogleTasksLinkProcessStateIdle() when idle != null:
        return idle();
      case GoogleTasksLinkProcessStateLoading() when loading != null:
        return loading();
      case GoogleTasksLinkProcessStateFailed() when failed != null:
        return failed(_that.e);
      case GoogleTasksLinkProcessStateConnected() when connected != null:
        return connected();
      case GoogleTasksLinkProcessStateDisconnected() when disconnected != null:
        return disconnected();
      case _:
        return null;
    }
  }
}

/// @nodoc

class GoogleTasksLinkProcessStateIdle implements GoogleTasksLinkProcessState {
  const GoogleTasksLinkProcessStateIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksLinkProcessStateIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoogleTasksLinkProcessState.idle()';
  }
}

/// @nodoc

class GoogleTasksLinkProcessStateLoading
    implements GoogleTasksLinkProcessState {
  const GoogleTasksLinkProcessStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksLinkProcessStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoogleTasksLinkProcessState.loading()';
  }
}

/// @nodoc

class GoogleTasksLinkProcessStateFailed implements GoogleTasksLinkProcessState {
  const GoogleTasksLinkProcessStateFailed(this.e);

  final Object e;

  /// Create a copy of GoogleTasksLinkProcessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoogleTasksLinkProcessStateFailedCopyWith<GoogleTasksLinkProcessStateFailed>
      get copyWith => _$GoogleTasksLinkProcessStateFailedCopyWithImpl<
          GoogleTasksLinkProcessStateFailed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksLinkProcessStateFailed &&
            const DeepCollectionEquality().equals(other.e, e));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(e));

  @override
  String toString() {
    return 'GoogleTasksLinkProcessState.failed(e: $e)';
  }
}

/// @nodoc
abstract mixin class $GoogleTasksLinkProcessStateFailedCopyWith<$Res>
    implements $GoogleTasksLinkProcessStateCopyWith<$Res> {
  factory $GoogleTasksLinkProcessStateFailedCopyWith(
          GoogleTasksLinkProcessStateFailed value,
          $Res Function(GoogleTasksLinkProcessStateFailed) _then) =
      _$GoogleTasksLinkProcessStateFailedCopyWithImpl;
  @useResult
  $Res call({Object e});
}

/// @nodoc
class _$GoogleTasksLinkProcessStateFailedCopyWithImpl<$Res>
    implements $GoogleTasksLinkProcessStateFailedCopyWith<$Res> {
  _$GoogleTasksLinkProcessStateFailedCopyWithImpl(this._self, this._then);

  final GoogleTasksLinkProcessStateFailed _self;
  final $Res Function(GoogleTasksLinkProcessStateFailed) _then;

  /// Create a copy of GoogleTasksLinkProcessState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? e = null,
  }) {
    return _then(GoogleTasksLinkProcessStateFailed(
      null == e ? _self.e : e,
    ));
  }
}

/// @nodoc

class GoogleTasksLinkProcessStateConnected
    implements GoogleTasksLinkProcessState {
  const GoogleTasksLinkProcessStateConnected();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksLinkProcessStateConnected);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoogleTasksLinkProcessState.connected()';
  }
}

/// @nodoc

class GoogleTasksLinkProcessStateDisconnected
    implements GoogleTasksLinkProcessState {
  const GoogleTasksLinkProcessStateDisconnected();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksLinkProcessStateDisconnected);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GoogleTasksLinkProcessState.disconnected()';
  }
}

// dart format on
