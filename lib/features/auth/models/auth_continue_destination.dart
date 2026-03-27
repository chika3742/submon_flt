import "package:freezed_annotation/freezed_annotation.dart";

import "../../../pages/settings/account_edit_page.dart";
import "../../../utils/app_links.dart";

part "auth_continue_destination.freezed.dart";

@freezed
sealed class AuthContinueDestination with _$AuthContinueDestination {
  const AuthContinueDestination._();

  const factory AuthContinueDestination.changeEmail({
    required String newEmail,
  }) = AuthContinueDestinationChangeEmail;

  const factory AuthContinueDestination.deleteAccount() =
      AuthContinueDestinationDeleteAccount;

  factory AuthContinueDestination.fromUri(Uri uri) {
    return switch (uri.path) {
      AccountEditPage.changeEmailRouteName =>
        AuthContinueDestination.changeEmail(
          newEmail: uri.queryParameters["new_email"]!,
        ),
      AccountEditPage.deleteRouteName =>
        const AuthContinueDestination.deleteAccount(),
      _ => throw ArgumentError("Unknown continue path: ${uri.path}"),
    };
  }

  Uri toUri() => switch (this) {
    AuthContinueDestinationChangeEmail(:final newEmail) => Uri(
      scheme: "https",
      host: appDomain,
      path: AccountEditPage.changeEmailRouteName,
      queryParameters: {"new_email": newEmail},
    ),
    AuthContinueDestinationDeleteAccount() => Uri(
      scheme: "https",
      host: appDomain,
      path: AccountEditPage.deleteRouteName,
    ),
  };

  String get routeName => switch (this) {
    AuthContinueDestinationChangeEmail() =>
      AccountEditPage.changeEmailRouteName,
    AuthContinueDestinationDeleteAccount() =>
      AccountEditPage.deleteRouteName,
  };

  Object? get routeArguments => switch (this) {
    AuthContinueDestinationChangeEmail(:final newEmail) =>
      AccountEditPageArguments(newEmail),
    AuthContinueDestinationDeleteAccount() => null,
  };
}
