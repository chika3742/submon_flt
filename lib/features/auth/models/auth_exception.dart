class AuthException implements Exception {
  final AuthErrorCode code;

  const AuthException(this.code);

  @override
  String toString() => "AuthException: $code";
}

enum AuthErrorCode {
  stateMismatch("リクエスト改ざんの検証に失敗しました。もう一度お試しください。"),
  notSignedIn("サインインが必要です。"),
  userAlreadyExists("既に同じメールアドレスのアカウントが存在します。"),
  invalidCredential("無効な認証情報です。"),
  userDisabled("このアカウントは凍結されています。"),
  userNotFound("ユーザーが見つかりません。"),
  wrongPassword("パスワードが間違っています。"),
  networkRequestFailed("通信に失敗しました。ネットワーク接続を確認してください。"),
  userTokenExpired("トークンの有効期限が切れました。サインアウトしてから再度サインインしてください。"),
  invalidActionCode("URLの有効期限が切れたか、無効なURLです。もう一度お試しください。"),
  emailAlreadyInUse("このメールアドレスは既に使用されています。"),
  credentialAlreadyInUse("このアカウントはすでに別のユーザーに紐づけられています。"),
  userMismatch("現在サインイン中のユーザーと異なるアカウントです。"),
  noLinkedProvider("このアカウントには紐づけられたプロバイダがありません。"),
  unknownProvider("この認証方法はサポートされていません。"),
  unknown("不明なエラーが発生しました。しばらく待ってからもう一度お試しください。"),
  ;

  final String userFriendlyMessage;

  const AuthErrorCode(this.userFriendlyMessage);

  factory AuthErrorCode.fromFirebaseAuthErrorCode(String code) {
    return switch (code.replaceFirst(RegExp("^auth/"), "")) {
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
      _ => AuthErrorCode.unknown,
    };
  }
}
