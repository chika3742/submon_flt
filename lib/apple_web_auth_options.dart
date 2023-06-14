import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleWebAuthOptions {
  static const clientId = "net.chikach.submon.asi";

  static const redirectUriProd =
      "https://submon.app/api/v1/redirectToAppleSignInCallback";
  static const redirectUriDev =
      "https://dev.submon.app/api/v1/redirectToAppleSignInCallback";

  static WebAuthenticationOptions get currentBuild {
    if (kReleaseMode) {
      return WebAuthenticationOptions(
          clientId: clientId, redirectUri: Uri.parse(redirectUriProd));
    } else {
      return WebAuthenticationOptions(
          clientId: clientId, redirectUri: Uri.parse(redirectUriDev));
    }
  }
}
