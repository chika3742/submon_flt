// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_save_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmissionSaveState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SubmissionSaveState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SubmissionSaveState()';
  }
}

/// @nodoc
class $SubmissionSaveStateCopyWith<$Res> {
  $SubmissionSaveStateCopyWith(
      SubmissionSaveState _, $Res Function(SubmissionSaveState) __);
}

/// Adds pattern-matching-related methods to [SubmissionSaveState].
extension SubmissionSaveStatePatterns on SubmissionSaveState {
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
    TResult Function(SubmissionSaveStateNone value)? none,
    TResult Function(SubmissionSaveStateFailed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SubmissionSaveStateNone() when none != null:
        return none(_that);
      case SubmissionSaveStateFailed() when failed != null:
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
    required TResult Function(SubmissionSaveStateNone value) none,
    required TResult Function(SubmissionSaveStateFailed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case SubmissionSaveStateNone():
        return none(_that);
      case SubmissionSaveStateFailed():
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
    TResult? Function(SubmissionSaveStateNone value)? none,
    TResult? Function(SubmissionSaveStateFailed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case SubmissionSaveStateNone() when none != null:
        return none(_that);
      case SubmissionSaveStateFailed() when failed != null:
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
    TResult Function()? none,
    TResult Function(Object error)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SubmissionSaveStateNone() when none != null:
        return none();
      case SubmissionSaveStateFailed() when failed != null:
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
    required TResult Function() none,
    required TResult Function(Object error) failed,
  }) {
    final _that = this;
    switch (_that) {
      case SubmissionSaveStateNone():
        return none();
      case SubmissionSaveStateFailed():
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
    TResult? Function()? none,
    TResult? Function(Object error)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case SubmissionSaveStateNone() when none != null:
        return none();
      case SubmissionSaveStateFailed() when failed != null:
        return failed(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SubmissionSaveStateNone implements SubmissionSaveState {
  const SubmissionSaveStateNone();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SubmissionSaveStateNone);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SubmissionSaveState.none()';
  }
}

/// @nodoc

class SubmissionSaveStateFailed implements SubmissionSaveState {
  const SubmissionSaveStateFailed(this.error);

  final Object error;

  /// Create a copy of SubmissionSaveState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubmissionSaveStateFailedCopyWith<SubmissionSaveStateFailed> get copyWith =>
      _$SubmissionSaveStateFailedCopyWithImpl<SubmissionSaveStateFailed>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubmissionSaveStateFailed &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @override
  String toString() {
    return 'SubmissionSaveState.failed(error: $error)';
  }
}

/// @nodoc
abstract mixin class $SubmissionSaveStateFailedCopyWith<$Res>
    implements $SubmissionSaveStateCopyWith<$Res> {
  factory $SubmissionSaveStateFailedCopyWith(SubmissionSaveStateFailed value,
          $Res Function(SubmissionSaveStateFailed) _then) =
      _$SubmissionSaveStateFailedCopyWithImpl;
  @useResult
  $Res call({Object error});
}

/// @nodoc
class _$SubmissionSaveStateFailedCopyWithImpl<$Res>
    implements $SubmissionSaveStateFailedCopyWith<$Res> {
  _$SubmissionSaveStateFailedCopyWithImpl(this._self, this._then);

  final SubmissionSaveStateFailed _self;
  final $Res Function(SubmissionSaveStateFailed) _then;

  /// Create a copy of SubmissionSaveState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(SubmissionSaveStateFailed(
      null == error ? _self.error : error,
    ));
  }
}

// dart format on
