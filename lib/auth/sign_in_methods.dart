import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

/// Replacement for `FirebaseAuth.fetchSignInMethodsForEmail`, which was removed
/// in firebase_auth 6. Calls the same Identity Toolkit endpoint the SDK used.
///
/// Returns an empty list when email enumeration protection is enabled.
// shortcut: no App Check token or API key restriction headers are sent, so this breaks if either is enforced; drop it when the email sign-in flow is rewritten.
Future<List<String>> fetchSignInMethodsForEmail(String email,
    {String? apiKey}) async {
  try {
    final res = await http.post(
      Uri.https('identitytoolkit.googleapis.com', '/v1/accounts:createAuthUri',
          {'key': apiKey ?? Firebase.app().options.apiKey}),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': email, 'continueUri': 'http://localhost'}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final error = body['error'] as Map<String, dynamic>?;
    if (error != null) {
      final message = error['message'] as String;
      // "INVALID_EMAIL" -> "invalid-email", matching the SDK's error codes
      throw FirebaseAuthException(
        code: message.split(' ').first.toLowerCase().replaceAll('_', '-'),
        message: message,
      );
    }
    return List<String>.from(body['signinMethods'] as List? ?? const []);
  } on http.ClientException catch (e) {
    throw FirebaseAuthException(
        code: 'network-request-failed', message: e.message);
  } on FormatException catch (e) {
    throw FirebaseAuthException(code: 'internal-error', message: e.message);
  } on Exception catch (e) {
    throw FirebaseAuthException(code: 'network-request-failed', message: e.toString());
  }
}
