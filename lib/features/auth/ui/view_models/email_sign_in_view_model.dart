import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/result/result.dart";
import "../../domain/models/app_credential.dart";
import "../../domain/models/auth_failure.dart";
import "../../domain/models/auth_mode.dart";
import "../../domain/use_cases/sign_in_by_mode_use_case.dart";
import "../../infrastructure/repositories/firebase_auth_repository.dart";

part "email_sign_in_view_model.g.dart";
part "email_sign_in_view_model.freezed.dart";

@Freezed(copyWith: true)
sealed class EmailSignInPageState with _$EmailSignInPageState {
  const factory EmailSignInPageState({
    required bool processing,
  }) = _EmailSignInPageState;
}

@riverpod
class EmailSignInViewModel extends _$EmailSignInViewModel {
  @override
  EmailSignInPageState build() {
    return EmailSignInPageState(
      processing: false,
    );
  }

  Future<T> guard<T>(Future<T> Function() action) async {
    state = state.copyWith(processing: true);
    try {
      return await action();
    } finally {
      state = state.copyWith(processing: false);
    }
  }

  ResultFuture<void, AuthFailure> sendSignInEmail(String email, AuthMode mode, [String? destinationAfterReAuth]) {
    return guard(() =>
        ref.read(authRepositoryProvider)
            .sendSignInLinkToEmail(email, mode, destinationAfterReAuth));
  }

  ResultFuture<SignInResult, AuthFailure> signInWithPassword(String email, String password, AuthMode mode) {
    return guard(() => ref.read(signInByModeUseCaseProvider).execute(
      mode,
      EmailPasswordAppCredential(email: email, password: password),
    ));
  }

  ResultFuture<void, AuthFailure> sendPasswordResetEmail(String email) {
    return guard(() => ref.read(authRepositoryProvider)
        .sendPasswordResetLink(email));
  }
}
