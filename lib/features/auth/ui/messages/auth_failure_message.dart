import "../../domain/models/auth_failure.dart";

extension AuthFailureMessage on AuthFailure {
  String get displayMessage => switch (code) {
    .stateMismatch => "リクエスト改ざんの検証に失敗しました。もう一度お試しください。",
    .notSignedIn => "サインインが必要です。",
    .userAlreadyExists => "既に同じメールアドレスのアカウントが存在します。",
    .invalidCredential => "無効な認証情報です。",
    .userDisabled => "このアカウントは凍結されています。",
    .userNotFound => "ユーザーが見つかりません。",
    .wrongPassword => "パスワードが間違っています。",
    .networkRequestFailed => "通信に失敗しました。ネットワーク接続を確認してください。",
    .userTokenExpired => "トークンの有効期限が切れました。サインアウトしてから再度サインインしてください。",
    .invalidUrl => "URLの有効期限が切れたか、無効なURLです。もう一度お試しください。",
    .emailAlreadyInUse => "このメールアドレスは既に使用されています。",
    .credentialAlreadyInUse => "このアカウントはすでに別のユーザーに紐づけられています。",
    .userMismatch => "現在サインイン中のユーザーと異なるアカウントです。",
    .noLinkedProvider => "このアカウントには紐づけられたプロバイダがありません。",
    .unknownProvider => "この認証方法はサポートされていません。",
    .noSavedAuthEmail => "このデバイスでサインインしようとしたことを確認してください。",
    .weakPassword => "パスワードが短すぎます。最低6文字で指定してください。",
    .invalidEmail => "メールアドレスの形式が正しくありません。",
    .missingEmail => "メールアドレスを入力してください。", // バリデーションのすり抜けの可能性
    .requiresRecentLogin => "この操作をするには、再ログインが必要です。",
    .expiredActionCode => "このURLの有効期限が切れています。もう一度お試しください。",
    .unknown => "不明なエラーが発生しました。しばらく待ってからもう一度お試しください。",
  };
}
