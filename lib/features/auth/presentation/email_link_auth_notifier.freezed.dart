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

class EmailLinkAuthStateReAuthSucceeded implements EmailLinkAuthState {
  const EmailLinkAuthStateReAuthSucceeded(this.destination);

  final AuthContinueDestination destination;

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

class EmailLinkAuthStateFailed implements EmailLinkAuthState, ErrorState {
  const EmailLinkAuthStateFailed(this.error, this.errorStackTrace);

  final Object error;
  final StackTrace errorStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EmailLinkAuthStateFailed &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.errorStackTrace, errorStackTrace) ||
                other.errorStackTrace == errorStackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(error), errorStackTrace);

  @override
  String toString() {
    return 'EmailLinkAuthState.failed(error: $error, errorStackTrace: $errorStackTrace)';
  }
}

// dart format on
