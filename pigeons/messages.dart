import 'package:pigeon/pigeon.dart';

class SignInCallback {
  String? uri;
}

@HostApi()
abstract class UtilsApi {
  void openWebPage(String title, String url);

  ///
  /// Opens Custom Tab for signing in. Returns response URI with token query parameters.
  ///
  @async
  SignInCallback openSignInCustomTab(String url);
}
