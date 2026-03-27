import "package:flutter/services.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../utils/distinguish.dart";

part "link_events_provider.g.dart";

/// ネイティブから送信される URI イベントの Stream を提供する。
@Riverpod(keepAlive: true)
Stream<Distinguish<Uri>> linkEvents(Ref ref) {
  const channel = EventChannel("net.chikach.submon.event/uri");
  return channel
      .receiveBroadcastStream()
      .map((uri) => Distinguish(Uri.parse(uri as String)));
}
