import 'package:pigeon/pigeon.dart';

class SignInResponse {
  String? responseUri;
}

@HostApi()
abstract class UtilsApi {
  void openWebPage(String title, String url);

  ///
  /// Opens Custom Tab for signing in. Returns response URI with token query parameters.
  ///
  @async
  SignInResponse openSignInCustomTab(String url);
}
