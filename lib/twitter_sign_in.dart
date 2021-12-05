import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:submon/browser.dart';
import 'package:url_launcher/url_launcher.dart';

class TwitterSignIn {
  final String? apiKey;
  final String? apiSecret;
  final String? redirectUri;

  TwitterSignIn({this.apiKey, this.apiSecret, this.redirectUri});

  Future<TwitterAuthResult?> signIn() async {
    var reqToken = await _getRequestToken();
    launch("https://api.twitter.com/oauth/authorize?oauth_token=" +
        reqToken!.oauthToken);

    var authResult = await waitForUri();

    var result = await getAccessToken(authResult);

    verifyToken(result!);

    return result;
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

    if (result.statusCode != 200) return null;

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
        query["oauth_token"]!, query["oauth_token_secret"]!);
  }

  Future<void> verifyToken(TwitterAuthResult auth) async {
    var baseUri = Uri(
        scheme: "https",
        host: "api.twitter.com",
        path: "/1.1/account/verify_credentials.json");
    var params = {
      "oauth_consumer_key": apiKey,
      "oauth_token": auth.accessToken,
      "oauth_nonce": _generateNonce(11),
      "oauth_signature_method": "HMAC-SHA1",
      "oauth_timestamp":
          (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0),
      "oauth_version": "1.0"
    };

    var signature =
        "GET&${Uri.encodeComponent(baseUri.toString())}&${Uri.encodeComponent(_joinParamsWithAmpersand(params))}";

    params["oauth_signature"] =
        _generateSignature("$apiSecret&${auth.accessTokenSecret}", signature);

    var headers = {
      "User-Agent": "Submon/1.0",
    };

    var result = await http.get(baseUri.replace(queryParameters: params),
        headers: headers);

    print(result.body);
  }

  String _joinParamsWithAmpersand(Map<String, String?> map) {
    var result = "";
    map.forEach((key, value) {
      result += "$key=${Uri.encodeComponent(value!)}&";
    });
    return result.substring(0, result.length - 1);
  }

  String _generateAuthorizationHeader(Map<String, String?> map) {
    var result = "OAuth ";
    map.forEach((key, value) {
      result += '$key="${Uri.encodeComponent(value!)}", ';
    });
    return result.substring(0, result.length - 2);
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
    const MethodChannel(channel).setMethodCallHandler((call) async {
      if (call.method == "onUriData") {
        var query = Uri.splitQueryString(call.arguments);
        completer.complete(
            AuthResult(query["oauth_token"]!, query["oauth_verifier"]!));
        return true;
      } else {
        return UnimplementedError();
      }
    });

    return completer.future;
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
  TwitterAuthResult(this.accessToken, this.accessTokenSecret);

  final String accessToken;
  final String accessTokenSecret;

  @override
  String toString() {
    return "oauthToken: $accessToken, oauthSecret: $accessTokenSecret";
  }
}
