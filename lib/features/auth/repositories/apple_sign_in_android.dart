import "dart:async";
import "dart:convert";

import "package:crypto/crypto.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";

import "../../../apple_web_auth_options.dart";
import "../../../src/pigeons.g.dart";
import "../models/auth_exception.dart";

class AppleSignInAndroid {
  final BrowserApi _browserApi;
  final FirebaseCrashlytics _crashlytics;

  const AppleSignInAndroid(this._browserApi, this._crashlytics);

  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AuthorizationCredentialAppleID?> signIn(
      {required String state, required String nonce}) async {
    final options = AppleWebAuthOptions.currentBuild;

    final uri = Uri(
      scheme: "https",
      host: "appleid.apple.com",
      path: "/auth/authorize",
      queryParameters: {
        "response_type": "code id_token",
        "client_id": options.clientId,
        "redirect_uri": options.redirectUri.toString(),
        "state": state,
        "nonce": nonce,
        "response_mode": "form_post",
        "scope": "name email",
      },
    );

    final resultUri = await _browserApi.openAuthCustomTab(uri.toString());
    if (resultUri == null) {
      return null;
    }

    final query = Uri.tryParse(resultUri)?.queryParameters;
    if (query == null) {
      _crashlytics.recordError(
        "Failed to parse result URI from Apple Sign-In: $resultUri",
        StackTrace.current,
      );
      throw AuthException(AuthErrorCode.unknown);
    }
    return AuthorizationCredentialAppleID(
      userIdentifier: null,
      givenName: null,
      familyName: null,
      authorizationCode: query["code"]!,
      email: null,
      identityToken: query["id_token"],
      state: query["state"],
    );
  }
}
