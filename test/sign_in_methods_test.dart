import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:submon/auth/sign_in_methods.dart';

void main() {
  Future<List<String>> fetchWith(MockClientHandler handler) =>
      http.runWithClient(
        () => fetchSignInMethodsForEmail('a@example.com', apiKey: 'key'),
        () => MockClient(handler),
      );

  test('returns signinMethods and sends the expected request', () async {
    final methods = await fetchWith((req) async {
      expect(req.url.path, '/v1/accounts:createAuthUri');
      expect(req.url.queryParameters['key'], 'key');
      expect(jsonDecode(req.body)['identifier'], 'a@example.com');
      return http.Response('{"registered":true,"signinMethods":["password"]}', 200);
    });
    expect(methods, [EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD]);
  });

  test('returns an empty list for unregistered emails', () async {
    expect(await fetchWith((_) async => http.Response('{"registered":false}', 200)), isEmpty);
  });

  test('maps API errors to FirebaseAuthException codes', () async {
    expect(
      fetchWith((_) async => http.Response('{"error":{"code":400,"message":"INVALID_EMAIL"}}', 400)),
      throwsA(isA<FirebaseAuthException>().having((e) => e.code, 'code', 'invalid-email')),
    );
  });

  test('maps network failures to network-request-failed', () async {
    expect(
      fetchWith((_) async => throw http.ClientException('offline')),
      throwsA(isA<FirebaseAuthException>().having((e) => e.code, 'code', 'network-request-failed')),
    );
  });
}
