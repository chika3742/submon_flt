import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:submon/apple_web_auth_options.dart';
import 'package:submon/src/pigeons.g.dart';

class AppleSignIn {
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AuthorizationCredentialAppleID?> signIn(
      {required String state, required String nonce}) async {
    final options = AppleWebAuthOptions.currentBuild;

    var uri = Uri(
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

    var resultUri = await BrowserApi().openAuthCustomTab(uri.toString());
    if (resultUri == null) {
      return null;
    }

    try {
      var query = Uri.parse(resultUri).queryParameters;
      return AuthorizationCredentialAppleID(
        userIdentifier: null,
        givenName: null,
        familyName: null,
        authorizationCode: query["code"]!,
        email: null,
        identityToken: query["id_token"],
        state: query["state"],
      );
    } on FormatException catch (e, st) {
      debugPrint("Failed to parse the sign in result URI: ${e.toString()}");
      debugPrintStack(stackTrace: st);
      return null;
    } catch (e, st) {
      debugPrint("Failed to sign in: ${e.toString()}");
      debugPrintStack(stackTrace: st);
      return null;
    }
  }
}
