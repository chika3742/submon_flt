// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_link_auth_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmailLinkAuthState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EmailLinkAuthState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EmailLinkAuthState()';
  }
}

/// @nodoc
class $EmailLinkAuthStateCopyWith<$Res> {
  $EmailLinkAuthStateCopyWith(
      EmailLinkAuthState _, $Res Function(EmailLinkAuthState) __);
}

/// Adds pattern-matching-related methods to [EmailLinkAuthState].
extension EmailLinkAuthStatePatterns on EmailLinkAuthState {
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
    TResult Function(EmailLinkAuthStateIdle value)? idle,
    TResult Function(EmailLinkAuthStateProcessing value)? processing,
    TResult Function(EmailLinkAuthStateSignInSucceeded value)? signInSucceeded,
    TResult Function(EmailLinkAuthStateReAuthSucceeded value)? reAuthSucceeded,
    TResult Function(EmailLinkAuthStateUpgradeSucceeded value)?
        upgradeSucceeded,
    TResult Function(EmailLinkAuthStateFailed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case EmailLinkAuthStateIdle() when idle != null:
        return idle(_that);
      case EmailLinkAuthStateProcessing() when processing != null:
        return processing(_that);
      case EmailLinkAuthStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that);
      case EmailLinkAuthStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded(_that);
      case EmailLinkAuthStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded(_that);
      case EmailLinkAuthStateFailed() when failed != null:
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
    required TResult Function(EmailLinkAuthStateIdle value) idle,
    required TResult Function(EmailLinkAuthStateProcessing value) processing,
    required TResult Function(EmailLinkAuthStateSignInSucceeded value)
        signInSucceeded,
    required TResult Function(EmailLinkAuthStateReAuthSucceeded value)
        reAuthSucceeded,
    required TResult Function(EmailLinkAuthStateUpgradeSucceeded value)
        upgradeSucceeded,
    required TResult Function(EmailLinkAuthStateFailed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case EmailLinkAuthStateIdle():
        return idle(_that);
      case EmailLinkAuthStateProcessing():
        return processing(_that);
      case EmailLinkAuthStateSignInSucceeded():
        return signInSucceeded(_that);
      case EmailLinkAuthStateReAuthSucceeded():
        return reAuthSucceeded(_that);
      case EmailLinkAuthStateUpgradeSucceeded():
        return upgradeSucceeded(_that);
      case EmailLinkAuthStateFailed():
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
    TResult? Function(EmailLinkAuthStateIdle value)? idle,
    TResult? Function(EmailLinkAuthStateProcessing value)? processing,
    TResult? Function(EmailLinkAuthStateSignInSucceeded value)? signInSucceeded,
    TResult? Function(EmailLinkAuthStateReAuthSucceeded value)? reAuthSucceeded,
    TResult? Function(EmailLinkAuthStateUpgradeSucceeded value)?
        upgradeSucceeded,
    TResult? Function(EmailLinkAuthStateFailed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case EmailLinkAuthStateIdle() when idle != null:
        return idle(_that);
      case EmailLinkAuthStateProcessing() when processing != null:
        return processing(_that);
      case EmailLinkAuthStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that);
      case EmailLinkAuthStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded(_that);
      case EmailLinkAuthStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded(_that);
      case EmailLinkAuthStateFailed() when failed != null:
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
    TResult Function(CompleteSignInResult result)? signInSucceeded,
    TResult Function(AuthContinueDestination destination)? reAuthSucceeded,
    TResult Function()? upgradeSucceeded,
    TResult Function(Object error)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case EmailLinkAuthStateIdle() when idle != null:
        return idle();
      case EmailLinkAuthStateProcessing() when processing != null:
        return processing();
      case EmailLinkAuthStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that.result);
      case EmailLinkAuthStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded(_that.destination);
      case EmailLinkAuthStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded();
      case EmailLinkAuthStateFailed() when failed != null:
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
    required TResult Function(CompleteSignInResult result) signInSucceeded,
    required TResult Function(AuthContinueDestination destination)
        reAuthSucceeded,
    required TResult Function() upgradeSucceeded,
    required TResult Function(Object error) failed,
  }) {
    final _that = this;
    switch (_that) {
      case EmailLinkAuthStateIdle():
        return idle();
      case EmailLinkAuthStateProcessing():
        return processing();
      case EmailLinkAuthStateSignInSucceeded():
        return signInSucceeded(_that.result);
      case EmailLinkAuthStateReAuthSucceeded():
        return reAuthSucceeded(_that.destination);
      case EmailLinkAuthStateUpgradeSucceeded():
        return upgradeSucceeded();
      case EmailLinkAuthStateFailed():
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
    TResult? Function(CompleteSignInResult result)? signInSucceeded,
    TResult? Function(AuthContinueDestination destination)? reAuthSucceeded,
    TResult? Function()? upgradeSucceeded,
    TResult? Function(Object error)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case EmailLinkAuthStateIdle() when idle != null:
        return idle();
      case EmailLinkAuthStateProcessing() when processing != null:
        return processing();
      case EmailLinkAuthStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that.result);
      case EmailLinkAuthStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded(_that.destination);
      case EmailLinkAuthStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded();
      case EmailLinkAuthStateFailed() when failed != null:
        return failed(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class EmailLinkAuthStateIdle implements EmailLinkAuthState {
  const EmailLinkAuthStateIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EmailLinkAuthStateIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EmailLinkAuthState.idle()';
  }
}

/// @nodoc

class EmailLinkAuthStateProcessing implements EmailLinkAuthState {
  const EmailLinkAuthStateProcessing();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EmailLinkAuthStateProcessing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EmailLinkAuthState.processing()';
  }
}

/// @nodoc

class EmailLinkAuthStateSignInSucceeded implements EmailLinkAuthState {
  const EmailLinkAuthStateSignInSucceeded(this.result);

  final CompleteSignInResult result;

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EmailLinkAuthStateSignInSucceededCopyWith<EmailLinkAuthStateSignInSucceeded>
      get copyWith => _$EmailLinkAuthStateSignInSucceededCopyWithImpl<
          EmailLinkAuthStateSignInSucceeded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EmailLinkAuthStateSignInSucceeded &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  @override
  String toString() {
    return 'EmailLinkAuthState.signInSucceeded(result: $result)';
  }
}

/// @nodoc
abstract mixin class $EmailLinkAuthStateSignInSucceededCopyWith<$Res>
    implements $EmailLinkAuthStateCopyWith<$Res> {
  factory $EmailLinkAuthStateSignInSucceededCopyWith(
          EmailLinkAuthStateSignInSucceeded value,
          $Res Function(EmailLinkAuthStateSignInSucceeded) _then) =
      _$EmailLinkAuthStateSignInSucceededCopyWithImpl;
  @useResult
  $Res call({CompleteSignInResult result});

  $CompleteSignInResultCopyWith<$Res> get result;
}

/// @nodoc
class _$EmailLinkAuthStateSignInSucceededCopyWithImpl<$Res>
    implements $EmailLinkAuthStateSignInSucceededCopyWith<$Res> {
  _$EmailLinkAuthStateSignInSucceededCopyWithImpl(this._self, this._then);

  final EmailLinkAuthStateSignInSucceeded _self;
  final $Res Function(EmailLinkAuthStateSignInSucceeded) _then;

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? result = null,
  }) {
    return _then(EmailLinkAuthStateSignInSucceeded(
      null == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as CompleteSignInResult,
    ));
  }

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompleteSignInResultCopyWith<$Res> get result {
    return $CompleteSignInResultCopyWith<$Res>(_self.result, (value) {
      return _then(_self.copyWith(result: value));
    });
  }
}

/// @nodoc

class EmailLinkAuthStateReAuthSucceeded implements EmailLinkAuthState {
  const EmailLinkAuthStateReAuthSucceeded(this.destination);

  final AuthContinueDestination destination;

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EmailLinkAuthStateReAuthSucceededCopyWith<EmailLinkAuthStateReAuthSucceeded>
      get copyWith => _$EmailLinkAuthStateReAuthSucceededCopyWithImpl<
          EmailLinkAuthStateReAuthSucceeded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EmailLinkAuthStateReAuthSucceeded &&
            (identical(other.destination, destination) ||
                other.destination == destination));
  }

  @override
  int get hashCode => Object.hash(runtimeType, destination);

  @override
  String toString() {
    return 'EmailLinkAuthState.reAuthSucceeded(destination: $destination)';
  }
}

/// @nodoc
abstract mixin class $EmailLinkAuthStateReAuthSucceededCopyWith<$Res>
    implements $EmailLinkAuthStateCopyWith<$Res> {
  factory $EmailLinkAuthStateReAuthSucceededCopyWith(
          EmailLinkAuthStateReAuthSucceeded value,
          $Res Function(EmailLinkAuthStateReAuthSucceeded) _then) =
      _$EmailLinkAuthStateReAuthSucceededCopyWithImpl;
  @useResult
  $Res call({AuthContinueDestination destination});

  $AuthContinueDestinationCopyWith<$Res> get destination;
}

/// @nodoc
class _$EmailLinkAuthStateReAuthSucceededCopyWithImpl<$Res>
    implements $EmailLinkAuthStateReAuthSucceededCopyWith<$Res> {
  _$EmailLinkAuthStateReAuthSucceededCopyWithImpl(this._self, this._then);

  final EmailLinkAuthStateReAuthSucceeded _self;
  final $Res Function(EmailLinkAuthStateReAuthSucceeded) _then;

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? destination = null,
  }) {
    return _then(EmailLinkAuthStateReAuthSucceeded(
      null == destination
          ? _self.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as AuthContinueDestination,
    ));
  }

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthContinueDestinationCopyWith<$Res> get destination {
    return $AuthContinueDestinationCopyWith<$Res>(_self.destination, (value) {
      return _then(_self.copyWith(destination: value));
    });
  }
}

/// @nodoc

class EmailLinkAuthStateUpgradeSucceeded implements EmailLinkAuthState {
  const EmailLinkAuthStateUpgradeSucceeded();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EmailLinkAuthStateUpgradeSucceeded);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EmailLinkAuthState.upgradeSucceeded()';
  }
}

/// @nodoc

class EmailLinkAuthStateFailed implements EmailLinkAuthState {
  const EmailLinkAuthStateFailed(this.error);

  final Object error;

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EmailLinkAuthStateFailedCopyWith<EmailLinkAuthStateFailed> get copyWith =>
      _$EmailLinkAuthStateFailedCopyWithImpl<EmailLinkAuthStateFailed>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EmailLinkAuthStateFailed &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @override
  String toString() {
    return 'EmailLinkAuthState.failed(error: $error)';
  }
}

/// @nodoc
abstract mixin class $EmailLinkAuthStateFailedCopyWith<$Res>
    implements $EmailLinkAuthStateCopyWith<$Res> {
  factory $EmailLinkAuthStateFailedCopyWith(EmailLinkAuthStateFailed value,
          $Res Function(EmailLinkAuthStateFailed) _then) =
      _$EmailLinkAuthStateFailedCopyWithImpl;
  @useResult
  $Res call({Object error});
}

/// @nodoc
class _$EmailLinkAuthStateFailedCopyWithImpl<$Res>
    implements $EmailLinkAuthStateFailedCopyWith<$Res> {
  _$EmailLinkAuthStateFailedCopyWithImpl(this._self, this._then);

  final EmailLinkAuthStateFailed _self;
  final $Res Function(EmailLinkAuthStateFailed) _then;

  /// Create a copy of EmailLinkAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(EmailLinkAuthStateFailed(
      null == error ? _self.error : error,
    ));
  }
}

// dart format on
