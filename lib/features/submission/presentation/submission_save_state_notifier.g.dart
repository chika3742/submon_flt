// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_save_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubmissionSaveStateNotifier)
final submissionSaveStateProvider = SubmissionSaveStateNotifierProvider._();

final class SubmissionSaveStateNotifierProvider
    extends
        $NotifierProvider<
          SubmissionSaveStateNotifier,
          Distinguish<SubmissionSaveState>
        > {
  SubmissionSaveStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submissionSaveStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submissionSaveStateNotifierHash();

  @$internal
  @override
  SubmissionSaveStateNotifier create() => SubmissionSaveStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Distinguish<SubmissionSaveState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Distinguish<SubmissionSaveState>>(
        value,
      ),
    );
  }
}

String _$submissionSaveStateNotifierHash() =>
    r'b0e405b35c36bf2de8f9ee87309ef92e503bcbe7';

abstract class _$SubmissionSaveStateNotifier
    extends $Notifier<Distinguish<SubmissionSaveState>> {
  Distinguish<SubmissionSaveState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Distinguish<SubmissionSaveState>,
              Distinguish<SubmissionSaveState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Distinguish<SubmissionSaveState>,
                Distinguish<SubmissionSaveState>
              >,
              Distinguish<SubmissionSaveState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
