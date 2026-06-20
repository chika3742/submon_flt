import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/features/auth/repositories/auth_repository.dart";
import "package:submon/features/auth/use_cases/link_social_use_case.dart";

class MockAuthRepository extends Mock implements AuthRepository {}

class _FakeOAuthCredential extends Fake implements OAuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeOAuthCredential());
  });

  late MockAuthRepository repo;
  late LinkSocialUseCase useCase;

  setUp(() {
    repo = MockAuthRepository();
    useCase = LinkSocialUseCase(repo);
    when(() => repo.linkWithCredential(any())).thenAnswer((_) async {});
  });

  test("on success calls linkWithCredential and returns success", () async {
    when(() => repo.fetchGoogleCredential()).thenAnswer(
      (_) async => FetchCredentialResult.success(credential: _FakeOAuthCredential()),
    );

    final result = await useCase.execute(AuthProvider.google);

    expect(result, LinkSocialResult.success);
    verify(() => repo.linkWithCredential(any())).called(1);
  });

  test("on cancel returns canceled and does not call linkWithCredential",
      () async {
    when(() => repo.fetchAppleCredential())
        .thenAnswer((_) async => FetchCredentialResult.canceled());

    final result = await useCase.execute(AuthProvider.apple);

    expect(result, LinkSocialResult.canceled);
    verifyNever(() => repo.linkWithCredential(any()));
  });

  test("apple provider uses fetchAppleCredential", () async {
    when(() => repo.fetchAppleCredential()).thenAnswer(
      (_) async => FetchCredentialResult.success(credential: _FakeOAuthCredential()),
    );

    await useCase.execute(AuthProvider.apple);

    verify(() => repo.fetchAppleCredential()).called(1);
    verifyNever(() => repo.fetchGoogleCredential());
  });
}
