class AuthFailure {
  final AuthFailureCode code;
  final Object? cause;

  const AuthFailure(this.code, [this.cause]);

  @override
  String toString() {
    return "AuthFailure: ${code.name}";
  }
}

enum AuthFailureCode {
  /// Security state does not match on Sign in with Apple
  stateMismatch,

  /// Operation performed without authentication
  notSignedIn,

  /// Tried to sign in with social account which has the same email as the
  /// already registered one.
  userAlreadyExists(isCommonError: true),

  /// Authentication failure
  invalidCredential,
  userDisabled(isCommonError: true),
  userNotFound(isCommonError: true),
  wrongPassword(isCommonError: true),
  networkRequestFailed(isCommonError: true),
  userTokenExpired,

  /// Invalid email link
  invalidUrl(isCommonError: true),

  /// Email already registered.
  emailAlreadyInUse(isCommonError: true),

  /// Tried to link with social account already linked to another account.
  credentialAlreadyInUse(isCommonError: true),

  /// Reauthenticated user does not match the current user.
  userMismatch(isCommonError: true),
  noLinkedProvider,
  unknownProvider,

  noSavedAuthEmail,
  weakPassword(isCommonError: true),
  invalidEmail(isCommonError: true),
  missingEmail, // バリデーションのすり抜けの可能性
  requiresRecentLogin(isCommonError: true),
  expiredActionCode(isCommonError: true),
  unknown,
  ;

  /// If this flag is true, the error will not be reported to Crashlytics.
  final bool isCommonError;

  const AuthFailureCode({this.isCommonError = false});
}
