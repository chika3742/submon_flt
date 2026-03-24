// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complete_sign_in_use_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompleteSignInResult {
  bool get newUser;
  bool get notificationPermissionDenied;

  /// Create a copy of CompleteSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CompleteSignInResultCopyWith<CompleteSignInResult> get copyWith =>
      _$CompleteSignInResultCopyWithImpl<CompleteSignInResult>(
          this as CompleteSignInResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CompleteSignInResult &&
            (identical(other.newUser, newUser) || other.newUser == newUser) &&
            (identical(other.notificationPermissionDenied,
                    notificationPermissionDenied) ||
                other.notificationPermissionDenied ==
                    notificationPermissionDenied));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, newUser, notificationPermissionDenied);

  @override
  String toString() {
    return 'CompleteSignInResult(newUser: $newUser, notificationPermissionDenied: $notificationPermissionDenied)';
  }
}

/// @nodoc
abstract mixin class $CompleteSignInResultCopyWith<$Res> {
  factory $CompleteSignInResultCopyWith(CompleteSignInResult value,
          $Res Function(CompleteSignInResult) _then) =
      _$CompleteSignInResultCopyWithImpl;
  @useResult
  $Res call({bool newUser, bool notificationPermissionDenied});
}

/// @nodoc
class _$CompleteSignInResultCopyWithImpl<$Res>
    implements $CompleteSignInResultCopyWith<$Res> {
  _$CompleteSignInResultCopyWithImpl(this._self, this._then);

  final CompleteSignInResult _self;
  final $Res Function(CompleteSignInResult) _then;

  /// Create a copy of CompleteSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newUser = null,
    Object? notificationPermissionDenied = null,
  }) {
    return _then(_self.copyWith(
      newUser: null == newUser
          ? _self.newUser
          : newUser // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationPermissionDenied: null == notificationPermissionDenied
          ? _self.notificationPermissionDenied
          : notificationPermissionDenied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CompleteSignInResult].
extension CompleteSignInResultPatterns on CompleteSignInResult {
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
    TResult Function(_CompleteSignInResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CompleteSignInResult() when $default != null:
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
    TResult Function(_CompleteSignInResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompleteSignInResult():
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
    TResult? Function(_CompleteSignInResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompleteSignInResult() when $default != null:
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
    TResult Function(bool newUser, bool notificationPermissionDenied)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CompleteSignInResult() when $default != null:
        return $default(_that.newUser, _that.notificationPermissionDenied);
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
    TResult Function(bool newUser, bool notificationPermissionDenied) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompleteSignInResult():
        return $default(_that.newUser, _that.notificationPermissionDenied);
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
    TResult? Function(bool newUser, bool notificationPermissionDenied)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CompleteSignInResult() when $default != null:
        return $default(_that.newUser, _that.notificationPermissionDenied);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CompleteSignInResult implements CompleteSignInResult {
  const _CompleteSignInResult(
      {required this.newUser, required this.notificationPermissionDenied});

  @override
  final bool newUser;
  @override
  final bool notificationPermissionDenied;

  /// Create a copy of CompleteSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompleteSignInResultCopyWith<_CompleteSignInResult> get copyWith =>
      __$CompleteSignInResultCopyWithImpl<_CompleteSignInResult>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompleteSignInResult &&
            (identical(other.newUser, newUser) || other.newUser == newUser) &&
            (identical(other.notificationPermissionDenied,
                    notificationPermissionDenied) ||
                other.notificationPermissionDenied ==
                    notificationPermissionDenied));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, newUser, notificationPermissionDenied);

  @override
  String toString() {
    return 'CompleteSignInResult(newUser: $newUser, notificationPermissionDenied: $notificationPermissionDenied)';
  }
}

/// @nodoc
abstract mixin class _$CompleteSignInResultCopyWith<$Res>
    implements $CompleteSignInResultCopyWith<$Res> {
  factory _$CompleteSignInResultCopyWith(_CompleteSignInResult value,
          $Res Function(_CompleteSignInResult) _then) =
      __$CompleteSignInResultCopyWithImpl;
  @override
  @useResult
  $Res call({bool newUser, bool notificationPermissionDenied});
}

/// @nodoc
class __$CompleteSignInResultCopyWithImpl<$Res>
    implements _$CompleteSignInResultCopyWith<$Res> {
  __$CompleteSignInResultCopyWithImpl(this._self, this._then);

  final _CompleteSignInResult _self;
  final $Res Function(_CompleteSignInResult) _then;

  /// Create a copy of CompleteSignInResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? newUser = null,
    Object? notificationPermissionDenied = null,
  }) {
    return _then(_CompleteSignInResult(
      newUser: null == newUser
          ? _self.newUser
          : newUser // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationPermissionDenied: null == notificationPermissionDenied
          ? _self.notificationPermissionDenied
          : notificationPermissionDenied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
