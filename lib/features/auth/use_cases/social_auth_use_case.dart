import "package:riverpod_annotation/riverpod_annotation.dart";

import "../repositories/auth_repository.dart";
import "common.dart";

part "social_auth_use_case.g.dart";

@riverpod
SocialAuthUseCase socialAuthUseCase(Ref ref) {
  return SocialAuthUseCase(ref.watch(authRepositoryProvider));
}

class SocialAuthUseCase {
  final AuthRepository _repo;

  const SocialAuthUseCase(this._repo);

  /// Returns `true` if sign-in succeeded, `false` if the user canceled the
  /// sign-in flow.
  Future<bool> execute(AuthProvider provider, AuthMode mode) async {
    final fetchCredentialResult = switch (provider) {
      AuthProvider.google => await _repo.fetchGoogleCredential(),
      AuthProvider.apple => await _repo.fetchAppleCredential(),
    };

    if (fetchCredentialResult is FetchCredentialResultCanceled) {
      return false;
    }
    fetchCredentialResult as FetchCredentialResultSuccess;

    switch (mode) {
      case AuthMode.signIn:
        await _repo.signIn(fetchCredentialResult.credential);
      case AuthMode.reauthenticate:
        await _repo.reauthenticate(fetchCredentialResult.credential);
      case AuthMode.upgrade:
        await _repo.linkWithCredential(fetchCredentialResult.credential);
    }
    return true;
  }
}
