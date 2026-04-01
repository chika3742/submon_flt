// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_share_link_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 共有リンクから提出物データを取得する。

@ProviderFor(submissionShareLink)
final submissionShareLinkProvider = SubmissionShareLinkFamily._();

/// 共有リンクから提出物データを取得する。

final class SubmissionShareLinkProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubmissionShareData?>,
          SubmissionShareData?,
          FutureOr<SubmissionShareData?>
        >
    with
        $FutureModifier<SubmissionShareData?>,
        $FutureProvider<SubmissionShareData?> {
  /// 共有リンクから提出物データを取得する。
  SubmissionShareLinkProvider._({
    required SubmissionShareLinkFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'submissionShareLinkProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$submissionShareLinkHash();

  @override
  String toString() {
    return r'submissionShareLinkProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SubmissionShareData?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubmissionShareData?> create(Ref ref) {
    final argument = this.argument as String;
    return submissionShareLink(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubmissionShareLinkProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submissionShareLinkHash() =>
    r'4642cba4b9ade65947e1a309f31667ed54b0e6df';

/// 共有リンクから提出物データを取得する。

final class SubmissionShareLinkFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubmissionShareData?>, String> {
  SubmissionShareLinkFamily._()
    : super(
        retry: null,
        name: r'submissionShareLinkProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 共有リンクから提出物データを取得する。

  SubmissionShareLinkProvider call(String id) =>
      SubmissionShareLinkProvider._(argument: id, from: this);

  @override
  String toString() => r'submissionShareLinkProvider';
}
