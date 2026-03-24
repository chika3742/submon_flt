import "../repositories/auth_repository.dart";
import "common.dart";

class EmailLinkAuthUseCase {
  final AuthRepository _repo;

  const EmailLinkAuthUseCase(this._repo);

  Future<void> execute(String modeString, String email, String emailLink) {
    final mode = AuthMode.values.firstWhere(
      (e) => e.toString() == modeString,
      orElse: () => throw ArgumentError("Invalid sign-in mode: $modeString"),
    );

    final credential = AuthRepository.createEmailLinkCredential(
      email,
      emailLink,
    );

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
