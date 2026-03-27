// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_submission_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deleteSubmissionUseCase)
final deleteSubmissionUseCaseProvider = DeleteSubmissionUseCaseProvider._();

final class DeleteSubmissionUseCaseProvider extends $FunctionalProvider<
    DeleteSubmissionUseCase,
    DeleteSubmissionUseCase,
    DeleteSubmissionUseCase> with $Provider<DeleteSubmissionUseCase> {
  DeleteSubmissionUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deleteSubmissionUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deleteSubmissionUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteSubmissionUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteSubmissionUseCase create(Ref ref) {
    return deleteSubmissionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteSubmissionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteSubmissionUseCase>(value),
    );
  }
}

String _$deleteSubmissionUseCaseHash() =>
    r'6012c3c3c610061bf56f3ceafb6e90f7aecded4a';
