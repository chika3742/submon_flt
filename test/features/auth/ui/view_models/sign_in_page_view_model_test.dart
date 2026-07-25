import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:submon/core/result/result.dart";
import "package:submon/features/auth/domain/models/app_credential.dart";
import "package:submon/features/auth/domain/models/auth_failure.dart";
import "package:submon/features/auth/domain/models/auth_mode.dart";
import "package:submon/features/auth/domain/models/social_provider.dart";
import "package:submon/features/auth/domain/use_cases/sign_in_by_mode_use_case.dart";
import "package:submon/features/auth/infrastructure/repositories/request_apple_credential_repository.dart";
import "package:submon/features/auth/infrastructure/repositories/request_google_credential_repository.dart";
import "package:submon/features/auth/ui/view_models/sign_in_page_view_model.dart";
import "package:submon/features/logging/domain/error_reporter.dart";
import "package:submon/features/logging/infrastructure/crashlytics.dart";

class MockRequestGoogleCredentialRepository extends Mock
    implements RequestGoogleCredentialRepository {}

class MockRequestAppleCredentialRepository extends Mock
    implements RequestAppleCredentialRepository {}

class MockSignInByModeUseCase extends Mock implements SignInByModeUseCase {}

class MockErrorReporter extends Mock implements ErrorReporter {}

void main() {
  late MockRequestGoogleCredentialRepository mockGoogleRepo;
  late MockRequestAppleCredentialRepository mockAppleRepo;
  late MockSignInByModeUseCase mockUseCase;
  late MockErrorReporter mockReporter;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const GoogleAppCredential(idToken: "fallback"));
    registerFallbackValue(AuthMode.signIn);
  });

  setUp(() {
    mockGoogleRepo = MockRequestGoogleCredentialRepository();
    mockAppleRepo = MockRequestAppleCredentialRepository();
    mockUseCase = MockSignInByModeUseCase();
    mockReporter = MockErrorReporter();

    container = ProviderContainer(
      overrides: [
        requestGoogleCredentialRepositoryProvider
            .overrideWithValue(mockGoogleRepo),
        requestAppleCredentialRepositoryProvider
            .overrideWithValue(mockAppleRepo),
        signInByModeUseCaseProvider.overrideWithValue(mockUseCase),
        errorReporterProvider.overrideWithValue(mockReporter),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  SignInPageViewModelNotifier notifier() =>
      container.read(signInPageViewModelProvider.notifier);

  SignInPageViewModel state() =>
      container.read(signInPageViewModelProvider);

  group("socialSignIn", () {
    test("Google success returns SignInResult", () async {
      const cred = GoogleAppCredential(idToken: "token");
      const signInResult = SignInResult(mode: AuthMode.reauthenticate);

      when(() => mockGoogleRepo.request())
          .thenAnswer((_) async => Result.ok(cred));
      when(() => mockUseCase.execute(any(), any()))
          .thenAnswer((_) async => Result.ok(signInResult));

      final result = await notifier().socialSignIn(
        SocialProvider.google,
        AuthMode.reauthenticate,
      );

      expect(result, isA<ResultOk>());
      expect((result as ResultOk).value, signInResult);
      expect(state().loadingProvider, isNull);
      verify(() => mockGoogleRepo.request()).called(1);
    });

    test("Apple success returns SignInResult", () async {
      const cred = AppleAppCredential(
        accessToken: "a",
        idToken: "i",
        rawNonce: "n",
      );
      const signInResult = SignInResult(mode: AuthMode.upgrade);

      when(() => mockAppleRepo.request())
          .thenAnswer((_) async => Result.ok(cred));
      when(() => mockUseCase.execute(any(), any()))
          .thenAnswer((_) async => Result.ok(signInResult));

      final result = await notifier().socialSignIn(
        SocialProvider.apple,
        AuthMode.upgrade,
      );

      expect(result, isA<ResultOk>());
      verify(() => mockAppleRepo.request()).called(1);
    });

    test("user cancellation returns ResultOk(null)", () async {
      when(() => mockGoogleRepo.request())
          .thenAnswer((_) async => Result.ok(null));

      final result = await notifier().socialSignIn(
        SocialProvider.google,
        AuthMode.signIn,
      );

      expect(result, isA<ResultOk>());
      expect((result as ResultOk).value, isNull);
      expect(state().loadingProvider, isNull);
      verifyNever(() => mockUseCase.execute(any(), any()));
    });

    test("credential request failure propagates ResultFailed", () async {
      when(() => mockGoogleRepo.request()).thenAnswer(
        (_) async =>
            Result.failed(AuthFailure(AuthFailureCode.unknown)),
      );

      final result = await notifier().socialSignIn(
        SocialProvider.google,
        AuthMode.signIn,
      );

      expect(result, isA<ResultFailed>());
      expect(state().loadingProvider, isNull);
    });

    test("use case failure propagates ResultFailed", () async {
      const cred = GoogleAppCredential(idToken: "t");
      when(() => mockGoogleRepo.request())
          .thenAnswer((_) async => Result.ok(cred));
      when(() => mockUseCase.execute(any(), any())).thenAnswer(
        (_) async => Result.failed(
          AuthFailure(AuthFailureCode.userMismatch),
        ),
      );

      final result = await notifier().socialSignIn(
        SocialProvider.google,
        AuthMode.reauthenticate,
      );

      expect(result, isA<ResultFailed>());
      final failed = result as ResultFailed<SignInResult?, AuthFailure>;
      expect(failed.error.code, AuthFailureCode.userMismatch);
      expect(state().loadingProvider, isNull);
    });

    test("loadingProvider is cleared after completion", () async {
      when(() => mockGoogleRepo.request())
          .thenAnswer((_) async => Result.ok(null));

      final future = notifier().socialSignIn(
        SocialProvider.google,
        AuthMode.signIn,
      );

      await future;
      expect(state().loadingProvider, isNull);
    });
  });
}
