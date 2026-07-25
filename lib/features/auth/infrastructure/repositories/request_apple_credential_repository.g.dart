// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_apple_credential_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(requestAppleCredentialRepository)
final requestAppleCredentialRepositoryProvider =
    RequestAppleCredentialRepositoryProvider._();

final class RequestAppleCredentialRepositoryProvider
    extends
        $FunctionalProvider<
          RequestAppleCredentialRepository,
          RequestAppleCredentialRepository,
          RequestAppleCredentialRepository
        >
    with $Provider<RequestAppleCredentialRepository> {
  RequestAppleCredentialRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestAppleCredentialRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestAppleCredentialRepositoryHash();

  @$internal
  @override
  $ProviderElement<RequestAppleCredentialRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RequestAppleCredentialRepository create(Ref ref) {
    return requestAppleCredentialRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestAppleCredentialRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestAppleCredentialRepository>(
        value,
      ),
    );
  }
}

String _$requestAppleCredentialRepositoryHash() =>
    r'c62b0a5e52338e84e2cdd687454ba462c0c68b23';
