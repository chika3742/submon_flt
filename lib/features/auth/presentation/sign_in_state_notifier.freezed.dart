// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignInState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SignInState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState()';
  }
}

/// @nodoc
class $SignInStateCopyWith<$Res> {
  $SignInStateCopyWith(SignInState _, $Res Function(SignInState) __);
}

/// Adds pattern-matching-related methods to [SignInState].
extension SignInStatePatterns on SignInState {
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
    TResult Function(SignInStateIdle value)? idle,
    TResult Function(SignInStateBusy value)? busy,
    TResult Function(SignInStateFailed value)? failed,
    TResult Function(SignInStateSignInSucceeded value)? signInSucceeded,
    TResult Function(SignInStateUpgradeSucceeded value)? upgradeSucceeded,
    TResult Function(SignInStateReAuthSucceeded value)? reAuthSucceeded,
    TResult Function(SignInStateReAuthCanceled value)? reAuthCanceled,
    TResult Function(SignInStateWaitingForPasswordSignIn value)?
        waitingForPasswordSignIn,
    TResult Function(SignInStateWaitingForEmailLinkDialog value)?
        waitingForEmailLinkDialog,
    TResult Function(SignInStateSignInLinkSent value)? signInLinkSent,
    TResult Function(SignInStatePasswordResetLinkSent value)?
        passwordResetLinkSent,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SignInStateIdle() when idle != null:
        return idle(_that);
      case SignInStateBusy() when busy != null:
        return busy(_that);
      case SignInStateFailed() when failed != null:
        return failed(_that);
      case SignInStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that);
      case SignInStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded(_that);
      case SignInStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded(_that);
      case SignInStateReAuthCanceled() when reAuthCanceled != null:
        return reAuthCanceled(_that);
      case SignInStateWaitingForPasswordSignIn()
          when waitingForPasswordSignIn != null:
        return waitingForPasswordSignIn(_that);
      case SignInStateWaitingForEmailLinkDialog()
          when waitingForEmailLinkDialog != null:
        return waitingForEmailLinkDialog(_that);
      case SignInStateSignInLinkSent() when signInLinkSent != null:
        return signInLinkSent(_that);
      case SignInStatePasswordResetLinkSent()
          when passwordResetLinkSent != null:
        return passwordResetLinkSent(_that);
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
    required TResult Function(SignInStateIdle value) idle,
    required TResult Function(SignInStateBusy value) busy,
    required TResult Function(SignInStateFailed value) failed,
    required TResult Function(SignInStateSignInSucceeded value) signInSucceeded,
    required TResult Function(SignInStateUpgradeSucceeded value)
        upgradeSucceeded,
    required TResult Function(SignInStateReAuthSucceeded value) reAuthSucceeded,
    required TResult Function(SignInStateReAuthCanceled value) reAuthCanceled,
    required TResult Function(SignInStateWaitingForPasswordSignIn value)
        waitingForPasswordSignIn,
    required TResult Function(SignInStateWaitingForEmailLinkDialog value)
        waitingForEmailLinkDialog,
    required TResult Function(SignInStateSignInLinkSent value) signInLinkSent,
    required TResult Function(SignInStatePasswordResetLinkSent value)
        passwordResetLinkSent,
  }) {
    final _that = this;
    switch (_that) {
      case SignInStateIdle():
        return idle(_that);
      case SignInStateBusy():
        return busy(_that);
      case SignInStateFailed():
        return failed(_that);
      case SignInStateSignInSucceeded():
        return signInSucceeded(_that);
      case SignInStateUpgradeSucceeded():
        return upgradeSucceeded(_that);
      case SignInStateReAuthSucceeded():
        return reAuthSucceeded(_that);
      case SignInStateReAuthCanceled():
        return reAuthCanceled(_that);
      case SignInStateWaitingForPasswordSignIn():
        return waitingForPasswordSignIn(_that);
      case SignInStateWaitingForEmailLinkDialog():
        return waitingForEmailLinkDialog(_that);
      case SignInStateSignInLinkSent():
        return signInLinkSent(_that);
      case SignInStatePasswordResetLinkSent():
        return passwordResetLinkSent(_that);
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
    TResult? Function(SignInStateIdle value)? idle,
    TResult? Function(SignInStateBusy value)? busy,
    TResult? Function(SignInStateFailed value)? failed,
    TResult? Function(SignInStateSignInSucceeded value)? signInSucceeded,
    TResult? Function(SignInStateUpgradeSucceeded value)? upgradeSucceeded,
    TResult? Function(SignInStateReAuthSucceeded value)? reAuthSucceeded,
    TResult? Function(SignInStateReAuthCanceled value)? reAuthCanceled,
    TResult? Function(SignInStateWaitingForPasswordSignIn value)?
        waitingForPasswordSignIn,
    TResult? Function(SignInStateWaitingForEmailLinkDialog value)?
        waitingForEmailLinkDialog,
    TResult? Function(SignInStateSignInLinkSent value)? signInLinkSent,
    TResult? Function(SignInStatePasswordResetLinkSent value)?
        passwordResetLinkSent,
  }) {
    final _that = this;
    switch (_that) {
      case SignInStateIdle() when idle != null:
        return idle(_that);
      case SignInStateBusy() when busy != null:
        return busy(_that);
      case SignInStateFailed() when failed != null:
        return failed(_that);
      case SignInStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that);
      case SignInStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded(_that);
      case SignInStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded(_that);
      case SignInStateReAuthCanceled() when reAuthCanceled != null:
        return reAuthCanceled(_that);
      case SignInStateWaitingForPasswordSignIn()
          when waitingForPasswordSignIn != null:
        return waitingForPasswordSignIn(_that);
      case SignInStateWaitingForEmailLinkDialog()
          when waitingForEmailLinkDialog != null:
        return waitingForEmailLinkDialog(_that);
      case SignInStateSignInLinkSent() when signInLinkSent != null:
        return signInLinkSent(_that);
      case SignInStatePasswordResetLinkSent()
          when passwordResetLinkSent != null:
        return passwordResetLinkSent(_that);
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
    TResult Function()? busy,
    TResult Function(Object error)? failed,
    TResult Function(CompleteSignInResult completionResult)? signInSucceeded,
    TResult Function()? upgradeSucceeded,
    TResult Function()? reAuthSucceeded,
    TResult Function()? reAuthCanceled,
    TResult Function()? waitingForPasswordSignIn,
    TResult Function()? waitingForEmailLinkDialog,
    TResult Function()? signInLinkSent,
    TResult Function()? passwordResetLinkSent,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SignInStateIdle() when idle != null:
        return idle();
      case SignInStateBusy() when busy != null:
        return busy();
      case SignInStateFailed() when failed != null:
        return failed(_that.error);
      case SignInStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that.completionResult);
      case SignInStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded();
      case SignInStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded();
      case SignInStateReAuthCanceled() when reAuthCanceled != null:
        return reAuthCanceled();
      case SignInStateWaitingForPasswordSignIn()
          when waitingForPasswordSignIn != null:
        return waitingForPasswordSignIn();
      case SignInStateWaitingForEmailLinkDialog()
          when waitingForEmailLinkDialog != null:
        return waitingForEmailLinkDialog();
      case SignInStateSignInLinkSent() when signInLinkSent != null:
        return signInLinkSent();
      case SignInStatePasswordResetLinkSent()
          when passwordResetLinkSent != null:
        return passwordResetLinkSent();
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
    required TResult Function() busy,
    required TResult Function(Object error) failed,
    required TResult Function(CompleteSignInResult completionResult)
        signInSucceeded,
    required TResult Function() upgradeSucceeded,
    required TResult Function() reAuthSucceeded,
    required TResult Function() reAuthCanceled,
    required TResult Function() waitingForPasswordSignIn,
    required TResult Function() waitingForEmailLinkDialog,
    required TResult Function() signInLinkSent,
    required TResult Function() passwordResetLinkSent,
  }) {
    final _that = this;
    switch (_that) {
      case SignInStateIdle():
        return idle();
      case SignInStateBusy():
        return busy();
      case SignInStateFailed():
        return failed(_that.error);
      case SignInStateSignInSucceeded():
        return signInSucceeded(_that.completionResult);
      case SignInStateUpgradeSucceeded():
        return upgradeSucceeded();
      case SignInStateReAuthSucceeded():
        return reAuthSucceeded();
      case SignInStateReAuthCanceled():
        return reAuthCanceled();
      case SignInStateWaitingForPasswordSignIn():
        return waitingForPasswordSignIn();
      case SignInStateWaitingForEmailLinkDialog():
        return waitingForEmailLinkDialog();
      case SignInStateSignInLinkSent():
        return signInLinkSent();
      case SignInStatePasswordResetLinkSent():
        return passwordResetLinkSent();
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
    TResult? Function()? busy,
    TResult? Function(Object error)? failed,
    TResult? Function(CompleteSignInResult completionResult)? signInSucceeded,
    TResult? Function()? upgradeSucceeded,
    TResult? Function()? reAuthSucceeded,
    TResult? Function()? reAuthCanceled,
    TResult? Function()? waitingForPasswordSignIn,
    TResult? Function()? waitingForEmailLinkDialog,
    TResult? Function()? signInLinkSent,
    TResult? Function()? passwordResetLinkSent,
  }) {
    final _that = this;
    switch (_that) {
      case SignInStateIdle() when idle != null:
        return idle();
      case SignInStateBusy() when busy != null:
        return busy();
      case SignInStateFailed() when failed != null:
        return failed(_that.error);
      case SignInStateSignInSucceeded() when signInSucceeded != null:
        return signInSucceeded(_that.completionResult);
      case SignInStateUpgradeSucceeded() when upgradeSucceeded != null:
        return upgradeSucceeded();
      case SignInStateReAuthSucceeded() when reAuthSucceeded != null:
        return reAuthSucceeded();
      case SignInStateReAuthCanceled() when reAuthCanceled != null:
        return reAuthCanceled();
      case SignInStateWaitingForPasswordSignIn()
          when waitingForPasswordSignIn != null:
        return waitingForPasswordSignIn();
      case SignInStateWaitingForEmailLinkDialog()
          when waitingForEmailLinkDialog != null:
        return waitingForEmailLinkDialog();
      case SignInStateSignInLinkSent() when signInLinkSent != null:
        return signInLinkSent();
      case SignInStatePasswordResetLinkSent()
          when passwordResetLinkSent != null:
        return passwordResetLinkSent();
      case _:
        return null;
    }
  }
}

/// @nodoc

class SignInStateIdle implements SignInState {
  const SignInStateIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SignInStateIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.idle()';
  }
}

/// @nodoc

class SignInStateBusy with AuthBusyState implements SignInState {
  const SignInStateBusy();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SignInStateBusy);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.busy()';
  }
}

/// @nodoc

class SignInStateFailed implements SignInState {
  const SignInStateFailed(this.error);

  final Object error;

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignInStateFailedCopyWith<SignInStateFailed> get copyWith =>
      _$SignInStateFailedCopyWithImpl<SignInStateFailed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateFailed &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @override
  String toString() {
    return 'SignInState.failed(error: $error)';
  }
}

/// @nodoc
abstract mixin class $SignInStateFailedCopyWith<$Res>
    implements $SignInStateCopyWith<$Res> {
  factory $SignInStateFailedCopyWith(
          SignInStateFailed value, $Res Function(SignInStateFailed) _then) =
      _$SignInStateFailedCopyWithImpl;
  @useResult
  $Res call({Object error});
}

/// @nodoc
class _$SignInStateFailedCopyWithImpl<$Res>
    implements $SignInStateFailedCopyWith<$Res> {
  _$SignInStateFailedCopyWithImpl(this._self, this._then);

  final SignInStateFailed _self;
  final $Res Function(SignInStateFailed) _then;

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(SignInStateFailed(
      null == error ? _self.error : error,
    ));
  }
}

/// @nodoc

class SignInStateSignInSucceeded implements SignInState {
  const SignInStateSignInSucceeded(this.completionResult);

  final CompleteSignInResult completionResult;

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignInStateSignInSucceededCopyWith<SignInStateSignInSucceeded>
      get copyWith =>
          _$SignInStateSignInSucceededCopyWithImpl<SignInStateSignInSucceeded>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateSignInSucceeded &&
            (identical(other.completionResult, completionResult) ||
                other.completionResult == completionResult));
  }

  @override
  int get hashCode => Object.hash(runtimeType, completionResult);

  @override
  String toString() {
    return 'SignInState.signInSucceeded(completionResult: $completionResult)';
  }
}

/// @nodoc
abstract mixin class $SignInStateSignInSucceededCopyWith<$Res>
    implements $SignInStateCopyWith<$Res> {
  factory $SignInStateSignInSucceededCopyWith(SignInStateSignInSucceeded value,
          $Res Function(SignInStateSignInSucceeded) _then) =
      _$SignInStateSignInSucceededCopyWithImpl;
  @useResult
  $Res call({CompleteSignInResult completionResult});

  $CompleteSignInResultCopyWith<$Res> get completionResult;
}

/// @nodoc
class _$SignInStateSignInSucceededCopyWithImpl<$Res>
    implements $SignInStateSignInSucceededCopyWith<$Res> {
  _$SignInStateSignInSucceededCopyWithImpl(this._self, this._then);

  final SignInStateSignInSucceeded _self;
  final $Res Function(SignInStateSignInSucceeded) _then;

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? completionResult = null,
  }) {
    return _then(SignInStateSignInSucceeded(
      null == completionResult
          ? _self.completionResult
          : completionResult // ignore: cast_nullable_to_non_nullable
              as CompleteSignInResult,
    ));
  }

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompleteSignInResultCopyWith<$Res> get completionResult {
    return $CompleteSignInResultCopyWith<$Res>(_self.completionResult, (value) {
      return _then(_self.copyWith(completionResult: value));
    });
  }
}

/// @nodoc

class SignInStateUpgradeSucceeded implements SignInState {
  const SignInStateUpgradeSucceeded();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateUpgradeSucceeded);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.upgradeSucceeded()';
  }
}

/// @nodoc

class SignInStateReAuthSucceeded implements SignInState {
  const SignInStateReAuthSucceeded();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateReAuthSucceeded);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.reAuthSucceeded()';
  }
}

/// @nodoc

class SignInStateReAuthCanceled implements SignInState {
  const SignInStateReAuthCanceled();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateReAuthCanceled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.reAuthCanceled()';
  }
}

/// @nodoc

class SignInStateWaitingForPasswordSignIn
    with AuthBusyState
    implements SignInState {
  const SignInStateWaitingForPasswordSignIn();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateWaitingForPasswordSignIn);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.waitingForPasswordSignIn()';
  }
}

/// @nodoc

class SignInStateWaitingForEmailLinkDialog
    with AuthBusyState
    implements SignInState {
  const SignInStateWaitingForEmailLinkDialog();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateWaitingForEmailLinkDialog);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.waitingForEmailLinkDialog()';
  }
}

/// @nodoc

class SignInStateSignInLinkSent implements SignInState {
  const SignInStateSignInLinkSent();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStateSignInLinkSent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.signInLinkSent()';
  }
}

/// @nodoc

class SignInStatePasswordResetLinkSent implements SignInState {
  const SignInStatePasswordResetLinkSent();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInStatePasswordResetLinkSent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SignInState.passwordResetLinkSent()';
  }
}

// dart format on
