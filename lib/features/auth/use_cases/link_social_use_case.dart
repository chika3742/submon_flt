import "package:riverpod_annotation/riverpod_annotation.dart";

import "../repositories/auth_repository.dart";

part "link_social_use_case.g.dart";

@riverpod
LinkSocialUseCase linkSocialUseCase(Ref ref) {
  return LinkSocialUseCase(ref.watch(authRepositoryProvider));
}

enum LinkSocialResult {
  success,
  canceled,
}

class LinkSocialUseCase {
  final AuthRepository _repo;

  LinkSocialUseCase(this._repo);

  Future<LinkSocialResult> execute(AuthProvider provider) async {
    final fetchCredentialResult = switch (provider) {
      AuthProvider.google => await _repo.fetchGoogleCredential(),
      AuthProvider.apple => await _repo.fetchAppleCredential(),
    };

    switch (fetchCredentialResult) {
      case FetchCredentialResultSuccess(:final credential):
        await _repo.linkWithCredential(credential);
        return LinkSocialResult.success;

      case FetchCredentialResultCanceled():
        return LinkSocialResult.canceled;
    }
  }
}
