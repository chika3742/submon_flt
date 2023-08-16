import 'dart:async';

import 'package:flutter/services.dart';
import 'package:submon/db/firestore_provider.dart';

class FcmTokenRefreshEventApi {
  static const _eventName = "net.chikach.submon.event/fcm_token_refresh";
  static const _channel = EventChannel(_eventName);

  StreamSubscription listen() {
    return _channel.receiveBroadcastStream().listen((token) {
      FirestoreProvider.saveNotificationToken(token);
    });
  }
}
