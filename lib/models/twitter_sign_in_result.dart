import 'package:submon/models/sign_in_result.dart';

class TwitterSignInResult {
  TwitterSignInResult(
      {this.accessToken, this.accessTokenSecret, this.errorCode, this.errorMessage});

  final String? accessToken;
  final String? accessTokenSecret;
  final SignInError? errorCode;
  final String? errorMessage;

  @override
  String toString() {
    return "oauthToken: $accessToken, oauthSecret: $accessTokenSecret";
  }

  SignInResult toSignInResult() {
    return SignInResult(errorCode: errorCode, errorMessage: errorMessage);
  }
}
