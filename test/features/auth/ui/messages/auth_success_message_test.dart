import "package:flutter_test/flutter_test.dart";
import "package:submon/features/auth/domain/models/auth_mode.dart";
import "package:submon/features/auth/domain/use_cases/sign_in_by_mode_use_case.dart";
import "package:submon/features/auth/ui/messages/auth_success_message.dart";

void main() {
  group("AuthSuccessMessage.authSuccessMessage", () {
    test("signIn with notificationPermissionDenied returns notification message", () {
      final result = SignInResult(
        mode: AuthMode.signIn,
        signInCompletionResult: SignInCompletionResult(
          newUser: false,
          notificationPermissionDenied: true,
        ),
      );
      expect(result.authSuccessMessage, contains("通知"));
    });

    test("signIn with newUser returns welcome message", () {
      final result = SignInResult(
        mode: AuthMode.signIn,
        signInCompletionResult: SignInCompletionResult(
          newUser: true,
          notificationPermissionDenied: false,
        ),
      );
      expect(result.authSuccessMessage, contains("ようこそ"));
    });

    test("signIn normal returns sign-in complete message", () {
      final result = SignInResult(
        mode: AuthMode.signIn,
        signInCompletionResult: SignInCompletionResult(
          newUser: false,
          notificationPermissionDenied: false,
        ),
      );
      expect(result.authSuccessMessage, contains("サインイン"));
    });

    test("reauthenticate returns reauthentication success message", () {
      final result = SignInResult(mode: AuthMode.reauthenticate);
      expect(result.authSuccessMessage, contains("再認証"));
    });

    test("upgrade returns upgrade message", () {
      final result = SignInResult(mode: AuthMode.upgrade);
      expect(result.authSuccessMessage, contains("アップグレード"));
    });
  });
}
