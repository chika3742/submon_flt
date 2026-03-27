class AuthException implements Exception {
  final AuthErrorCode code;

  const AuthException(this.code);

  @override
  String toString() => "AuthException: $code";
}

enum AuthErrorCode {
  stateMismatch("リクエスト改ざんの検証に失敗しました。もう一度お試しください。"),
  notSignedIn("サインインが必要です。"),
  userAlreadyExists("既に同じメールアドレスのアカウントが存在します。", isCommonError: true),
  invalidCredential("無効な認証情報です。"),
  userDisabled("このアカウントは凍結されています。"),
  userNotFound("ユーザーが見つかりません。"),
  wrongPassword("パスワードが間違っています。", isCommonError: true),
  networkRequestFailed("通信に失敗しました。ネットワーク接続を確認してください。", isCommonError: true),
  userTokenExpired("トークンの有効期限が切れました。サインアウトしてから再度サインインしてください。"),
  invalidActionCode("URLの有効期限が切れたか、無効なURLです。もう一度お試しください。", isCommonError: true),
  emailAlreadyInUse("このメールアドレスは既に使用されています。", isCommonError: true),
  credentialAlreadyInUse("このアカウントはすでに別のユーザーに紐づけられています。", isCommonError: true),
  userMismatch("現在サインイン中のユーザーと異なるアカウントです。", isCommonError: true),
  noLinkedProvider("このアカウントには紐づけられたプロバイダがありません。"),
  unknownProvider("この認証方法はサポートされていません。"),
  noSavedAuthEmail("このデバイスでサインインしようとしたことを確認してください。"),
  missingContinueUrl("再認証リンクが正しくありません。"),
  weakPassword("パスワードが短すぎます。最低6文字で指定してください。", isCommonError: true),
  invalidEmail("メールアドレスの形式が正しくありません。", isCommonError: true),
  requiresRecentLogin("この操作をするには、再ログインが必要です。", isCommonError: true),
  expiredActionCode("このURLの有効期限が切れています。もう一度お試しください。", isCommonError: true),
  unknown("不明なエラーが発生しました。しばらく待ってからもう一度お試しください。"),
  ;

  final String userFriendlyMessage;

  /// If this flag is true, the error will not be reported to Crashlytics.
  final bool isCommonError;

  const AuthErrorCode(this.userFriendlyMessage, {this.isCommonError = false});

  factory AuthErrorCode.fromFirebaseAuthErrorCode(String code) {
    return switch (code.replaceFirst(RegExp("^(firebase_)?auth/"), "")) {
      "account-exists-with-different-credential" => AuthErrorCode.userAlreadyExists,
      "invalid-credential" => AuthErrorCode.invalidCredential,
      "user-disabled" => AuthErrorCode.userDisabled,
      "user-not-found" => AuthErrorCode.userNotFound,
      "wrong-password" => AuthErrorCode.wrongPassword,
      "network-request-failed" => AuthErrorCode.networkRequestFailed,
      "user-token-expired" => AuthErrorCode.userTokenExpired,
      "invalid-action-code" => AuthErrorCode.invalidActionCode,
      "email-already-in-use" => AuthErrorCode.emailAlreadyInUse,
      "credential-already-in-use" => AuthErrorCode.credentialAlreadyInUse,
      "user-mismatch" => AuthErrorCode.userMismatch,
      "expired-action-code" => AuthErrorCode.expiredActionCode,
      "weak-password" => AuthErrorCode.weakPassword,
      "invalid-email" => AuthErrorCode.invalidEmail,
      "requires-recent-login" => AuthErrorCode.requiresRecentLogin,
      _ => AuthErrorCode.unknown,
    };
  }
}
