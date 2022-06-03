import 'dart:io';

import 'package:flutter/foundation.dart';
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

  static void openWebPage(String title, String url) {
    channel.invokeMethod("openWebPage", {
      "title": title,
      "url": url,
    });
  }

  static Future<String?> openCustomTabs(String url) async {
    return await channel.invokeMethod<String>("openCustomTabs", {
      "url": url,
    });
  }

  static void updateWidgets() {
    channel.invokeMethod("updateWidgets");
  }

  /// Takes a picture with native ui.
  static Future<String?> takePictureNative() async {
    return await channel.invokeMethod<String>("takePictureNative");
  }

  static Future<String?> getPendingUri() async {
    return await channel.invokeMethod<String>("getPendingUri");
  }

  static Future<bool> requestIDFA() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      return await channel.invokeMethod("requestIDFA");
    } else {
      return true;
    }
  }

  static void enableWakeLock() {
    channel.invokeMethod("enableWakeLock");
  }

  static void disableWakeLock() {
    channel.invokeMethod("disableWakeLock");
  }

  static void enterFullscreen() {
    channel.invokeMethod("enterFullscreen");
  }

  static void exitFullscreen() {
    channel.invokeMethod("exitFullscreen");
  }
}
