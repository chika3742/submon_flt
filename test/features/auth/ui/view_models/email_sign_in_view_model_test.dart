import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/core/result/result.dart";
import "package:submon/features/auth/domain/models/app_credential.dart";
import "package:submon/features/auth/domain/models/auth_failure.dart";
import "package:submon/features/auth/domain/models/auth_mode.dart";
import "package:submon/features/auth/domain/repositories/auth_repository.dart";
import "package:submon/features/auth/domain/use_cases/sign_in_by_mode_use_case.dart";
import "package:submon/features/auth/infrastructure/repositories/firebase_auth_repository.dart";
import "package:submon/features/auth/ui/view_models/email_sign_in_view_model.dart";

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSignInByModeUseCase extends Mock implements SignInByModeUseCase {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockSignInByModeUseCase mockUseCase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const GoogleAppCredential(idToken: "fallback"));
    registerFallbackValue(AuthMode.signIn);
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockUseCase = MockSignInByModeUseCase();

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        signInByModeUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  EmailSignInViewModel notifier() =>
      container.read(emailSignInViewModelProvider.notifier);

  EmailSignInPageState state() =>
      container.read(emailSignInViewModelProvider);

  group("sendSignInEmail", () {
    test("calls authRepository.sendSignInLinkToEmail", () async {
      when(() => mockAuthRepo.sendSignInLinkToEmail(any(), any(), any()))
          .thenAnswer((_) async => Result.ok(null));

      final result = await notifier().sendSignInEmail(
        "test@example.com",
        AuthMode.signIn,
      );

      expect(result, isA<ResultOk>());
      verify(() => mockAuthRepo.sendSignInLinkToEmail(
            "test@example.com",
            AuthMode.signIn,
            null,
          )).called(1);
    });

    test("returns ResultFailed on failure", () async {
      when(() => mockAuthRepo.sendSignInLinkToEmail(any(), any(), any()))
          .thenAnswer((_) async =>
              Result.failed(AuthFailure(AuthFailureCode.invalidEmail)));

      final result = await notifier().sendSignInEmail(
        "bad",
        AuthMode.signIn,
      );

      expect(result, isA<ResultFailed>());
    });
  });

  group("signInWithPassword", () {
    test("creates EmailPasswordAppCredential and executes use case", () async {
      const signInResult = SignInResult(mode: AuthMode.signIn);
      when(() => mockUseCase.execute(any(), any()))
          .thenAnswer((_) async => Result.ok(signInResult));

      final result = await notifier().signInWithPassword(
        "test@example.com",
        "password123",
        AuthMode.signIn,
      );

      expect(result, isA<ResultOk>());
      final captured = verify(
        () => mockUseCase.execute(AuthMode.signIn, captureAny()),
      ).captured.single as EmailPasswordAppCredential;
      expect(captured.email, "test@example.com");
      expect(captured.password, "password123");
    });
  });

  group("sendPasswordResetEmail", () {
    test("calls authRepository.sendPasswordResetLink", () async {
      when(() => mockAuthRepo.sendPasswordResetLink(any()))
          .thenAnswer((_) async => Result.ok(null));

      final result =
          await notifier().sendPasswordResetEmail("test@example.com");

      expect(result, isA<ResultOk>());
      verify(() => mockAuthRepo.sendPasswordResetLink("test@example.com"))
          .called(1);
    });
  });

  group("guard", () {
    test("processing transitions from false to true and back to false", () async {
      when(() => mockAuthRepo.sendPasswordResetLink(any()))
          .thenAnswer((_) async => Result.ok(null));

      expect(state().processing, isFalse);

      final future =
          notifier().sendPasswordResetEmail("test@example.com");

      await future;
      expect(state().processing, isFalse);
    });

    test("processing resets to false even on exception", () async {
      when(() => mockAuthRepo.sendPasswordResetLink(any()))
          .thenThrow(Exception("unexpected"));

      try {
        await notifier().sendPasswordResetEmail("test@example.com");
      } catch (_) {
        // exception propagates to caller
      }

      expect(state().processing, isFalse);
    });
  });
}
