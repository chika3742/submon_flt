import "package:riverpod_annotation/riverpod_annotation.dart";

import "../repositories/auth_repository.dart";
import "common.dart";

part "email_link_auth_use_case.g.dart";

@Riverpod(keepAlive: true)
EmailLinkAuthUseCase emailLinkAuthUseCase(Ref ref) {
  return EmailLinkAuthUseCase(ref.watch(authRepositoryProvider));
}

class EmailLinkAuthUseCase {
  final AuthRepository _repo;

  const EmailLinkAuthUseCase(this._repo);

  Future<void> execute(AuthMode mode, String email, String emailLink) {
    final credential = AuthRepository.createEmailLinkCredential(email, emailLink);

    switch (mode) {
      case AuthMode.signIn:
        return _repo.signIn(credential);
      case AuthMode.reauthenticate:
        return _repo.reauthenticate(credential);
      case AuthMode.upgrade:
        return _repo.linkWithCredential(credential);
    }
  }
}
