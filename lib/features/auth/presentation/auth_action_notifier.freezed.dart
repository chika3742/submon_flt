// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_action_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthActionState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthActionState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthActionState()';
  }
}

/// @nodoc
class $AuthActionStateCopyWith<$Res> {
  $AuthActionStateCopyWith(
      AuthActionState _, $Res Function(AuthActionState) __);
}

/// Adds pattern-matching-related methods to [AuthActionState].
extension AuthActionStatePatterns on AuthActionState {
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
    TResult Function(AuthActionStateIdle value)? idle,
    TResult Function(AuthActionStateProcessing value)? processing,
    TResult Function(AuthActionStateSignedOut value)? signedOut,
    TResult Function(AuthActionStateFailed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthActionStateIdle() when idle != null:
        return idle(_that);
      case AuthActionStateProcessing() when processing != null:
        return processing(_that);
      case AuthActionStateSignedOut() when signedOut != null:
        return signedOut(_that);
      case AuthActionStateFailed() when failed != null:
        return failed(_that);
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
    required TResult Function(AuthActionStateIdle value) idle,
    required TResult Function(AuthActionStateProcessing value) processing,
    required TResult Function(AuthActionStateSignedOut value) signedOut,
    required TResult Function(AuthActionStateFailed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case AuthActionStateIdle():
        return idle(_that);
      case AuthActionStateProcessing():
        return processing(_that);
      case AuthActionStateSignedOut():
        return signedOut(_that);
      case AuthActionStateFailed():
        return failed(_that);
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
    TResult? Function(AuthActionStateIdle value)? idle,
    TResult? Function(AuthActionStateProcessing value)? processing,
    TResult? Function(AuthActionStateSignedOut value)? signedOut,
    TResult? Function(AuthActionStateFailed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case AuthActionStateIdle() when idle != null:
        return idle(_that);
      case AuthActionStateProcessing() when processing != null:
        return processing(_that);
      case AuthActionStateSignedOut() when signedOut != null:
        return signedOut(_that);
      case AuthActionStateFailed() when failed != null:
        return failed(_that);
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
    TResult Function()? processing,
    TResult Function()? signedOut,
    TResult Function(Object error)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthActionStateIdle() when idle != null:
        return idle();
      case AuthActionStateProcessing() when processing != null:
        return processing();
      case AuthActionStateSignedOut() when signedOut != null:
        return signedOut();
      case AuthActionStateFailed() when failed != null:
        return failed(_that.error);
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
    required TResult Function() processing,
    required TResult Function() signedOut,
    required TResult Function(Object error) failed,
  }) {
    final _that = this;
    switch (_that) {
      case AuthActionStateIdle():
        return idle();
      case AuthActionStateProcessing():
        return processing();
      case AuthActionStateSignedOut():
        return signedOut();
      case AuthActionStateFailed():
        return failed(_that.error);
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
    TResult? Function()? processing,
    TResult? Function()? signedOut,
    TResult? Function(Object error)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case AuthActionStateIdle() when idle != null:
        return idle();
      case AuthActionStateProcessing() when processing != null:
        return processing();
      case AuthActionStateSignedOut() when signedOut != null:
        return signedOut();
      case AuthActionStateFailed() when failed != null:
        return failed(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthActionStateIdle implements AuthActionState {
  const AuthActionStateIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthActionStateIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthActionState.idle()';
  }
}

/// @nodoc

class AuthActionStateProcessing implements AuthActionState {
  const AuthActionStateProcessing();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthActionStateProcessing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthActionState.processing()';
  }
}

/// @nodoc

class AuthActionStateSignedOut implements AuthActionState {
  const AuthActionStateSignedOut();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthActionStateSignedOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthActionState.signedOut()';
  }
}

/// @nodoc

class AuthActionStateFailed implements AuthActionState {
  const AuthActionStateFailed(this.error);

  final Object error;

  /// Create a copy of AuthActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthActionStateFailedCopyWith<AuthActionStateFailed> get copyWith =>
      _$AuthActionStateFailedCopyWithImpl<AuthActionStateFailed>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthActionStateFailed &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @override
  String toString() {
    return 'AuthActionState.failed(error: $error)';
  }
}

/// @nodoc
abstract mixin class $AuthActionStateFailedCopyWith<$Res>
    implements $AuthActionStateCopyWith<$Res> {
  factory $AuthActionStateFailedCopyWith(AuthActionStateFailed value,
          $Res Function(AuthActionStateFailed) _then) =
      _$AuthActionStateFailedCopyWithImpl;
  @useResult
  $Res call({Object error});
}

/// @nodoc
class _$AuthActionStateFailedCopyWithImpl<$Res>
    implements $AuthActionStateFailedCopyWith<$Res> {
  _$AuthActionStateFailedCopyWithImpl(this._self, this._then);

  final AuthActionStateFailed _self;
  final $Res Function(AuthActionStateFailed) _then;

  /// Create a copy of AuthActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(AuthActionStateFailed(
      null == error ? _self.error : error,
    ));
  }
}

// dart format on
