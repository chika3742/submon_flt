import "../../domain/models/auth_mode.dart";
import "../../domain/use_cases/sign_in_by_mode_use_case.dart";

extension AuthSuccessMessage on SignInResult {
  String get authSuccessMessage => switch (this) {
    SignInResult(
      mode: AuthMode.signIn,
      signInCompletionResult: SignInCompletionResult(
        notificationPermissionDenied: true,
      ),
    ) =>
      "通知を受け取るには、本体設定のアプリ設定から通知を許可してください。",
    SignInResult(
      mode: AuthMode.signIn,
      signInCompletionResult: SignInCompletionResult(newUser: true),
    ) =>
      "ようこそ、Submonへ！",
    SignInResult(mode: AuthMode.signIn) => "サインインしました",
    SignInResult(mode: AuthMode.reauthenticate) => "再認証に成功しました",
    SignInResult(mode: AuthMode.upgrade) => "アカウントをアップグレードしました",
  };
}
