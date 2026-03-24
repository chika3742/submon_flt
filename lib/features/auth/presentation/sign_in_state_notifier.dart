import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/pref_key.dart";
import "../../../providers/core_providers.dart";
import "../../../utils/app_links.dart";
import "../../../utils/notifier_state_guard.dart";
import "../models/auth_exception.dart";
import "../repositories/auth_repository.dart";
import "../use_cases/common.dart";
import "../use_cases/complete_sign_in_use_case.dart";
import "../use_cases/sign_in_use_case.dart";

part "sign_in_state_notifier.g.dart";
part "sign_in_state_notifier.freezed.dart";

mixin AuthBusyState {}

@freezed
sealed class SignInState with _$SignInState {
  const factory SignInState.idle() = SignInStateIdle;

  @With<AuthBusyState>()
  const factory SignInState.busy() = SignInStateBusy;

  const factory SignInState.failed(Object error) = SignInStateFailed;

  const factory SignInState.signInSucceeded(
    CompleteSignInResult completionResult,
  ) = SignInStateSignInSucceeded;

  const factory SignInState.upgradeSucceeded() = SignInStateUpgradeSucceeded;

  const factory SignInState.reAuthSucceeded() = SignInStateReAuthSucceeded;

  @With<AuthBusyState>()
  const factory SignInState.waitingForPasswordSignIn() =
      SignInStateWaitingForPasswordSignIn;

  @With<AuthBusyState>()
  const factory SignInState.waitingForEmailLinkDialog() =
      SignInStateWaitingForEmailLinkDialog;

  const factory SignInState.signInLinkSent() = SignInStateSignInLinkSent;

  const factory SignInState.passwordResetLinkSent() = SignInStatePasswordResetLinkSent;
}

@riverpod
class SignInStateNotifier extends _$SignInStateNotifier with NotifierStateGuard {
  @override
  SignInState build() => SignInState.idle();

  @override
  @protected
  SignInState getErrorState(Object error, StackTrace st) {
    ref.read(crashlyticsProvider).recordError(error, st);
    return SignInState.failed(error);
  }

  Future<void> signInWithProvider(
    AuthProvider provider, {
    AuthMode mode = AuthMode.signIn,
  }) async {
    return guard(
      SignInState.busy(),
      () async {
        final signInResult = await ref.read(authUiUseCaseProvider)
            .execute(provider, mode);
        if (!signInResult) {
          return SignInState.idle();
        }

        return switch (mode) {
          AuthMode.upgrade => SignInState.upgradeSucceeded(),
          AuthMode.reauthenticate => SignInState.reAuthSucceeded(),
          AuthMode.signIn => await _completeSignIn(),
        };
      },
    );
  }

  Future<void> signInWithEmailPassword(
    String email,
    String password, {
    required AuthMode mode,
  }) async {
    return guard(
      SignInState.busy(),
      () async {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        switch (mode) {
          case AuthMode.signIn:
            await ref.read(authRepositoryProvider).signIn(credential);
          case AuthMode.upgrade:
            await ref.read(authRepositoryProvider).linkWithCredential(credential);
          case AuthMode.reauthenticate:
            await ref.read(authRepositoryProvider).reauthenticate(credential);
        }

        return switch (mode) {
          AuthMode.upgrade => SignInState.upgradeSucceeded(),
          AuthMode.reauthenticate => SignInState.reAuthSucceeded(),
          AuthMode.signIn => await _completeSignIn(),
        };
      },
    );
  }

  Future<void> sendSignInEmail(String email, AuthMode mode) {
    return guard(
      SignInState.busy(),
      () async {
        final continueUri = "https://$appDomain/auth-action?internalMode=${mode.name}";
        await ref.read(authRepositoryProvider)
            .sendSignInLinkToEmail(email, continueUri);
        ref.updatePref(PrefKey.emailForUrlLogin, email);
        return const SignInState.signInLinkSent();
      },
    );
  }

  Future<void> sendPasswordResetLink(String email) {
    return guard(
      SignInState.busy(),
      () async {
        await ref.read(authRepositoryProvider)
            .sendPasswordResetLink(email);
        return const SignInState.signInLinkSent();
      },
    );
  }

  Future<List<String>?> lookupEmailSignInMethod(String email) {
    return guardReturning(
      SignInState.busy(),
      () async {
        final methods = await ref.read(authRepositoryProvider)
            .fetchSignInMethodsForEmail(email);
        return (SignInState.idle(), methods);
      },
    );
  }

  Future<void> completeCurrentSignIn() {
    return guard(
      SignInState.busy(),
      () async => await _completeSignIn(),
    );
  }

  Future<void> reAuth() {
    return guard(
      SignInState.busy(),
      () async {
        final user = ref.read(firebaseUserProvider).requireValue;
        if (user == null) {
          throw AuthException(AuthErrorCode.notSignedIn);
        }

        final providerId = user.providerData.firstOrNull?.providerId;
        if (providerId == null) {
          final error = AuthException(AuthErrorCode.noLinkedProvider);
          ref.read(crashlyticsProvider).recordError(error, StackTrace.current);
          throw error;
        }

        if (providerId == EmailAuthProvider.PROVIDER_ID) {
          final methods = await ref.read(authRepositoryProvider)
              .fetchSignInMethodsForEmail(user.email!);

          if (methods.first == EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD) {
            return SignInState.waitingForEmailLinkDialog();
          }
          return SignInState.waitingForPasswordSignIn();
        }

        final AuthProvider provider;
        if (providerId == GoogleAuthProvider.PROVIDER_ID) {
          provider = AuthProvider.google;
        } else if (providerId == AppleAuthProvider.PROVIDER_ID) {
          provider = AuthProvider.apple;
        } else {
          throw AuthException(AuthErrorCode.unknownProvider);
        }

        await ref.read(authUiUseCaseProvider).execute(
            provider, AuthMode.reauthenticate);
        return const SignInState.reAuthSucceeded();
      },
    );
  }

  Future<void> confirmEmailLinkReAuth(String continueUri) async {
    return guard(
      SignInState.busy(),
      () async {
        final user = ref.read(firebaseUserProvider).requireValue;
        if (user == null) {
          throw AuthException(AuthErrorCode.notSignedIn);
        }
        await ref.read(authRepositoryProvider)
            .sendSignInLinkToEmail(user.email!, continueUri);

        return const SignInState.signInLinkSent();
      },
    );
  }

  Future<SignInState> _completeSignIn() async {
    try {
      final completionResult = await ref.read(completeSignInUseCaseProvider)
                  .execute();
      return SignInState.signInSucceeded(completionResult);
    } catch (e) {
      await ref.read(authRepositoryProvider).signOut();
      rethrow;
    }
  }
}
