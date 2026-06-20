import "package:flutter_test/flutter_test.dart";
import "package:submon/features/auth/models/auth_exception.dart";

/// `AuthErrorCode.fromFirebaseAuthErrorCode` は Firebase のエラーコードを
/// アプリ内エラーコードへ写像する実体。移行で写像が壊れないよう固定する。
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
      test("$code → $expected", () {
        expect(AuthErrorCode.fromFirebaseAuthErrorCode(code), expected);
      });
    });

    test("firebase_auth/ プレフィックスを除去して写像する", () {
      expect(
        AuthErrorCode.fromFirebaseAuthErrorCode("firebase_auth/wrong-password"),
        AuthErrorCode.wrongPassword,
      );
    });

    test("auth/ プレフィックスを除去して写像する", () {
      expect(
        AuthErrorCode.fromFirebaseAuthErrorCode("auth/invalid-email"),
        AuthErrorCode.invalidEmail,
      );
    });

    test("未知のコードは unknown にフォールバックする", () {
      expect(
        AuthErrorCode.fromFirebaseAuthErrorCode("something-unexpected"),
        AuthErrorCode.unknown,
      );
    });
  });
}
