// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Failure {
  String get userFriendlyMessage;
  FailureSeverity get severity;
  Object? get cause;
  StackTrace? get causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Failure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

/// @nodoc

class AuthFailure extends Failure {
  const AuthFailure(
      {required this.userFriendlyMessage,
      required this.severity,
      this.cause,
      this.causeStackTrace})
      : super._();

  @override
  final String userFriendlyMessage;
  @override
  final FailureSeverity severity;
  @override
  final Object? cause;
  @override
  final StackTrace? causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthFailure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

/// @nodoc

class FirestoreReadFailure extends Failure {
  const FirestoreReadFailure(
      {this.userFriendlyMessage = "データの読み込みに失敗しました",
      this.severity = FailureSeverity.unexpected,
      this.cause,
      this.causeStackTrace})
      : super._();

  @override
  @JsonKey()
  final String userFriendlyMessage;
  @override
  @JsonKey()
  final FailureSeverity severity;
  @override
  final Object? cause;
  @override
  final StackTrace? causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FirestoreReadFailure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

/// @nodoc

class FirestoreWriteFailure extends Failure {
  const FirestoreWriteFailure(
      {this.userFriendlyMessage = "データの保存に失敗しました",
      this.severity = FailureSeverity.unexpected,
      this.cause,
      this.causeStackTrace})
      : super._();

  @override
  @JsonKey()
  final String userFriendlyMessage;
  @override
  @JsonKey()
  final FailureSeverity severity;
  @override
  final Object? cause;
  @override
  final StackTrace? causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FirestoreWriteFailure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

/// @nodoc

class FirestorePermissionDeniedFailure extends Failure {
  const FirestorePermissionDeniedFailure(
      {this.userFriendlyMessage = "アクセス権限がありません。サインインし直してください。",
      this.severity = FailureSeverity.expected,
      this.cause,
      this.causeStackTrace})
      : super._();

  @override
  @JsonKey()
  final String userFriendlyMessage;
  @override
  @JsonKey()
  final FailureSeverity severity;
  @override
  final Object? cause;
  @override
  final StackTrace? causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FirestorePermissionDeniedFailure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

/// @nodoc

class TasksAuthFailure extends Failure {
  const TasksAuthFailure(
      {required this.userFriendlyMessage,
      required this.severity,
      this.cause,
      this.causeStackTrace})
      : super._();

  @override
  final String userFriendlyMessage;
  @override
  final FailureSeverity severity;
  @override
  final Object? cause;
  @override
  final StackTrace? causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TasksAuthFailure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

/// @nodoc

class TasksOperationFailure extends Failure {
  const TasksOperationFailure(
      {required this.userFriendlyMessage,
      required this.severity,
      this.cause,
      this.causeStackTrace})
      : super._();

  @override
  final String userFriendlyMessage;
  @override
  final FailureSeverity severity;
  @override
  final Object? cause;
  @override
  final StackTrace? causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TasksOperationFailure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

/// @nodoc

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
      {this.userFriendlyMessage = "エラーが発生しました",
      this.severity = FailureSeverity.unexpected,
      this.cause,
      this.causeStackTrace})
      : super._();

  @override
  @JsonKey()
  final String userFriendlyMessage;
  @override
  @JsonKey()
  final FailureSeverity severity;
  @override
  final Object? cause;
  @override
  final StackTrace? causeStackTrace;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnexpectedFailure &&
            (identical(other.userFriendlyMessage, userFriendlyMessage) ||
                other.userFriendlyMessage == userFriendlyMessage) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other.cause, cause) &&
            (identical(other.causeStackTrace, causeStackTrace) ||
                other.causeStackTrace == causeStackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userFriendlyMessage, severity,
      const DeepCollectionEquality().hash(cause), causeStackTrace);
}

// dart format on
