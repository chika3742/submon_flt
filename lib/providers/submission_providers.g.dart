// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(submissionRepository)
final submissionRepositoryProvider = SubmissionRepositoryProvider._();

final class SubmissionRepositoryProvider extends $FunctionalProvider<
    SubmissionRepository,
    SubmissionRepository,
    SubmissionRepository> with $Provider<SubmissionRepository> {
  SubmissionRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'submissionRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$submissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubmissionRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    r'1b733da907471c0707c7be9fcbf16c92fa55142b';

@ProviderFor(undoneSubmissions)
final undoneSubmissionsProvider = UndoneSubmissionsProvider._();

final class UndoneSubmissionsProvider extends $FunctionalProvider<
        AsyncValue<List<Submission>>,
        List<Submission>,
        Stream<List<Submission>>>
    with $FutureModifier<List<Submission>>, $StreamProvider<List<Submission>> {
  UndoneSubmissionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'undoneSubmissionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$undoneSubmissionsHash();

  @$internal
  @override
  $StreamProviderElement<List<Submission>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Submission>> create(Ref ref) {
    return undoneSubmissions(ref);
  }
}

String _$undoneSubmissionsHash() => r'2b36bd02e475d3725b7d7c441665a64f9614a9fc';

@ProviderFor(doneSubmissions)
final doneSubmissionsProvider = DoneSubmissionsProvider._();

final class DoneSubmissionsProvider extends $FunctionalProvider<
        AsyncValue<List<Submission>>,
        List<Submission>,
        Stream<List<Submission>>>
    with $FutureModifier<List<Submission>>, $StreamProvider<List<Submission>> {
  DoneSubmissionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'doneSubmissionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$doneSubmissionsHash();

  @$internal
  @override
  $StreamProviderElement<List<Submission>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Submission>> create(Ref ref) {
    return doneSubmissions(ref);
  }
}

String _$doneSubmissionsHash() => r'0c26fa537eb5903ab0132784fe47f62b2309b39c';

@ProviderFor(submission)
final submissionProvider = SubmissionFamily._();

final class SubmissionProvider extends $FunctionalProvider<
        AsyncValue<Submission?>, Submission?, Stream<Submission?>>
    with $FutureModifier<Submission?>, $StreamProvider<Submission?> {
  SubmissionProvider._(
      {required SubmissionFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'submissionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$submissionHash();

  @override
  String toString() {
    return r'submissionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Submission?> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Submission?> create(Ref ref) {
    final argument = this.argument as int;
    return submission(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SubmissionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submissionHash() => r'cd017edad9b29765450d2b1e41da5d1aceae8364';

final class SubmissionFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Submission?>, int> {
  SubmissionFamily._()
      : super(
          retry: null,
          name: r'submissionProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SubmissionProvider call(
    int id,
  ) =>
      SubmissionProvider._(argument: id, from: this);

  @override
  String toString() => r'submissionProvider';
}
