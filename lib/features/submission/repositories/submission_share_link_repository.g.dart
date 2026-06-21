// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_share_link_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches submission data from a share link.
///
/// The Firestore-to-domain conversion (e.g. `Timestamp` -> [DateTime]) is done
/// here so [SubmissionShareData] stays persistence-independent.

@ProviderFor(submissionShareLink)
final submissionShareLinkProvider = SubmissionShareLinkFamily._();

/// Fetches submission data from a share link.
///
/// The Firestore-to-domain conversion (e.g. `Timestamp` -> [DateTime]) is done
/// here so [SubmissionShareData] stays persistence-independent.

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
  /// Fetches submission data from a share link.
  ///
  /// The Firestore-to-domain conversion (e.g. `Timestamp` -> [DateTime]) is done
  /// here so [SubmissionShareData] stays persistence-independent.
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
    r'db5ba36eafe5c987be21999ec0ae489cf724a348';

/// Fetches submission data from a share link.
///
/// The Firestore-to-domain conversion (e.g. `Timestamp` -> [DateTime]) is done
/// here so [SubmissionShareData] stays persistence-independent.

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

  /// Fetches submission data from a share link.
  ///
  /// The Firestore-to-domain conversion (e.g. `Timestamp` -> [DateTime]) is done
  /// here so [SubmissionShareData] stays persistence-independent.

  SubmissionShareLinkProvider call(String id) =>
      SubmissionShareLinkProvider._(argument: id, from: this);

  @override
  String toString() => r'submissionShareLinkProvider';
}
