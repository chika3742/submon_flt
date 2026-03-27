import "package:google_sign_in/google_sign_in.dart";

class TasksAuthException implements Exception {
  final TasksAuthErrorCode code;

  const TasksAuthException(this.code);
}

enum TasksAuthErrorCode {
  failedToFetchUserEmail("ユーザのメールアドレスの取得に失敗しました。"),
  unknown("不明なエラーが発生しました。"),
  ;

  final String userFriendlyMessage;

  const TasksAuthErrorCode(this.userFriendlyMessage);

  factory TasksAuthErrorCode.fromGoogleSignInErrorCode(GoogleSignInExceptionCode code) {
    return switch (code) {
      _ => TasksAuthErrorCode.unknown,
    };
  }
}
