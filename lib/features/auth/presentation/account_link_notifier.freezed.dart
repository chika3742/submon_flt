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

// dart format on
