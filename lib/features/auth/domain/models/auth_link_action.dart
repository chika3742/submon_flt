import "package:freezed_annotation/freezed_annotation.dart";

import "auth_mode.dart";

part "auth_link_action.freezed.dart";

/// Resolved auth action from a deep link URI.
/// All fields are pre-validated by [AuthActionResolver].
@freezed
sealed class AuthLinkAction with _$AuthLinkAction {
  /// Email link sign-in action.
  const factory AuthLinkAction.emailSignIn({
    required String email,
    required String emailLink,
    required AuthMode mode,
    Uri? continueUrl,
  }) = EmailSignInAuthLinkAction;

  /// verifyAndChangeEmail action.
  const factory AuthLinkAction.verifyAndChangeEmail({
    required String oobCode,
    required Uri authUrl,
  }) = VerifyAndChangeEmailAuthLinkAction;

  /// resetPassword / recoverEmail — open in external browser.
  const factory AuthLinkAction.external({
    required Uri url,
  }) = ExternalAuthAuthLinkAction;
}
