// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_link_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LinkedProviderInfo {
  Set<AuthProvider> get linkedProviders;
  bool get hasEmailProvider;

  /// Create a copy of LinkedProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LinkedProviderInfoCopyWith<LinkedProviderInfo> get copyWith =>
      _$LinkedProviderInfoCopyWithImpl<LinkedProviderInfo>(
          this as LinkedProviderInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LinkedProviderInfo &&
            const DeepCollectionEquality()
                .equals(other.linkedProviders, linkedProviders) &&
            (identical(other.hasEmailProvider, hasEmailProvider) ||
                other.hasEmailProvider == hasEmailProvider));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(linkedProviders), hasEmailProvider);

  @override
  String toString() {
    return 'LinkedProviderInfo(linkedProviders: $linkedProviders, hasEmailProvider: $hasEmailProvider)';
  }
}

/// @nodoc
abstract mixin class $LinkedProviderInfoCopyWith<$Res> {
  factory $LinkedProviderInfoCopyWith(
          LinkedProviderInfo value, $Res Function(LinkedProviderInfo) _then) =
      _$LinkedProviderInfoCopyWithImpl;
  @useResult
  $Res call({Set<AuthProvider> linkedProviders, bool hasEmailProvider});
}

/// @nodoc
class _$LinkedProviderInfoCopyWithImpl<$Res>
    implements $LinkedProviderInfoCopyWith<$Res> {
  _$LinkedProviderInfoCopyWithImpl(this._self, this._then);

  final LinkedProviderInfo _self;
  final $Res Function(LinkedProviderInfo) _then;

  /// Create a copy of LinkedProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? linkedProviders = null,
    Object? hasEmailProvider = null,
  }) {
    return _then(_self.copyWith(
      linkedProviders: null == linkedProviders
          ? _self.linkedProviders
          : linkedProviders // ignore: cast_nullable_to_non_nullable
              as Set<AuthProvider>,
      hasEmailProvider: null == hasEmailProvider
          ? _self.hasEmailProvider
          : hasEmailProvider // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LinkedProviderInfo].
extension LinkedProviderInfoPatterns on LinkedProviderInfo {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LinkedProviderInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LinkedProviderInfo() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_LinkedProviderInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LinkedProviderInfo():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LinkedProviderInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LinkedProviderInfo() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Set<AuthProvider> linkedProviders, bool hasEmailProvider)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LinkedProviderInfo() when $default != null:
        return $default(_that.linkedProviders, _that.hasEmailProvider);
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
  TResult when<TResult extends Object?>(
    TResult Function(Set<AuthProvider> linkedProviders, bool hasEmailProvider)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LinkedProviderInfo():
        return $default(_that.linkedProviders, _that.hasEmailProvider);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(Set<AuthProvider> linkedProviders, bool hasEmailProvider)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LinkedProviderInfo() when $default != null:
        return $default(_that.linkedProviders, _that.hasEmailProvider);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LinkedProviderInfo implements LinkedProviderInfo {
  const _LinkedProviderInfo(
      {required final Set<AuthProvider> linkedProviders,
      required this.hasEmailProvider})
      : _linkedProviders = linkedProviders;

  final Set<AuthProvider> _linkedProviders;
  @override
  Set<AuthProvider> get linkedProviders {
    if (_linkedProviders is EqualUnmodifiableSetView) return _linkedProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_linkedProviders);
  }

  @override
  final bool hasEmailProvider;

  /// Create a copy of LinkedProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LinkedProviderInfoCopyWith<_LinkedProviderInfo> get copyWith =>
      __$LinkedProviderInfoCopyWithImpl<_LinkedProviderInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LinkedProviderInfo &&
            const DeepCollectionEquality()
                .equals(other._linkedProviders, _linkedProviders) &&
            (identical(other.hasEmailProvider, hasEmailProvider) ||
                other.hasEmailProvider == hasEmailProvider));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_linkedProviders), hasEmailProvider);

  @override
  String toString() {
    return 'LinkedProviderInfo(linkedProviders: $linkedProviders, hasEmailProvider: $hasEmailProvider)';
  }
}

/// @nodoc
abstract mixin class _$LinkedProviderInfoCopyWith<$Res>
    implements $LinkedProviderInfoCopyWith<$Res> {
  factory _$LinkedProviderInfoCopyWith(
          _LinkedProviderInfo value, $Res Function(_LinkedProviderInfo) _then) =
      __$LinkedProviderInfoCopyWithImpl;
  @override
  @useResult
  $Res call({Set<AuthProvider> linkedProviders, bool hasEmailProvider});
}

/// @nodoc
class __$LinkedProviderInfoCopyWithImpl<$Res>
    implements _$LinkedProviderInfoCopyWith<$Res> {
  __$LinkedProviderInfoCopyWithImpl(this._self, this._then);

  final _LinkedProviderInfo _self;
  final $Res Function(_LinkedProviderInfo) _then;

  /// Create a copy of LinkedProviderInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? linkedProviders = null,
    Object? hasEmailProvider = null,
  }) {
    return _then(_LinkedProviderInfo(
      linkedProviders: null == linkedProviders
          ? _self._linkedProviders
          : linkedProviders // ignore: cast_nullable_to_non_nullable
              as Set<AuthProvider>,
      hasEmailProvider: null == hasEmailProvider
          ? _self.hasEmailProvider
          : hasEmailProvider // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$AccountLinkState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AccountLinkState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountLinkState()';
  }
}

/// @nodoc
class $AccountLinkStateCopyWith<$Res> {
  $AccountLinkStateCopyWith(
      AccountLinkState _, $Res Function(AccountLinkState) __);
}

/// Adds pattern-matching-related methods to [AccountLinkState].
extension AccountLinkStatePatterns on AccountLinkState {
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
    TResult Function(AccountLinkIdle value)? idle,
    TResult Function(AccountLinkProcessing value)? processing,
    TResult Function(AccountLinkLinkSucceeded value)? linkSucceeded,
    TResult Function(AccountLinkUnlinkSucceeded value)? unlinkSucceeded,
    TResult Function(AccountLinkFailed value)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AccountLinkIdle() when idle != null:
        return idle(_that);
      case AccountLinkProcessing() when processing != null:
        return processing(_that);
      case AccountLinkLinkSucceeded() when linkSucceeded != null:
        return linkSucceeded(_that);
      case AccountLinkUnlinkSucceeded() when unlinkSucceeded != null:
        return unlinkSucceeded(_that);
      case AccountLinkFailed() when failed != null:
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
    required TResult Function(AccountLinkIdle value) idle,
    required TResult Function(AccountLinkProcessing value) processing,
    required TResult Function(AccountLinkLinkSucceeded value) linkSucceeded,
    required TResult Function(AccountLinkUnlinkSucceeded value) unlinkSucceeded,
    required TResult Function(AccountLinkFailed value) failed,
  }) {
    final _that = this;
    switch (_that) {
      case AccountLinkIdle():
        return idle(_that);
      case AccountLinkProcessing():
        return processing(_that);
      case AccountLinkLinkSucceeded():
        return linkSucceeded(_that);
      case AccountLinkUnlinkSucceeded():
        return unlinkSucceeded(_that);
      case AccountLinkFailed():
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
    TResult? Function(AccountLinkIdle value)? idle,
    TResult? Function(AccountLinkProcessing value)? processing,
    TResult? Function(AccountLinkLinkSucceeded value)? linkSucceeded,
    TResult? Function(AccountLinkUnlinkSucceeded value)? unlinkSucceeded,
    TResult? Function(AccountLinkFailed value)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case AccountLinkIdle() when idle != null:
        return idle(_that);
      case AccountLinkProcessing() when processing != null:
        return processing(_that);
      case AccountLinkLinkSucceeded() when linkSucceeded != null:
        return linkSucceeded(_that);
      case AccountLinkUnlinkSucceeded() when unlinkSucceeded != null:
        return unlinkSucceeded(_that);
      case AccountLinkFailed() when failed != null:
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
    TResult Function(AuthProvider processingProvider)? processing,
    TResult Function()? linkSucceeded,
    TResult Function()? unlinkSucceeded,
    TResult Function(Object error)? failed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AccountLinkIdle() when idle != null:
        return idle();
      case AccountLinkProcessing() when processing != null:
        return processing(_that.processingProvider);
      case AccountLinkLinkSucceeded() when linkSucceeded != null:
        return linkSucceeded();
      case AccountLinkUnlinkSucceeded() when unlinkSucceeded != null:
        return unlinkSucceeded();
      case AccountLinkFailed() when failed != null:
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
    required TResult Function(AuthProvider processingProvider) processing,
    required TResult Function() linkSucceeded,
    required TResult Function() unlinkSucceeded,
    required TResult Function(Object error) failed,
  }) {
    final _that = this;
    switch (_that) {
      case AccountLinkIdle():
        return idle();
      case AccountLinkProcessing():
        return processing(_that.processingProvider);
      case AccountLinkLinkSucceeded():
        return linkSucceeded();
      case AccountLinkUnlinkSucceeded():
        return unlinkSucceeded();
      case AccountLinkFailed():
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
    TResult? Function(AuthProvider processingProvider)? processing,
    TResult? Function()? linkSucceeded,
    TResult? Function()? unlinkSucceeded,
    TResult? Function(Object error)? failed,
  }) {
    final _that = this;
    switch (_that) {
      case AccountLinkIdle() when idle != null:
        return idle();
      case AccountLinkProcessing() when processing != null:
        return processing(_that.processingProvider);
      case AccountLinkLinkSucceeded() when linkSucceeded != null:
        return linkSucceeded();
      case AccountLinkUnlinkSucceeded() when unlinkSucceeded != null:
        return unlinkSucceeded();
      case AccountLinkFailed() when failed != null:
        return failed(_that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AccountLinkIdle implements AccountLinkState {
  const AccountLinkIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AccountLinkIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountLinkState.idle()';
  }
}

/// @nodoc

class AccountLinkProcessing implements AccountLinkState {
  const AccountLinkProcessing({required this.processingProvider});

  final AuthProvider processingProvider;

  /// Create a copy of AccountLinkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountLinkProcessingCopyWith<AccountLinkProcessing> get copyWith =>
      _$AccountLinkProcessingCopyWithImpl<AccountLinkProcessing>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountLinkProcessing &&
            (identical(other.processingProvider, processingProvider) ||
                other.processingProvider == processingProvider));
  }

  @override
  int get hashCode => Object.hash(runtimeType, processingProvider);

  @override
  String toString() {
    return 'AccountLinkState.processing(processingProvider: $processingProvider)';
  }
}

/// @nodoc
abstract mixin class $AccountLinkProcessingCopyWith<$Res>
    implements $AccountLinkStateCopyWith<$Res> {
  factory $AccountLinkProcessingCopyWith(AccountLinkProcessing value,
          $Res Function(AccountLinkProcessing) _then) =
      _$AccountLinkProcessingCopyWithImpl;
  @useResult
  $Res call({AuthProvider processingProvider});
}

/// @nodoc
class _$AccountLinkProcessingCopyWithImpl<$Res>
    implements $AccountLinkProcessingCopyWith<$Res> {
  _$AccountLinkProcessingCopyWithImpl(this._self, this._then);

  final AccountLinkProcessing _self;
  final $Res Function(AccountLinkProcessing) _then;

  /// Create a copy of AccountLinkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? processingProvider = null,
  }) {
    return _then(AccountLinkProcessing(
      processingProvider: null == processingProvider
          ? _self.processingProvider
          : processingProvider // ignore: cast_nullable_to_non_nullable
              as AuthProvider,
    ));
  }
}

/// @nodoc

class AccountLinkLinkSucceeded implements AccountLinkState {
  const AccountLinkLinkSucceeded();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AccountLinkLinkSucceeded);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountLinkState.linkSucceeded()';
  }
}

/// @nodoc

class AccountLinkUnlinkSucceeded implements AccountLinkState {
  const AccountLinkUnlinkSucceeded();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountLinkUnlinkSucceeded);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountLinkState.unlinkSucceeded()';
  }
}

/// @nodoc

class AccountLinkFailed implements AccountLinkState {
  const AccountLinkFailed(this.error);

  final Object error;

  /// Create a copy of AccountLinkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountLinkFailedCopyWith<AccountLinkFailed> get copyWith =>
      _$AccountLinkFailedCopyWithImpl<AccountLinkFailed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountLinkFailed &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(error));

  @override
  String toString() {
    return 'AccountLinkState.failed(error: $error)';
  }
}

/// @nodoc
abstract mixin class $AccountLinkFailedCopyWith<$Res>
    implements $AccountLinkStateCopyWith<$Res> {
  factory $AccountLinkFailedCopyWith(
          AccountLinkFailed value, $Res Function(AccountLinkFailed) _then) =
      _$AccountLinkFailedCopyWithImpl;
  @useResult
  $Res call({Object error});
}

/// @nodoc
class _$AccountLinkFailedCopyWithImpl<$Res>
    implements $AccountLinkFailedCopyWith<$Res> {
  _$AccountLinkFailedCopyWithImpl(this._self, this._then);

  final AccountLinkFailed _self;
  final $Res Function(AccountLinkFailed) _then;

  /// Create a copy of AccountLinkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(AccountLinkFailed(
      null == error ? _self.error : error,
    ));
  }
}

// dart format on
