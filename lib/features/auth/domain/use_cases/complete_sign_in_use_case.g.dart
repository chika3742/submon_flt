// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_sign_in_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(completeSignInUseCase)
final completeSignInUseCaseProvider = CompleteSignInUseCaseProvider._();

final class CompleteSignInUseCaseProvider
    extends
        $FunctionalProvider<
          CompleteSignInUseCase,
          CompleteSignInUseCase,
          CompleteSignInUseCase
        >
    with $Provider<CompleteSignInUseCase> {
  CompleteSignInUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completeSignInUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completeSignInUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteSignInUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompleteSignInUseCase create(Ref ref) {
    return completeSignInUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteSignInUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteSignInUseCase>(value),
    );
  }
}

String _$completeSignInUseCaseHash() =>
    r'3a0ed3ab24e2ecaf3112775295d465f82d2f81ed';
