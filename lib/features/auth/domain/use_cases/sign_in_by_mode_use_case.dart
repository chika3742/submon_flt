import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/result/result.dart";
import "../../infrastructure/repositories/firebase_auth_repository.dart";
import "../models/app_credential.dart";
import "../models/auth_failure.dart";
import "../models/auth_mode.dart";
import "../repositories/auth_repository.dart";
import "complete_sign_in_use_case.dart";

part "sign_in_by_mode_use_case.g.dart";
part "sign_in_by_mode_use_case.freezed.dart";

@freezed
sealed class SignInResult with _$SignInResult {
  const factory SignInResult({
    required AuthMode mode,
    SignInCompletionResult? signInCompletionResult,
  }) = _SignInResult;
}

@freezed
sealed class SignInCompletionResult with _$SignInCompletionResult {
  const factory SignInCompletionResult({
    required bool newUser,
    required bool notificationPermissionDenied,
  }) = _SignInCompletionResult;
}

class SignInByModeUseCase {
  final AuthRepository _auth;
  final CompleteSignInUseCase _completeSignIn;

  const SignInByModeUseCase(this._auth, this._completeSignIn);

  ResultFuture<SignInResult, AuthFailure> execute(AuthMode mode, AppCredential cred) async {
    final authResult = await switch (mode) {
      AuthMode.signIn => _auth.signIn(cred),
      AuthMode.reauthenticate => _auth.reauthenticate(cred),
      AuthMode.upgrade => _auth.linkWithCredential(cred),
    };
    if (authResult case ResultFailed(:final propagate)) {
      return propagate();
    }

    SignInCompletionResult? signInCompletionResult;
    if (mode == .signIn) {
      final result = await _completeSignIn.execute();
      if (result case ResultFailed(:final propagate)) {
        return propagate();
      }
      signInCompletionResult = result.asOk.value;
    }

    return Result.ok(SignInResult(
      mode: mode,
      signInCompletionResult: signInCompletionResult,
    ));
  }
}

@riverpod
SignInByModeUseCase signInByModeUseCase(Ref ref) {
  return SignInByModeUseCase(
    ref.watch(authRepositoryProvider),
    ref.watch(completeSignInUseCaseProvider),
  );
}
