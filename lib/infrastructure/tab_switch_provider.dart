import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

part "tab_switch_provider.g.dart";

/// A request to switch the bottom navigation to the tab identified by [path].
///
/// Emitted in response to deep links so the home page can select the matching
/// bottom-nav tab once it is ready.
class TabSwitchRequest {
  const TabSwitchRequest(this.path);

  final String path;
}

/// Holds the [StreamController] that carries [TabSwitchRequest]s.
///
/// Routes tab-switch requests through Riverpod instead of an out-of-band global
/// singleton. [fire] publishes a request and the exposed stream is consumed
/// (via `ref.listen`) by the home page.
@Riverpod(keepAlive: true)
class TabSwitch extends _$TabSwitch {
  final _controller = StreamController<TabSwitchRequest>.broadcast();

  @override
  Stream<TabSwitchRequest> build() {
    ref.onDispose(_controller.close);
    return _controller.stream;
  }

  /// Publishes a request to switch to the tab identified by [path].
  void fire(String path) {
    _controller.add(TabSwitchRequest(path));
  }
}
