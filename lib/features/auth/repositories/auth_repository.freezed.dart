// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FetchCredentialResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FetchCredentialResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FetchCredentialResult()';
  }
}

/// @nodoc
class $FetchCredentialResultCopyWith<$Res> {
  $FetchCredentialResultCopyWith(
      FetchCredentialResult _, $Res Function(FetchCredentialResult) __);
}

/// Adds pattern-matching-related methods to [FetchCredentialResult].
extension FetchCredentialResultPatterns on FetchCredentialResult {
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
    TResult Function(FetchCredentialResultSuccess value)? success,
    TResult Function(FetchCredentialResultCanceled value)? canceled,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchCredentialResultSuccess() when success != null:
        return success(_that);
      case FetchCredentialResultCanceled() when canceled != null:
        return canceled(_that);
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
    required TResult Function(FetchCredentialResultSuccess value) success,
    required TResult Function(FetchCredentialResultCanceled value) canceled,
  }) {
    final _that = this;
    switch (_that) {
      case FetchCredentialResultSuccess():
        return success(_that);
      case FetchCredentialResultCanceled():
        return canceled(_that);
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
    TResult? Function(FetchCredentialResultSuccess value)? success,
    TResult? Function(FetchCredentialResultCanceled value)? canceled,
  }) {
    final _that = this;
    switch (_that) {
      case FetchCredentialResultSuccess() when success != null:
        return success(_that);
      case FetchCredentialResultCanceled() when canceled != null:
        return canceled(_that);
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
    TResult Function(OAuthCredential credential, bool mayRequireConsent)?
        success,
    TResult Function()? canceled,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchCredentialResultSuccess() when success != null:
        return success(_that.credential, _that.mayRequireConsent);
      case FetchCredentialResultCanceled() when canceled != null:
        return canceled();
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
    required TResult Function(
            OAuthCredential credential, bool mayRequireConsent)
        success,
    required TResult Function() canceled,
  }) {
    final _that = this;
    switch (_that) {
      case FetchCredentialResultSuccess():
        return success(_that.credential, _that.mayRequireConsent);
      case FetchCredentialResultCanceled():
        return canceled();
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
    TResult? Function(OAuthCredential credential, bool mayRequireConsent)?
        success,
    TResult? Function()? canceled,
  }) {
    final _that = this;
    switch (_that) {
      case FetchCredentialResultSuccess() when success != null:
        return success(_that.credential, _that.mayRequireConsent);
      case FetchCredentialResultCanceled() when canceled != null:
        return canceled();
      case _:
        return null;
    }
  }
}

/// @nodoc

class FetchCredentialResultSuccess implements FetchCredentialResult {
  const FetchCredentialResultSuccess(
      {required this.credential, this.mayRequireConsent = false});

  final OAuthCredential credential;
  @JsonKey()
  final bool mayRequireConsent;

  /// Create a copy of FetchCredentialResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FetchCredentialResultSuccessCopyWith<FetchCredentialResultSuccess>
      get copyWith => _$FetchCredentialResultSuccessCopyWithImpl<
          FetchCredentialResultSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FetchCredentialResultSuccess &&
            (identical(other.credential, credential) ||
                other.credential == credential) &&
            (identical(other.mayRequireConsent, mayRequireConsent) ||
                other.mayRequireConsent == mayRequireConsent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, credential, mayRequireConsent);

  @override
  String toString() {
    return 'FetchCredentialResult.success(credential: $credential, mayRequireConsent: $mayRequireConsent)';
  }
}

/// @nodoc
abstract mixin class $FetchCredentialResultSuccessCopyWith<$Res>
    implements $FetchCredentialResultCopyWith<$Res> {
  factory $FetchCredentialResultSuccessCopyWith(
          FetchCredentialResultSuccess value,
          $Res Function(FetchCredentialResultSuccess) _then) =
      _$FetchCredentialResultSuccessCopyWithImpl;
  @useResult
  $Res call({OAuthCredential credential, bool mayRequireConsent});
}

/// @nodoc
class _$FetchCredentialResultSuccessCopyWithImpl<$Res>
    implements $FetchCredentialResultSuccessCopyWith<$Res> {
  _$FetchCredentialResultSuccessCopyWithImpl(this._self, this._then);

  final FetchCredentialResultSuccess _self;
  final $Res Function(FetchCredentialResultSuccess) _then;

  /// Create a copy of FetchCredentialResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? credential = null,
    Object? mayRequireConsent = null,
  }) {
    return _then(FetchCredentialResultSuccess(
      credential: null == credential
          ? _self.credential
          : credential // ignore: cast_nullable_to_non_nullable
              as OAuthCredential,
      mayRequireConsent: null == mayRequireConsent
          ? _self.mayRequireConsent
          : mayRequireConsent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class FetchCredentialResultCanceled implements FetchCredentialResult {
  const FetchCredentialResultCanceled();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FetchCredentialResultCanceled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FetchCredentialResult.canceled()';
  }
}

// dart format on
