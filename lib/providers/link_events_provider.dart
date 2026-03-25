import "package:flutter/services.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "link_events_provider.g.dart";

/// ネイティブから送信される URI イベントの Stream を提供する。
@Riverpod(keepAlive: true)
Stream<Distinguish<Uri>> linkEvents(Ref ref) {
  const channel = EventChannel("net.chikach.submon.event/uri");
  return channel
      .receiveBroadcastStream()
      .map((uri) => Distinguish(Uri.parse(uri as String)));
}

/// Distinguish は、同じ URI でも別のイベントとして区別するためのラッパークラスです。const
/// を付けると無意味になります。
class Distinguish<T> {
  final T value;

  Distinguish(this.value);
}
