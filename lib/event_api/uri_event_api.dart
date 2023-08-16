import 'dart:async';

import 'package:flutter/services.dart';
import 'package:submon/link_handler/link_handler.dart';

class UriEventApi {
  static const _eventName = "net.chikach.submon.event/uri";
  static const _channel = EventChannel(_eventName);

  StreamSubscription listen() {
    return _channel.receiveBroadcastStream().listen((uri) {
      LinkHandler.handleLink(Uri.parse(uri as String));
    });
  }
}
