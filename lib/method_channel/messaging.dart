import 'package:flutter/services.dart';
import 'package:submon/method_channel/channels.dart';

class MessagingPlugin {
  static const _mc = MethodChannel(Channels.messaging);

  static Future<NotificationPermissionState?>
      requestNotificationPermission() async {
    var result = await _mc.invokeMethod<int>("requestNotificationPermission");
    if (result != null) {
      return NotificationPermissionState.values[result];
    } else {
      return null;
    }
  }

  static Future<String?> getToken() {
    return _mc.invokeMethod<String>("getToken");
  }
}

enum NotificationPermissionState {
  granted,
  denied,
}
