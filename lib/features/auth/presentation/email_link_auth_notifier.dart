import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/pref_key.dart";
import "../../../providers/core_providers.dart";
import "../../../providers/link_events_provider.dart";
import "../../../utils/app_links.dart";
import "../../../utils/notifier_state_guard.dart";
import "../models/auth_continue_destination.dart";
import "../models/auth_exception.dart";
import "../use_cases/common.dart";
import "../use_cases/complete_sign_in_use_case.dart";
import "../use_cases/email_link_auth_use_case.dart";

part "email_link_auth_notifier.freezed.dart";
part "email_link_auth_notifier.g.dart";

@freezed
sealed class EmailLinkAuthState with _$EmailLinkAuthState {
  const factory EmailLinkAuthState.idle() = EmailLinkAuthStateIdle;

  const factory EmailLinkAuthState.processing() =
      EmailLinkAuthStateProcessing;

  const factory EmailLinkAuthState.signInSucceeded(
    CompleteSignInResult result,
  ) = EmailLinkAuthStateSignInSucceeded;

  const factory EmailLinkAuthState.reAuthSucceeded(
    AuthContinueDestination destination,
  ) = EmailLinkAuthStateReAuthSucceeded;

  const factory EmailLinkAuthState.upgradeSucceeded() =
      EmailLinkAuthStateUpgradeSucceeded;

  const factory EmailLinkAuthState.failed(Object error) =
      EmailLinkAuthStateFailed;
}

@Riverpod(keepAlive: true)
class EmailLinkAuthNotifier extends _$EmailLinkAuthNotifier
    with NotifierStateGuard {
  @override
  EmailLinkAuthState build() {
    ref.listen(linkEventsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        _handleUri(value.value);
      }
    });
    return const EmailLinkAuthState.idle();
  }

  @override
  @protected
  EmailLinkAuthState getErrorState(Object error, StackTrace st) {
    ref.read(crashlyticsProvider).recordError(error, st);
    return EmailLinkAuthState.failed(error);
  }

  void _handleUri(Uri url) {
    final authUrl = resolveAuthActionUrl(url);
    if (authUrl == null) return;

    if (!ref.read(firebaseAuthProvider)
        .isSignInWithEmailLink(authUrl.toString())) {
      return;
    }

    final email = ref.readPref(PrefKey.emailForUrlLogin);
    if (email == null) {
      state = EmailLinkAuthState.failed(
        AuthException(AuthErrorCode.noSavedAuthEmail),
      );
      return;
    }

    final continueUrlStr = authUrl.queryParameters["continueUrl"];
    final continueUri =
        continueUrlStr != null ? Uri.parse(continueUrlStr) : null;

    final AuthMode mode;
    if (continueUri == null || continueUri.path == "/auth-action") {
      final modeName = continueUri?.queryParameters["internalMode"];
      mode = modeName != null
          ? AuthMode.values.firstWhere((e) => e.name == modeName)
          : AuthMode.signIn;
    } else {
      mode = AuthMode.reauthenticate;
    }

    if (mode == AuthMode.reauthenticate && continueUri == null) {
      state = EmailLinkAuthState.failed(
        AuthException(AuthErrorCode.missingContinueUrl),
      );
      return;
    }

    guard(
      const EmailLinkAuthState.processing(),
      () async {
        await ref
            .read(emailLinkAuthUseCaseProvider)
            .execute(mode, email, authUrl.toString());

        return switch (mode) {
          AuthMode.signIn => EmailLinkAuthState.signInSucceeded(
              await ref.read(completeSignInUseCaseProvider).execute(),
            ),
          AuthMode.reauthenticate => EmailLinkAuthState.reAuthSucceeded(
              AuthContinueDestination.fromUri(continueUri!),
            ),
          AuthMode.upgrade => const EmailLinkAuthState.upgradeSucceeded(),
        };
      },
    );
  }
}
