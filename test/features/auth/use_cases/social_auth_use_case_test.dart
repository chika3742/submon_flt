import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/auth/models/auth_exception.dart";
import "package:submon/features/auth/repositories/auth_repository.dart";
import "package:submon/features/auth/use_cases/common.dart";
import "package:submon/features/auth/use_cases/social_auth_use_case.dart";

class MockAuthRepository extends Mock implements AuthRepository {}

class _FakeOAuthCredential extends Fake implements OAuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeOAuthCredential());
  });

  late MockAuthRepository repo;
  late SocialAuthUseCase useCase;

  setUp(() {
    repo = MockAuthRepository();
    useCase = SocialAuthUseCase(repo);
    when(() => repo.signIn(any())).thenAnswer((_) async {});
    when(() => repo.reauthenticate(any())).thenAnswer((_) async {});
    when(() => repo.linkWithCredential(any())).thenAnswer((_) async {});
  });

  FetchCredentialResult success() =>
      FetchCredentialResult.success(credential: _FakeOAuthCredential());

  group("credential fetch by provider", () {
    test("google -> fetchGoogleCredential", () async {
      when(() => repo.fetchGoogleCredential())
          .thenAnswer((_) async => success());

      await useCase.execute(AuthProvider.google, AuthMode.signIn);

      verify(() => repo.fetchGoogleCredential()).called(1);
      verifyNever(() => repo.fetchAppleCredential());
    });

    test("apple -> fetchAppleCredential", () async {
      when(() => repo.fetchAppleCredential())
          .thenAnswer((_) async => success());

      await useCase.execute(AuthProvider.apple, AuthMode.signIn);

      verify(() => repo.fetchAppleCredential()).called(1);
      verifyNever(() => repo.fetchGoogleCredential());
    });
  });

  test("returns false and performs no auth when canceled", () async {
    when(() => repo.fetchGoogleCredential())
        .thenAnswer((_) async => FetchCredentialResult.canceled());

    final result = await useCase.execute(AuthProvider.google, AuthMode.signIn);

    expect(result, isFalse);
    verifyNever(() => repo.signIn(any()));
    verifyNever(() => repo.reauthenticate(any()));
    verifyNever(() => repo.linkWithCredential(any()));
  });

  group("mode routing and return value on success", () {
    setUp(() {
      when(() => repo.fetchGoogleCredential())
          .thenAnswer((_) async => success());
    });

    test("signIn -> repo.signIn, returns true", () async {
      final result = await useCase.execute(AuthProvider.google, AuthMode.signIn);

      expect(result, isTrue);
      verify(() => repo.signIn(any())).called(1);
    });

    test("reauthenticate -> repo.reauthenticate", () async {
      await useCase.execute(AuthProvider.google, AuthMode.reauthenticate);
      verify(() => repo.reauthenticate(any())).called(1);
    });

    test("upgrade -> repo.linkWithCredential", () async {
      await useCase.execute(AuthProvider.google, AuthMode.upgrade);
      verify(() => repo.linkWithCredential(any())).called(1);
    });
  });

  test("propagates AuthException thrown by the repo", () async {
    when(() => repo.fetchGoogleCredential())
        .thenAnswer((_) async => success());
    when(() => repo.signIn(any()))
        .thenThrow(const AuthException(AuthErrorCode.userDisabled));

    expect(
      () => useCase.execute(AuthProvider.google, AuthMode.signIn),
      throwsA(isA<AuthException>()),
    );
  });
}
