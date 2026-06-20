import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/auth/models/auth_exception.dart";
import "package:submon/features/auth/repositories/auth_repository.dart";
import "package:submon/features/auth/use_cases/common.dart";
import "package:submon/features/auth/use_cases/email_link_auth_use_case.dart";

class MockAuthRepository extends Mock implements AuthRepository {}

class _FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthCredential());
  });

  late MockAuthRepository repo;
  late EmailLinkAuthUseCase useCase;

  setUp(() {
    repo = MockAuthRepository();
    useCase = EmailLinkAuthUseCase(repo);
    when(() => repo.signIn(any())).thenAnswer((_) async {});
    when(() => repo.reauthenticate(any())).thenAnswer((_) async {});
    when(() => repo.linkWithCredential(any())).thenAnswer((_) async {});
  });

  group("mode によるルーティング", () {
    test("signIn → repo.signIn", () async {
      await useCase.execute(AuthMode.signIn, "a@example.com", "link");

      verify(() => repo.signIn(any())).called(1);
      verifyNever(() => repo.reauthenticate(any()));
      verifyNever(() => repo.linkWithCredential(any()));
    });

    test("reauthenticate → repo.reauthenticate", () async {
      await useCase.execute(AuthMode.reauthenticate, "a@example.com", "link");

      verify(() => repo.reauthenticate(any())).called(1);
      verifyNever(() => repo.signIn(any()));
    });

    test("upgrade → repo.linkWithCredential", () async {
      await useCase.execute(AuthMode.upgrade, "a@example.com", "link");

      verify(() => repo.linkWithCredential(any())).called(1);
      verifyNever(() => repo.signIn(any()));
    });
  });

  test("repo が AuthException を投げたら伝播する", () async {
    when(() => repo.signIn(any()))
        .thenThrow(const AuthException(AuthErrorCode.invalidCredential));

    expect(
      () => useCase.execute(AuthMode.signIn, "a@example.com", "link"),
      throwsA(isA<AuthException>()),
    );
  });
}
