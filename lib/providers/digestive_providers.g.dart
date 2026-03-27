// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digestive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(digestiveRepository)
final digestiveRepositoryProvider = DigestiveRepositoryProvider._();

final class DigestiveRepositoryProvider extends $FunctionalProvider<
    DigestiveRepository,
    DigestiveRepository,
    DigestiveRepository> with $Provider<DigestiveRepository> {
  DigestiveRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'digestiveRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$digestiveRepositoryHash();

  @$internal
  @override
  $ProviderElement<DigestiveRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DigestiveRepository create(Ref ref) {
    return digestiveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DigestiveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DigestiveRepository>(value),
    );
  }
}

String _$digestiveRepositoryHash() =>
    r'd3737ebbec76e384de6bd19b250b1c5792d8c7a4';

@ProviderFor(undoneDigestives)
final undoneDigestivesProvider = UndoneDigestivesProvider._();

final class UndoneDigestivesProvider extends $FunctionalProvider<
        AsyncValue<List<Digestive>>, List<Digestive>, Stream<List<Digestive>>>
    with $FutureModifier<List<Digestive>>, $StreamProvider<List<Digestive>> {
  UndoneDigestivesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'undoneDigestivesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$undoneDigestivesHash();

  @$internal
  @override
  $StreamProviderElement<List<Digestive>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Digestive>> create(Ref ref) {
    return undoneDigestives(ref);
  }
}

String _$undoneDigestivesHash() => r'4e4bdc02d745a862d854383840ca1806072f2b5a';

@ProviderFor(doneDigestives)
final doneDigestivesProvider = DoneDigestivesProvider._();

final class DoneDigestivesProvider extends $FunctionalProvider<
        AsyncValue<List<Digestive>>, List<Digestive>, Stream<List<Digestive>>>
    with $FutureModifier<List<Digestive>>, $StreamProvider<List<Digestive>> {
  DoneDigestivesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'doneDigestivesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$doneDigestivesHash();

  @$internal
  @override
  $StreamProviderElement<List<Digestive>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Digestive>> create(Ref ref) {
    return doneDigestives(ref);
  }
}

String _$doneDigestivesHash() => r'590094234a56dbd06be864f4894f3f250d19d9a5';

@ProviderFor(digestivesBySubmission)
final digestivesBySubmissionProvider = DigestivesBySubmissionFamily._();

final class DigestivesBySubmissionProvider extends $FunctionalProvider<
        AsyncValue<List<Digestive>>, List<Digestive>, Stream<List<Digestive>>>
    with $FutureModifier<List<Digestive>>, $StreamProvider<List<Digestive>> {
  DigestivesBySubmissionProvider._(
      {required DigestivesBySubmissionFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'digestivesBySubmissionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$digestivesBySubmissionHash();

  @override
  String toString() {
    return r'digestivesBySubmissionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Digestive>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Digestive>> create(Ref ref) {
    final argument = this.argument as int;
    return digestivesBySubmission(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DigestivesBySubmissionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$digestivesBySubmissionHash() =>
    r'339151428f324d7d82365b57749076cf7cb5fbfa';

final class DigestivesBySubmissionFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Digestive>>, int> {
  DigestivesBySubmissionFamily._()
      : super(
          retry: null,
          name: r'digestivesBySubmissionProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  DigestivesBySubmissionProvider call(
    int submissionId,
  ) =>
      DigestivesBySubmissionProvider._(argument: submissionId, from: this);

  @override
  String toString() => r'digestivesBySubmissionProvider';
}

/// Digestive リストを Submission 情報と結合して Stream で返す。

@ProviderFor(undoneDigestivesWithSubmission)
final undoneDigestivesWithSubmissionProvider =
    UndoneDigestivesWithSubmissionProvider._();

/// Digestive リストを Submission 情報と結合して Stream で返す。

final class UndoneDigestivesWithSubmissionProvider extends $FunctionalProvider<
        AsyncValue<List<DigestiveWithSubmission>>,
        List<DigestiveWithSubmission>,
        Stream<List<DigestiveWithSubmission>>>
    with
        $FutureModifier<List<DigestiveWithSubmission>>,
        $StreamProvider<List<DigestiveWithSubmission>> {
  /// Digestive リストを Submission 情報と結合して Stream で返す。
  UndoneDigestivesWithSubmissionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'undoneDigestivesWithSubmissionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$undoneDigestivesWithSubmissionHash();

  @$internal
  @override
  $StreamProviderElement<List<DigestiveWithSubmission>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<DigestiveWithSubmission>> create(Ref ref) {
    return undoneDigestivesWithSubmission(ref);
  }
}

String _$undoneDigestivesWithSubmissionHash() =>
    r'c71b098c5df5ff9b42ed69725147da4e6249eb64';
