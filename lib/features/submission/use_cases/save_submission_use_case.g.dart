// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_submission_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(saveSubmissionUseCase)
final saveSubmissionUseCaseProvider = SaveSubmissionUseCaseProvider._();

final class SaveSubmissionUseCaseProvider extends $FunctionalProvider<
    SaveSubmissionUseCase,
    SaveSubmissionUseCase,
    SaveSubmissionUseCase> with $Provider<SaveSubmissionUseCase> {
  SaveSubmissionUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'saveSubmissionUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$saveSubmissionUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveSubmissionUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SaveSubmissionUseCase create(Ref ref) {
    return saveSubmissionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveSubmissionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveSubmissionUseCase>(value),
    );
  }
}

String _$saveSubmissionUseCaseHash() =>
    r'8dc26ecf66d46bde5839fe47ff1cb342fee6eb8b';
