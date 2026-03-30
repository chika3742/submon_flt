// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignInStateNotifier)
final signInStateProvider = SignInStateNotifierProvider._();

final class SignInStateNotifierProvider
    extends $NotifierProvider<SignInStateNotifier, SignInState> {
  SignInStateNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'signInStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$signInStateNotifierHash();

  @$internal
  @override
  SignInStateNotifier create() => SignInStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInState>(value),
    );
  }
}

String _$signInStateNotifierHash() =>
    r'111e37f86bb8de4f562d5198bfee159afdd04a44';

abstract class _$SignInStateNotifier extends $Notifier<SignInState> {
  SignInState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SignInState, SignInState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SignInState, SignInState>, SignInState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
