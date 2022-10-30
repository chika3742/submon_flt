import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
    dartOut: "lib/messages.dart",
    objcOptions: ObjcOptions(prefix: "FLT"),
    objcHeaderOut: "ios/Runner/messages.h",
    objcSourceOut: "ios/Runner/messages.m",
    javaOut: "android/app/src/main/java/net/chikach/submon/Messages.java",
    javaOptions: JavaOptions(package: "net.chikach.submon")))
class SignInCallback {
  late String uri;
}

@HostApi()
abstract class UtilsApi {
  ///
  /// Opens web page with new activity on Android, with SFSafariViewController on iOS.
  /// On Android, [title] will be the title of activity. On iOS, [title] will be ignored.
  ///
  @ObjCSelector("openWebPageWithTitle:url:")
  void openWebPage(String title, String url);

  ///
  /// Opens Custom Tab for signing in. Returns response URI with token query parameters.
  ///
  @async
  @ObjCSelector("openSignInCustomTabWithUrl:")
  SignInCallback openSignInCustomTab(String url);

  ///
  /// Updates App Widgets on Android, WidgetKit on iOS.
  ///
  @ObjCSelector("updateWidgets")
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
  @ObjCSelector("setWakeLock:")
  void setWakeLock(bool wakeLock);

  ///
  /// Sets fullscreen mode.
  ///
  @ObjCSelector("setFullscreen:")
  void setFullscreen(bool fullscreen);
}

@FlutterApi()
abstract class AppLinkHandlerApi {
  @ObjCSelector("handleUri:")
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