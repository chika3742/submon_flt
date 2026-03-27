// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_tasks_link_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectedGoogleTasksUser)
final connectedGoogleTasksUserProvider = ConnectedGoogleTasksUserProvider._();

final class ConnectedGoogleTasksUserProvider extends $FunctionalProvider<
        AsyncValue<GoogleTasksUser?>,
        GoogleTasksUser?,
        FutureOr<GoogleTasksUser?>>
    with $FutureModifier<GoogleTasksUser?>, $FutureProvider<GoogleTasksUser?> {
  ConnectedGoogleTasksUserProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'connectedGoogleTasksUserProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$connectedGoogleTasksUserHash();

  @$internal
  @override
  $FutureProviderElement<GoogleTasksUser?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GoogleTasksUser?> create(Ref ref) {
    return connectedGoogleTasksUser(ref);
  }
}

String _$connectedGoogleTasksUserHash() =>
    r'd38e3c6fa0330b6f1231e2fd50e4b0a2ee2912f0';

@ProviderFor(GoogleTasksLinkProcessStateNotifier)
final googleTasksLinkProcessStateProvider =
    GoogleTasksLinkProcessStateNotifierProvider._();

final class GoogleTasksLinkProcessStateNotifierProvider
    extends $NotifierProvider<GoogleTasksLinkProcessStateNotifier,
        GoogleTasksLinkProcessState> {
  GoogleTasksLinkProcessStateNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'googleTasksLinkProcessStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() =>
      _$googleTasksLinkProcessStateNotifierHash();

  @$internal
  @override
  GoogleTasksLinkProcessStateNotifier create() =>
      GoogleTasksLinkProcessStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleTasksLinkProcessState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleTasksLinkProcessState>(value),
    );
  }
}

String _$googleTasksLinkProcessStateNotifierHash() =>
    r'82f119400b25b172f673368d7a0261b7464082ba';

abstract class _$GoogleTasksLinkProcessStateNotifier
    extends $Notifier<GoogleTasksLinkProcessState> {
  GoogleTasksLinkProcessState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<GoogleTasksLinkProcessState, GoogleTasksLinkProcessState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GoogleTasksLinkProcessState, GoogleTasksLinkProcessState>,
        GoogleTasksLinkProcessState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
