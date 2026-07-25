import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/core/result/result.dart";
import "package:submon/features/auth/domain/models/app_credential.dart";
import "package:submon/features/auth/domain/models/auth_failure.dart";
import "package:submon/features/auth/domain/models/auth_mode.dart";
import "package:submon/features/auth/domain/repositories/auth_repository.dart";
import "package:submon/features/auth/domain/use_cases/complete_sign_in_use_case.dart";
import "package:submon/features/auth/domain/use_cases/sign_in_by_mode_use_case.dart";

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCompleteSignInUseCase extends Mock implements CompleteSignInUseCase {}

void main() {
  late MockAuthRepository mockAuth;
  late SignInByModeUseCase useCase;
  late MockCompleteSignInUseCase mockCompleteUseCase;
  const cred = GoogleAppCredential(idToken: "token");

  setUpAll(() {
    registerFallbackValue(cred);
  });

  setUp(() {
    mockAuth = MockAuthRepository();
    mockCompleteUseCase = MockCompleteSignInUseCase();
    useCase = SignInByModeUseCase(mockAuth, mockCompleteUseCase);
  });

  group("execute", () {
    test("reauthenticate mode calls _auth.reauthenticate()", () async {
      when(() => mockAuth.reauthenticate(any()))
          .thenAnswer((_) async => Result.ok(null));

      final result = await useCase.execute(AuthMode.reauthenticate, cred);

      expect(result, isA<ResultOk>());
      verify(() => mockAuth.reauthenticate(cred)).called(1);
      verifyNever(() => mockAuth.signIn(any()));
      verifyNever(() => mockAuth.linkWithCredential(any()));
    });

    test("upgrade mode calls _auth.linkWithCredential()", () async {
      when(() => mockAuth.linkWithCredential(any()))
          .thenAnswer((_) async => Result.ok(null));

      final result = await useCase.execute(AuthMode.upgrade, cred);

      expect(result, isA<ResultOk>());
      verify(() => mockAuth.linkWithCredential(cred)).called(1);
    });

    test("propagates ResultFailed on auth failure", () async {
      when(() => mockAuth.reauthenticate(any())).thenAnswer(
        (_) async =>
            Result.failed(AuthFailure(AuthFailureCode.invalidCredential)),
      );

      final result = await useCase.execute(AuthMode.reauthenticate, cred);

      expect(result, isA<ResultFailed>());
      final failed = result as ResultFailed<SignInResult, AuthFailure>;
      expect(failed.error.code, AuthFailureCode.invalidCredential);
    });
  });

  test("calls completeSignIn only on signIn mode", () async {
    when(() => mockAuth.signIn(any()))
        .thenAnswer((_) async => Result.ok(null));
    when(() => mockAuth.reauthenticate(any()))
        .thenAnswer((_) async => Result.ok(null));
    when(() => mockAuth.linkWithCredential(any()))
        .thenAnswer((_) async => Result.ok(null));
    when(() => mockCompleteUseCase.execute())
        .thenAnswer((_) async => Result.ok(SignInCompletionResult(
      newUser: false,
      notificationPermissionDenied: false,
    )));

    await useCase.execute(AuthMode.signIn, cred);
    verify(() => mockCompleteUseCase.execute()).called(1);
    await useCase.execute(AuthMode.reauthenticate, cred);
    verifyNever(() => mockCompleteUseCase.execute());
    await useCase.execute(AuthMode.upgrade, cred);
    verifyNever(() => mockCompleteUseCase.execute());
  });
}
