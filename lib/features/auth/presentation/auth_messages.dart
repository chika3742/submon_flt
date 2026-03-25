import "../models/auth_exception.dart";
import "../use_cases/complete_sign_in_use_case.dart";

String signInSuccessMessage(CompleteSignInResult result) {
  return switch (result) {
    CompleteSignInResult(notificationPermissionDenied: true) =>
      "通知が許可されなかったため、通知が受信できません。",
    CompleteSignInResult(newUser: true) => "アカウントを作成しました！",
    _ => "ログインしました。",
  };
}

String authErrorMessage(Object error) {
  if (error is AuthException) {
    return error.code.userFriendlyMessage;
  }
  return "サインインに失敗しました";
}
