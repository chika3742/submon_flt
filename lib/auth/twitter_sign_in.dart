import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:submon/method_channel/channels.dart';
import 'package:submon/models/sign_in_result.dart';
import 'package:submon/models/twitter_sign_in_result.dart';

import '../messages.dart';

class TwitterSignIn {
  late final String apiKey;
  late final String apiSecret;
  late final String redirectUri;

  TwitterSignIn() {
    String apiKey;
    String apiSecret;

    if (kReleaseMode) {
      apiKey = dotenv.env["TWITTER_API_KEY"]!;
      apiSecret = dotenv.env["TWITTER_API_SECRET"]!;
    } else {
      apiKey = dotenv.env["TWITTER_API_KEY_DEV"]!;
      apiSecret = dotenv.env["TWITTER_API_SECRET_DEV"]!;
    }

    this.apiKey = apiKey;
    this.apiSecret = apiSecret;
    redirectUri = "submon://auth-callback/twitter";
  }

  Future<TwitterSignInResult> signIn() async {
    try {
      var reqToken = await _getRequestToken();

      AuthResult? authResult;
      final url =
          "https://api.twitter.com/oauth/authorize?oauth_token=${reqToken!.oauthToken}";

      var callback = await UtilsApi().openSignInCustomTab(url);
      if (callback.uri != null) {
        var query = Uri.parse(callback.uri!).queryParameters;
        authResult =
            AuthResult(query["oauth_token"]!, query["oauth_verifier"]!);
      } else {
        return TwitterSignInResult(errorCode: SignInError.unknown);
      }

      var result = await getAccessToken(authResult);

      return result;
    } on SocketException {
      return TwitterSignInResult(
          errorCode: SignInError.socketError,
          errorMessage: "エラーが発生しました。インターネット接続をご確認ください。");
    } on TwitterRequestFailedException catch (e) {
      if (e.code == 135) {
        return TwitterSignInResult(
            errorCode: SignInError.twitterTimeOutOfSync,
            errorMessage: "端末の時刻がサーバー時刻と大幅にずれています。");
      } else {
        return TwitterSignInResult(
            errorCode: SignInError.twitterRequestTokenRequestFailed,
            errorMessage: "エラーが発生しました。(${e.code})");
      }
    } on PlatformException catch (e) {
      if (e.message!.contains("canceled")) {
        return TwitterSignInResult(errorCode: SignInError.cancelled);
      }
      rethrow;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return TwitterSignInResult(
          errorCode: SignInError.unknown, errorMessage: "エラーが発生しました。");
    }
  }

  Future<RequestTokenResult?> _getRequestToken() async {
    var baseUri = Uri(
        scheme: "https", host: "api.twitter.com", path: "/oauth/request_token");
    var params = {
      "oauth_callback": redirectUri,
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

  Future<TwitterSignInResult> getAccessToken(AuthResult auth) async {
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

    if (result.statusCode != 200) {
      return TwitterSignInResult(errorCode: SignInError.twitterAccessTokenRequestFailed, errorMessage: "エラーが発生しました。");
    }

    var query = Uri.splitQueryString(result.body);
    return TwitterSignInResult(
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

  Future<AuthResult?> waitForUri() async {
    var completer = Completer<AuthResult?>();
    var subscription = const EventChannel(EventChannels.signInUri)
        .receiveBroadcastStream()
        .listen((event) {
      if (event != null) {
        var query = Uri.splitQueryString(event);
        completer.complete(
            AuthResult(query["oauth_token"]!, query["oauth_verifier"]!));
      } else {
        completer.complete(null);
      }
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

class TwitterRequestFailedException implements Exception {
  int? code;
  String? message;

  TwitterRequestFailedException({this.code, this.message});

  @override
  String toString() {
    return "Twitter request failed. ($code) $message";
  }
}
