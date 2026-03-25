// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_action_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthActionNotifier)
final authActionProvider = AuthActionNotifierProvider._();

final class AuthActionNotifierProvider
    extends $NotifierProvider<AuthActionNotifier, AuthActionState> {
  AuthActionNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authActionProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authActionNotifierHash();

  @$internal
  @override
  AuthActionNotifier create() => AuthActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthActionState>(value),
    );
  }
}

String _$authActionNotifierHash() =>
    r'a323ed32a4d71a5538555ae3c5e64ea0638bebec';

abstract class _$AuthActionNotifier extends $Notifier<AuthActionState> {
  AuthActionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthActionState, AuthActionState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AuthActionState, AuthActionState>,
        AuthActionState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
