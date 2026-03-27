// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_auth_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(socialAuthUseCase)
final socialAuthUseCaseProvider = SocialAuthUseCaseProvider._();

final class SocialAuthUseCaseProvider extends $FunctionalProvider<
    SocialAuthUseCase,
    SocialAuthUseCase,
    SocialAuthUseCase> with $Provider<SocialAuthUseCase> {
  SocialAuthUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'socialAuthUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$socialAuthUseCaseHash();

  @$internal
  @override
  $ProviderElement<SocialAuthUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SocialAuthUseCase create(Ref ref) {
    return socialAuthUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocialAuthUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocialAuthUseCase>(value),
    );
  }
}

String _$socialAuthUseCaseHash() => r'19237a1f1e68cf71b68c9c26aa3a124620878460';
