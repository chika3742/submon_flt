// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_continue_destination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthContinueDestination {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthContinueDestination);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthContinueDestination()';
  }
}

/// @nodoc
class $AuthContinueDestinationCopyWith<$Res> {
  $AuthContinueDestinationCopyWith(
      AuthContinueDestination _, $Res Function(AuthContinueDestination) __);
}

/// Adds pattern-matching-related methods to [AuthContinueDestination].
extension AuthContinueDestinationPatterns on AuthContinueDestination {
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
    TResult Function(AuthContinueDestinationChangeEmail value)? changeEmail,
    TResult Function(AuthContinueDestinationDeleteAccount value)? deleteAccount,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthContinueDestinationChangeEmail() when changeEmail != null:
        return changeEmail(_that);
      case AuthContinueDestinationDeleteAccount() when deleteAccount != null:
        return deleteAccount(_that);
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
    required TResult Function(AuthContinueDestinationChangeEmail value)
        changeEmail,
    required TResult Function(AuthContinueDestinationDeleteAccount value)
        deleteAccount,
  }) {
    final _that = this;
    switch (_that) {
      case AuthContinueDestinationChangeEmail():
        return changeEmail(_that);
      case AuthContinueDestinationDeleteAccount():
        return deleteAccount(_that);
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
    TResult? Function(AuthContinueDestinationChangeEmail value)? changeEmail,
    TResult? Function(AuthContinueDestinationDeleteAccount value)?
        deleteAccount,
  }) {
    final _that = this;
    switch (_that) {
      case AuthContinueDestinationChangeEmail() when changeEmail != null:
        return changeEmail(_that);
      case AuthContinueDestinationDeleteAccount() when deleteAccount != null:
        return deleteAccount(_that);
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
    TResult Function(String newEmail)? changeEmail,
    TResult Function()? deleteAccount,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthContinueDestinationChangeEmail() when changeEmail != null:
        return changeEmail(_that.newEmail);
      case AuthContinueDestinationDeleteAccount() when deleteAccount != null:
        return deleteAccount();
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
    required TResult Function(String newEmail) changeEmail,
    required TResult Function() deleteAccount,
  }) {
    final _that = this;
    switch (_that) {
      case AuthContinueDestinationChangeEmail():
        return changeEmail(_that.newEmail);
      case AuthContinueDestinationDeleteAccount():
        return deleteAccount();
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
    TResult? Function(String newEmail)? changeEmail,
    TResult? Function()? deleteAccount,
  }) {
    final _that = this;
    switch (_that) {
      case AuthContinueDestinationChangeEmail() when changeEmail != null:
        return changeEmail(_that.newEmail);
      case AuthContinueDestinationDeleteAccount() when deleteAccount != null:
        return deleteAccount();
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthContinueDestinationChangeEmail extends AuthContinueDestination {
  const AuthContinueDestinationChangeEmail({required this.newEmail})
      : super._();

  final String newEmail;

  /// Create a copy of AuthContinueDestination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthContinueDestinationChangeEmailCopyWith<
          AuthContinueDestinationChangeEmail>
      get copyWith => _$AuthContinueDestinationChangeEmailCopyWithImpl<
          AuthContinueDestinationChangeEmail>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthContinueDestinationChangeEmail &&
            (identical(other.newEmail, newEmail) ||
                other.newEmail == newEmail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newEmail);

  @override
  String toString() {
    return 'AuthContinueDestination.changeEmail(newEmail: $newEmail)';
  }
}

/// @nodoc
abstract mixin class $AuthContinueDestinationChangeEmailCopyWith<$Res>
    implements $AuthContinueDestinationCopyWith<$Res> {
  factory $AuthContinueDestinationChangeEmailCopyWith(
          AuthContinueDestinationChangeEmail value,
          $Res Function(AuthContinueDestinationChangeEmail) _then) =
      _$AuthContinueDestinationChangeEmailCopyWithImpl;
  @useResult
  $Res call({String newEmail});
}

/// @nodoc
class _$AuthContinueDestinationChangeEmailCopyWithImpl<$Res>
    implements $AuthContinueDestinationChangeEmailCopyWith<$Res> {
  _$AuthContinueDestinationChangeEmailCopyWithImpl(this._self, this._then);

  final AuthContinueDestinationChangeEmail _self;
  final $Res Function(AuthContinueDestinationChangeEmail) _then;

  /// Create a copy of AuthContinueDestination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? newEmail = null,
  }) {
    return _then(AuthContinueDestinationChangeEmail(
      newEmail: null == newEmail
          ? _self.newEmail
          : newEmail // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthContinueDestinationDeleteAccount extends AuthContinueDestination {
  const AuthContinueDestinationDeleteAccount() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthContinueDestinationDeleteAccount);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthContinueDestination.deleteAccount()';
  }
}

// dart format on
