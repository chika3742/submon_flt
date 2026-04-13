import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/result/result.dart";
import "../models/auth_failure.dart";
import "sign_in_by_mode_use_case.dart";

part "complete_sign_in_use_case.g.dart";

class CompleteSignInUseCase {
  ResultFuture<SignInCompletionResult, AuthFailure> execute() async {
    // TODO: implement complete sign in
    throw UnimplementedError();
  }
}

@riverpod
CompleteSignInUseCase completeSignInUseCase(Ref ref) {
  return CompleteSignInUseCase();
}
