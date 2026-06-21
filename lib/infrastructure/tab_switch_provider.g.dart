// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_switch_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the [StreamController] that carries [TabSwitchRequest]s.
///
/// Routes tab-switch requests through Riverpod instead of an out-of-band global
/// singleton. [fire] publishes a request and the exposed stream is consumed
/// (via `ref.listen`) by the home page.

@ProviderFor(TabSwitch)
final tabSwitchProvider = TabSwitchProvider._();

/// Holds the [StreamController] that carries [TabSwitchRequest]s.
///
/// Routes tab-switch requests through Riverpod instead of an out-of-band global
/// singleton. [fire] publishes a request and the exposed stream is consumed
/// (via `ref.listen`) by the home page.
final class TabSwitchProvider
    extends $StreamNotifierProvider<TabSwitch, TabSwitchRequest> {
  /// Holds the [StreamController] that carries [TabSwitchRequest]s.
  ///
  /// Routes tab-switch requests through Riverpod instead of an out-of-band global
  /// singleton. [fire] publishes a request and the exposed stream is consumed
  /// (via `ref.listen`) by the home page.
  TabSwitchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tabSwitchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tabSwitchHash();

  @$internal
  @override
  TabSwitch create() => TabSwitch();
}

String _$tabSwitchHash() => r'd722c67fb53a6982ebaa05221d95be99b185117d';

/// Holds the [StreamController] that carries [TabSwitchRequest]s.
///
/// Routes tab-switch requests through Riverpod instead of an out-of-band global
/// singleton. [fire] publishes a request and the exposed stream is consumed
/// (via `ref.listen`) by the home page.

abstract class _$TabSwitch extends $StreamNotifier<TabSwitchRequest> {
  Stream<TabSwitchRequest> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TabSwitchRequest>, TabSwitchRequest>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TabSwitchRequest>, TabSwitchRequest>,
              AsyncValue<TabSwitchRequest>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
