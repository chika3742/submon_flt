import "package:flutter_web_auth_2/flutter_web_auth_2.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";

import "../../../../constants/apple_sign_in_android.dart";


Future<AuthorizationCredentialAppleID> signInWithAppleWebBased(
    {required String state, required String nonce}) async {
  final uri = Uri.https(
    "appleid.apple.com",
    "/auth/authorize",
    {
      "response_type": "code id_token",
      "client_id": asiClientId,
      "redirect_uri": redirectUri.toString(),
      "state": state,
      "nonce": nonce,
      "response_mode": "form_post",
      "scope": "name email",
    },
  );

  final result = await FlutterWebAuth2.authenticate(
    url: uri.toString(),
    callbackUrlScheme: "https",
    options: FlutterWebAuth2Options(
      httpsHost: callbackUri.host,
      httpsPath: callbackUri.path,
    ),
  );

  final query = Uri.parse(result).queryParameters;
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
