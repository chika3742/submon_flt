import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../messages.dart';

String getAppleSignInRedirectorUrl() {
  if (kReleaseMode) {
    return "https://submon.app/api/v1/redirectToAppleSignInCallback";
  } else {
    return "https://dev.submon.app/api/v1/redirectToAppleSignInCallback";
  }
}

class AppleSignIn {
  String clientId = "net.chikach.submon.asi";
  Uri redirectUri = Uri.parse(getAppleSignInRedirectorUrl());

  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AuthorizationCredentialAppleID?> signIn(
      {required String state, required String nonce}) async {
    var uri = Uri(
      scheme: "https",
      host: "appleid.apple.com",
      path: "/auth/authorize",
      queryParameters: {
        "response_type": "code id_token",
        "client_id": clientId,
        "redirect_uri": redirectUri.toString(),
        "state": state,
        "nonce": nonce,
        "response_mode": "form_post",
        "scope": "name email",
      },
    );

    try {
      var callback = await UtilsApi().openSignInCustomTab(uri.toString());

      if (callback.uri != null) {
        var query = Uri.splitQueryString(Uri.parse(callback.uri!).query);
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
      return null;
    } on PlatformException catch (e) {
      if (e.message!.contains("canceled")) {
        return null;
      }
      rethrow;
    }
  }
}
