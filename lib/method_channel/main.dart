import 'package:flutter/services.dart';
import 'package:submon/db/firestore_provider.dart';

import 'channels.dart';

class MainMethodPlugin {
  static const channel = MethodChannel(MethodChannels.main);

  MainMethodPlugin._();

  static initHandler() {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "saveMessagingToken":
          FirestoreProvider.saveNotificationToken(call.arguments["token"]);
          return null;
        default:
          return null;
      }
    });
  }

  /// Takes a picture with native ui.
  static Future<String?> takePictureNative() async {
    return await channel.invokeMethod<String>("takePictureNative");
  }

}
