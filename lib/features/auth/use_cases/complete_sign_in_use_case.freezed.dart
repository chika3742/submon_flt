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

class _CompleteSignInResult implements CompleteSignInResult {
  const _CompleteSignInResult(
      {required this.newUser, required this.notificationPermissionDenied});

  @override
  final bool newUser;
  @override
  final bool notificationPermissionDenied;

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

// dart format on
