// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_by_mode_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(signInByModeUseCase)
final signInByModeUseCaseProvider = SignInByModeUseCaseProvider._();

final class SignInByModeUseCaseProvider
    extends
        $FunctionalProvider<
          SignInByModeUseCase,
          SignInByModeUseCase,
          SignInByModeUseCase
        >
    with $Provider<SignInByModeUseCase> {
  SignInByModeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInByModeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInByModeUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInByModeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInByModeUseCase create(Ref ref) {
    return signInByModeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInByModeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInByModeUseCase>(value),
    );
  }
}

String _$signInByModeUseCaseHash() =>
    r'ed222d32a81763ea5ff5bab27eb8bb3636f89c31';
