import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:submon/utils/dynamic_links.dart';

import '../method_channel/channels.dart';
import '../method_channel/main.dart';

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

    MainMethodPlugin.openCustomTabs(uri.toString());

    var authResult = await waitForUri();

    return authResult;
  }

  Future<AuthorizationCredentialAppleID?> waitForUri() async {
    var completer = Completer<AuthorizationCredentialAppleID?>();
    var subscription = const EventChannel(EventChannels.signInUri)
        .receiveBroadcastStream()
        .listen((event) {
      if (event == null) {
        completer.complete(null);
        return;
      }

      var query = Uri.splitQueryString(event);
      completer.complete(AuthorizationCredentialAppleID(
        userIdentifier: null,
        givenName: null,
        familyName: null,
        authorizationCode: query["code"]!,
        email: null,
        identityToken: query["id_token"],
        state: query["state"],
      ));
    });

    var result = await completer.future;

    subscription.cancel();

    return result;
  }
}
