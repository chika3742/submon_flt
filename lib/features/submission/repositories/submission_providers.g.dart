// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submissionRepository)
final submissionRepositoryProvider = SubmissionRepositoryProvider._();

final class SubmissionRepositoryProvider
    extends
        $FunctionalProvider<
          SubmissionRepository,
          SubmissionRepository,
          SubmissionRepository
        >
    with $Provider<SubmissionRepository> {
  SubmissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submissionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubmissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmissionRepository create(Ref ref) {
    return submissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmissionRepository>(value),
    );
  }
}

String _$submissionRepositoryHash() =>
    r'e9786fdbe07473ce0ed310bdacc1f283d8ad96f7';
