import "package:flutter_test/flutter_test.dart";
import "package:submon/features/auth/models/auth_exception.dart";

/// `AuthErrorCode.fromFirebaseAuthErrorCode` is the actual mapping from Firebase
/// error codes to in-app error codes. Pin it so the mapping does not break
/// during the migration.
void main() {
  group("AuthErrorCode.fromFirebaseAuthErrorCode", () {
    final cases = {
      "account-exists-with-different-credential":
          AuthErrorCode.userAlreadyExists,
      "invalid-credential": AuthErrorCode.invalidCredential,
      "user-disabled": AuthErrorCode.userDisabled,
      "user-not-found": AuthErrorCode.userNotFound,
      "wrong-password": AuthErrorCode.wrongPassword,
      "network-request-failed": AuthErrorCode.networkRequestFailed,
      "user-token-expired": AuthErrorCode.userTokenExpired,
      "invalid-action-code": AuthErrorCode.invalidActionCode,
      "email-already-in-use": AuthErrorCode.emailAlreadyInUse,
      "credential-already-in-use": AuthErrorCode.credentialAlreadyInUse,
      "user-mismatch": AuthErrorCode.userMismatch,
      "expired-action-code": AuthErrorCode.expiredActionCode,
      "weak-password": AuthErrorCode.weakPassword,
      "invalid-email": AuthErrorCode.invalidEmail,
      "requires-recent-login": AuthErrorCode.requiresRecentLogin,
    };

    cases.forEach((code, expected) {
      test("$code -> $expected", () {
        expect(AuthErrorCode.fromFirebaseAuthErrorCode(code), expected);
      });
    });

    test("strips the firebase_auth/ prefix before mapping", () {
      expect(
        AuthErrorCode.fromFirebaseAuthErrorCode("firebase_auth/wrong-password"),
        AuthErrorCode.wrongPassword,
      );
    });

    test("strips the auth/ prefix before mapping", () {
      expect(
        AuthErrorCode.fromFirebaseAuthErrorCode("auth/invalid-email"),
        AuthErrorCode.invalidEmail,
      );
    });

    test("falls back to unknown for an unrecognized code", () {
      expect(
        AuthErrorCode.fromFirebaseAuthErrorCode("something-unexpected"),
        AuthErrorCode.unknown,
      );
    });
  });
}
