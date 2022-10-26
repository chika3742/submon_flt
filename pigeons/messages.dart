import 'package:pigeon/pigeon.dart';

class SignInCallback {
  late String uri;
}

@HostApi()
abstract class UtilsApi {
  ///
  /// Opens web page with new activity on Android, with SFSafariViewController on iOS.
  /// On Android, [title] will be the title of activity. On iOS, [title] will be ignored.
  ///
  void openWebPage(String title, String url);

  ///
  /// Opens Custom Tab for signing in. Returns response URI with token query parameters.
  ///
  @async
  SignInCallback openSignInCustomTab(String url);

  ///
  /// Updates App Widgets on Android, WidgetKit on iOS.
  ///
  void updateWidgets();

  ///
  /// Requests iOS/macOS ATT permission. On Android, this method does nothing.
  ///
  /// Permission requesting result will be returned. On Android, always `true` will be returned.
  ///
  @async
  bool requestIDFA();

  ///
  /// Sets wake lock mode.
  ///
  void setWakeLock(bool wakeLock);

  ///
  /// Sets fullscreen mode.
  ///
  void setFullscreen(bool fullscreen);
}

@FlutterApi()
abstract class AppLinkHandlerApi {
  void handleUri(String uri);
}

@HostApi()
abstract class FirebaseMessagingApi {
  ///
  /// Returns Firebase Cloud Messaging notification token.
  ///
  @async
  String getToken();

  ///
  /// Requests notification permission. if granted, `true` will be returned.
  ///
  @async
  bool requestNotificationPermission();
}