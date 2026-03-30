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

class _GoogleTasksUser implements GoogleTasksUser {
  const _GoogleTasksUser({required this.email});

  @override
  final String email;

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

class GoogleTasksLinkProcessStateFailed
    implements GoogleTasksLinkProcessState, ErrorState {
  const GoogleTasksLinkProcessStateFailed(this.error, this.errorStackTrace);

  final Object error;
  final StackTrace errorStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoogleTasksLinkProcessStateFailed &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.errorStackTrace, errorStackTrace) ||
                other.errorStackTrace == errorStackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(error), errorStackTrace);

  @override
  String toString() {
    return 'GoogleTasksLinkProcessState.failed(error: $error, errorStackTrace: $errorStackTrace)';
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
