// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functions_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(functionsService)
final functionsServiceProvider = FunctionsServiceProvider._();

final class FunctionsServiceProvider
    extends
        $FunctionalProvider<
          FunctionsService,
          FunctionsService,
          FunctionsService
        >
    with $Provider<FunctionsService> {
  FunctionsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'functionsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$functionsServiceHash();

  @$internal
  @override
  $ProviderElement<FunctionsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FunctionsService create(Ref ref) {
    return functionsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FunctionsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FunctionsService>(value),
    );
  }
}

String _$functionsServiceHash() => r'434ad8a8b459e5c878869f0cd4ba5c172881647c';
