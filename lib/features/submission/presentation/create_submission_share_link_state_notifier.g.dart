// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_submission_share_link_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateSubmissionShareLinkStateNotifier)
final createSubmissionShareLinkStateProvider =
    CreateSubmissionShareLinkStateNotifierProvider._();

final class CreateSubmissionShareLinkStateNotifierProvider
    extends
        $AsyncNotifierProvider<
          CreateSubmissionShareLinkStateNotifier,
          ({String title, String url})?
        > {
  CreateSubmissionShareLinkStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createSubmissionShareLinkStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$createSubmissionShareLinkStateNotifierHash();

  @$internal
  @override
  CreateSubmissionShareLinkStateNotifier create() =>
      CreateSubmissionShareLinkStateNotifier();
}

String _$createSubmissionShareLinkStateNotifierHash() =>
    r'0b00df54db1b80e53abbb505a39789c5dcd46c02';

abstract class _$CreateSubmissionShareLinkStateNotifier
    extends $AsyncNotifier<({String title, String url})?> {
  FutureOr<({String title, String url})?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<({String title, String url})?>,
              ({String title, String url})?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<({String title, String url})?>,
                ({String title, String url})?
              >,
              AsyncValue<({String title, String url})?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
