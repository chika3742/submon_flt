import 'package:firebase_auth/firebase_auth.dart';

class SignInResult {
  UserCredential? credential;
  SignInError? errorCode;
  String? errorMessage;

  SignInResult({this.credential, this.errorCode, this.errorMessage});

  String toErrorMessageString() {
    return "$errorMessage (Code: ${errorCode.toString().replaceAll("SignInError.", "")})";
  }
}

enum SignInError {
  cancelled,
  socketError,
  twitterTimeOutOfSync,
  twitterRequestTokenRequestFailed,
  twitterAccessTokenRequestFailed,
  appleSignInFailed,
  notificationPermissionDenied,
  userNotFound,
  unknown,
}
