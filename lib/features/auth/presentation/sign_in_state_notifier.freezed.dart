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

class SignInStateSignInSucceeded implements SignInState {
  const SignInStateSignInSucceeded(this.completionResult);

  final CompleteSignInResult completionResult;

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
