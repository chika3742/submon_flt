import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../core/failure.dart";
import "../../../providers/link_events_provider.dart";
import "../../../utils/app_links.dart";
import "../../../utils/notifier_state_guard.dart";
import "../models/auth_exception.dart";
import "../repositories/auth_repository.dart";
import "../use_cases/sign_out_use_case.dart";

part "auth_action_notifier.freezed.dart";
part "auth_action_notifier.g.dart";

@freezed
sealed class AuthActionState with _$AuthActionState {
  const factory AuthActionState.idle() = AuthActionStateIdle;

  const factory AuthActionState.processing() = AuthActionStateProcessing;

  const factory AuthActionState.signedOut() = AuthActionStateSignedOut;

  @Implements<ErrorState>()
  const factory AuthActionState.failed(
    Object error,
    StackTrace errorStackTrace,
  ) = AuthActionStateFailed;
}

@Riverpod(keepAlive: true)
class AuthActionNotifier extends _$AuthActionNotifier
    with NotifierStateGuard {
  @override
  AuthActionState build() {
    ref.listen(linkEventsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        _handleUri(value.value);
      }
    });
    return const AuthActionState.idle();
  }

  @override
  @protected
  AuthActionState getErrorState(Object error, StackTrace st) {
    return AuthActionState.failed(error, st);
  }

  void _handleUri(Uri url) {
    final authUrl = resolveAuthActionUrl(url);
    if (authUrl == null) return;

    switch (authUrl.queryParameters["mode"]) {
      case "resetPassword":
      case "recoverEmail":
        launchUrl(authUrl, mode: LaunchMode.externalApplication);
      case "verifyAndChangeEmail":
        guard(
          const AuthActionState.processing(),
          () async {
            final oobCode = authUrl.queryParameters["oobCode"];
            if (oobCode == null) {
              throw AuthException(AuthErrorCode.invalidActionCode);
            }

            await ref.read(authRepositoryProvider).checkActionCode(oobCode);
            await ref.read(signOutUseCaseProvider).execute();
            await launchUrl(authUrl, mode: LaunchMode.externalApplication);
            return const AuthActionState.signedOut();
          },
        );
    }
  }
}
