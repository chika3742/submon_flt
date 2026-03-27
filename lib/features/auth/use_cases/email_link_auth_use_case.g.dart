// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_link_auth_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(emailLinkAuthUseCase)
final emailLinkAuthUseCaseProvider = EmailLinkAuthUseCaseProvider._();

final class EmailLinkAuthUseCaseProvider extends $FunctionalProvider<
    EmailLinkAuthUseCase,
    EmailLinkAuthUseCase,
    EmailLinkAuthUseCase> with $Provider<EmailLinkAuthUseCase> {
  EmailLinkAuthUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'emailLinkAuthUseCaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$emailLinkAuthUseCaseHash();

  @$internal
  @override
  $ProviderElement<EmailLinkAuthUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmailLinkAuthUseCase create(Ref ref) {
    return emailLinkAuthUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailLinkAuthUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailLinkAuthUseCase>(value),
    );
  }
}

String _$emailLinkAuthUseCaseHash() =>
    r'b4922320dba89c98cd566a3d6f47545f455a42d3';
