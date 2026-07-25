// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_google_credential_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(requestGoogleCredentialRepository)
final requestGoogleCredentialRepositoryProvider =
    RequestGoogleCredentialRepositoryProvider._();

final class RequestGoogleCredentialRepositoryProvider
    extends
        $FunctionalProvider<
          RequestGoogleCredentialRepository,
          RequestGoogleCredentialRepository,
          RequestGoogleCredentialRepository
        >
    with $Provider<RequestGoogleCredentialRepository> {
  RequestGoogleCredentialRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestGoogleCredentialRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$requestGoogleCredentialRepositoryHash();

  @$internal
  @override
  $ProviderElement<RequestGoogleCredentialRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RequestGoogleCredentialRepository create(Ref ref) {
    return requestGoogleCredentialRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestGoogleCredentialRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestGoogleCredentialRepository>(
        value,
      ),
    );
  }
}

String _$requestGoogleCredentialRepositoryHash() =>
    r'dc664d737fd56da5d52adcf2eb77af788716094f';
