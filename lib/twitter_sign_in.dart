import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class TwitterSignIn {
  final String? apiKey;
  final String? apiSecret;
  final String? redirectUri;

  TwitterSignIn({this.apiKey, this.apiSecret, this.redirectUri});

  Future<TwitterAuthResult?> signIn() async {
    var reqToken = await _getRequestToken();
    print(reqToken);
  }

  Future<String> _getRequestToken() async {
    var _params = {
      "oauth_callback": redirectUri!,
      "oauth_consumer_key": apiKey!,
      "oauth_nonce": _generateNonce(11),
      "oauth_signature": _hmacSha1ofString(apiSecret!),
      "oauth_signature_method": "HMAC-SHA1",
      "oauth_timestamp":
          (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0),
      "oauth_version": "1.0",
    };

    var params = <String, dynamic>{};

    _params.forEach((key, value) {
      params[key] = Uri.encodeQueryComponent(value);
    });

    print(params);

    var headers = {
      "User-Agent": "Submon/1.0",
      "Accept": "*.*",
      "Connection": "keep-alive",
    };

    var result = await http.post(
        Uri(
            scheme: "https",
            host: "api.twitter.com",
            path: "/oauth/request_token",
            queryParameters: params),
        headers: headers);
    print(result.request!.url);
    return result.body;
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _hmacSha1ofString(String inputSecret) {
    final key = utf8.encode(inputSecret);
    final bytes = utf8.encode(
        (DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0));
    final hmacsha1 = Hmac(sha1, key);
    final digest = hmacsha1.convert(bytes);
    return base64.encode(digest.bytes);
  }
}

class TwitterAuthResult {}
