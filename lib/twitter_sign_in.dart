import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:submon/method_channel/channels.dart';
import 'package:submon/utils/ui.dart';

import 'method_channel/main.dart';

class TwitterSignIn {
  final String apiKey;
  final String apiSecret;
  final String redirectUri;
  final BuildContext context;

  TwitterSignIn(
      {required this.apiKey,
      required this.apiSecret,
      required this.redirectUri,
      required this.context});

  Future<TwitterAuthResult?> signIn() async {
    var modalShown = true;
    showLoadingModal(context);
    try {
      var reqToken = await _getRequestToken();

      Navigator.of(context, rootNavigator: true).pop(); // pop modal loading
      modalShown = false;

      AuthResult authResult;
      final url = "https://api.twitter.com/oauth/authorize?oauth_token=" +
          reqToken!.oauthToken;

      if (Platform.isAndroid) {
        openCustomTabs(url);
        authResult = await waitForUri();
      } else {
        var brResult = await openCustomTabs(url);
        if (brResult != null) {
          var query = Uri.parse(brResult).queryParameters;
          authResult =
              AuthResult(query["oauth_token"]!, query["oauth_verifier"]!);
        } else {
          return null;
        }
      }

      var result = await getAccessToken(authResult);

      return result;
    } on SocketException {
      return TwitterAuthResult(errorMessage: "エラーが発生しました。インターネット接続をご確認ください。");
    } on TwitterRequestFailedException catch (e) {
      if (e.code == 135) {
        return TwitterAuthResult(errorMessage: "端末の時刻がサーバー時刻と大幅にずれています。");
      } else {
        return TwitterAuthResult(errorMessage: "エラーが発生しました。(${e.code})");
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      return TwitterAuthResult(errorMessage: "エラーが発生しました。");
    } finally {
      if (modalShown) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<RequestTokenResult?> _getRequestToken() async {
    var baseUri = Uri(
        scheme: "https", host: "api.twitter.com", path: "/oauth/request_token");
    var params = {
      "oauth_callback": "submon://",
      "oauth_consumer_key": apiKey,
      "oauth_nonce": _generateNonce(11),
      "oauth_signature_method": "HMAC-SHA1",
      "oauth_timestamp":
          (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0),
      "oauth_version": "1.0"
    };

    var signature =
        "POST&${Uri.encodeComponent(baseUri.toString())}&${Uri.encodeComponent(_joinParamsWithAmpersand(params))}";

    params["oauth_signature"] = _generateSignature("$apiSecret&", signature);

    var headers = {
      "User-Agent": "Submon/1.0",
    };

    var result = await http.post(baseUri.replace(queryParameters: params),
        headers: headers);

    if (result.statusCode != 200) {
      var error = jsonDecode(result.body)["errors"][0];
      throw TwitterRequestFailedException(
          code: error["code"], message: error["message"]);
    }

    var query = Uri.splitQueryString(result.body);
    return RequestTokenResult(
        query["oauth_token"]!, query["oauth_token_secret"]!);
  }

  Future<TwitterAuthResult?> getAccessToken(AuthResult auth) async {
    var baseUri = Uri(
        scheme: "https", host: "api.twitter.com", path: "/oauth/access_token");
    var params = {
      "oauth_consumer_key": apiKey,
      "oauth_token": auth.oauthToken,
      "oauth_verifier": auth.oauthVerifier,
    };

    var headers = {
      "User-Agent": "Submon/1.0",
    };

    var result = await http.post(baseUri.replace(queryParameters: params),
        headers: headers);

    if (result.statusCode != 200) return null;

    var query = Uri.splitQueryString(result.body);
    return TwitterAuthResult(
      accessToken: query["oauth_token"]!,
      accessTokenSecret: query["oauth_token_secret"]!,
    );
  }

  String _joinParamsWithAmpersand(Map<String, String?> map) {
    var result = "";
    map.forEach((key, value) {
      result += "$key=${Uri.encodeComponent(value!)}&";
    });
    return result.substring(0, result.length - 1);
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _generateSignature(String key, String data) {
    final keyBytes = utf8.encode(key);
    final bytes = utf8.encode(data);
    final hmacsha1 = Hmac(sha1, keyBytes);
    final digest = hmacsha1.convert(bytes);
    return base64.encode(digest.bytes);
  }

  Future<AuthResult> waitForUri() async {
    var completer = Completer<AuthResult>();
    var subscription = const EventChannel(EventChannels.twitterSignInUri)
        .receiveBroadcastStream()
        .listen((event) {
      var query = Uri.splitQueryString(event);
      completer.complete(
          AuthResult(query["oauth_token"]!, query["oauth_verifier"]!));
    });

    var result = await completer.future;

    subscription.cancel();

    return result;
  }
}

class RequestTokenResult {
  RequestTokenResult(this.oauthToken, this.oauthTokenSecret);

  final String oauthToken;
  final String oauthTokenSecret;
}

class AuthResult {
  AuthResult(this.oauthToken, this.oauthVerifier);

  final String oauthToken;
  final String oauthVerifier;

  @override
  String toString() {
    return "oauthToken: $oauthToken, oauthVerifier: $oauthVerifier";
  }
}

class TwitterAuthResult {
  TwitterAuthResult(
      {this.accessToken, this.accessTokenSecret, this.errorMessage});

  final String? accessToken;
  final String? accessTokenSecret;
  final String? errorMessage;

  @override
  String toString() {
    return "oauthToken: $accessToken, oauthSecret: $accessTokenSecret";
  }
}

class TwitterRequestFailedException implements Exception {
  int? code;
  String? message;

  TwitterRequestFailedException({this.code, this.message});

  @override
  String toString() {
    return "Twitter request failed. ($code) $message";
  }
}