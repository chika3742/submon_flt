// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'undone_digestives_with_submission.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 未完了の Digestive リストを Submission 情報と結合して Stream で返す。

@ProviderFor(undoneDigestivesWithSubmission)
final undoneDigestivesWithSubmissionProvider =
    UndoneDigestivesWithSubmissionProvider._();

/// 未完了の Digestive リストを Submission 情報と結合して Stream で返す。

final class UndoneDigestivesWithSubmissionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DigestiveWithSubmission>>,
          List<DigestiveWithSubmission>,
          Stream<List<DigestiveWithSubmission>>
        >
    with
        $FutureModifier<List<DigestiveWithSubmission>>,
        $StreamProvider<List<DigestiveWithSubmission>> {
  /// 未完了の Digestive リストを Submission 情報と結合して Stream で返す。
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<DigestiveWithSubmission>> create(Ref ref) {
    return undoneDigestivesWithSubmission(ref);
  }
}

String _$undoneDigestivesWithSubmissionHash() =>
    r'c71b098c5df5ff9b42ed69725147da4e6249eb64';
