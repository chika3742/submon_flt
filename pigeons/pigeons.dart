import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: "lib/src/pigeons.g.dart",
  kotlinOut: "android/app/src/main/kotlin/net/chikach/submon/Pigeons.g.kt",
  swiftOut: "ios/Runner/Pigeons.g.swift",
  copyrightHeader: "pigeons/copyright.txt",
))

/// Whether the notification permission has been granted or denied.
enum NotificationPermissionState {
  granted,
  denied,
}

/// Wraps a NotificationPermissionState enum.
/// (Pigeon cannot handle enums as primitive return values)
class NotificationPermissionStateWrapper {
  NotificationPermissionStateWrapper({required this.value});

  NotificationPermissionState value;
}

/// A set of APIs to handle Firebase Cloud Messaging.
@HostApi()
abstract class MessagingApi {
  /// Returns true if the Google Play Services are available on the device.
  /// Only available on Android.
  bool isGoogleApiAvailable();

  /// Gets the FCM token for this device. Returns null if failed.
  @async
  String? getToken();

  /// Requests notification permission from the user.
  @async
  NotificationPermissionStateWrapper? requestNotificationPermission();
}

/// Browser-related APIs.
@HostApi()
abstract class BrowserApi {
  /// Opens a custom tab which returns the callback URL.
  /// Returns null if cancelled.
  ///
  /// This method is only available on Android.
  @async
  String? openAuthCustomTab(String url);

  /// Opens a web page in WebView activity (on Android) or
  /// [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
  /// (on iOS).
  ///
  /// `title` is used as the title of the activity on Android.
  /// (unused on iOS)
  void openWebPage(String title, String url);
}

/// General APIs.
@HostApi()
abstract class GeneralApi {
  /// Updates the widgets on the home screen.
  void updateWidgets();

  /// Requests the IDFA (Identifier for Advertisers) from the user on iOS.
  @async
  bool requestIDFA();

  /// Sets the wake lock (`isIdleTimerDisabled` on iOS, `` on Android) state.
  void setWakeLock(bool enabled);

  /// Sets the fullscreen state.
  ///
  /// This method is only available on Android.
  void setFullscreen(bool isFullscreen);
}
