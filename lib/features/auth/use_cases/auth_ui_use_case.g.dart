// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_ui_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authUiUseCase)
final authUiUseCaseProvider = AuthUiUseCaseProvider._();

final class AuthUiUseCaseProvider
    extends $FunctionalProvider<AuthUiUseCase, AuthUiUseCase, AuthUiUseCase>
    with $Provider<AuthUiUseCase> {
  AuthUiUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authUiUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authUiUseCaseHash();

  @$internal
  @override
  $ProviderElement<AuthUiUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthUiUseCase create(Ref ref) {
    return authUiUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthUiUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthUiUseCase>(value),
    );
  }
}

String _$authUiUseCaseHash() => r'f077b2f00ec356dfaedb5a262b87fe7416b9f8a8';
