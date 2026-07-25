import "dart:async";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher/url_launcher_string.dart";

import "../../../../constants/urls.dart";
import "../../../../core/result/result.dart";
import "../../../logging/infrastructure/crashlytics.dart";
import "../../domain/models/auth_failure.dart";
import "../../domain/models/auth_mode.dart";
import "../../domain/models/social_provider.dart";
import "../../domain/use_cases/sign_in_by_mode_use_case.dart";
import "../../infrastructure/repositories/request_apple_credential_repository.dart";
import "../../infrastructure/repositories/request_google_credential_repository.dart";

part "sign_in_page_view_model.freezed.dart";
part "sign_in_page_view_model.g.dart";

@Freezed(copyWith: true)
sealed class SignInPageViewModel with _$SignInPageViewModel {
  const factory SignInPageViewModel({
    SocialProvider? loadingProvider,
  }) = _SignInPageViewModel;
}

@riverpod
class SignInPageViewModelNotifier extends _$SignInPageViewModelNotifier {
  @override
  SignInPageViewModel build() {
    return SignInPageViewModel();
  }

  ResultFuture<T, AuthFailure> _withRestoringState<T>(ResultFuture<T, AuthFailure> Function() action) async {
    try {
      return await action();
    } catch (e, st) {
      // unhandled error
      ref.read(errorReporterProvider).report(e, st);
      return Result.failed(AuthFailure(.unknown, e), st);
    } finally {
      state = state.copyWith(loadingProvider: null);
    }
  }

  void showTerms() {
    _launchInAppBrowser(tosUrl);
  }

  void showPrivacyPolicy() {
    _launchInAppBrowser(privacyPolicyUrl);
  }

  ResultFuture<SignInResult?, AuthFailure> socialSignIn(SocialProvider provider, AuthMode mode) async {
    state = state.copyWith(loadingProvider: provider);
    return await _withRestoringState(() async {
      final credResult = await switch (provider) {
        SocialProvider.apple => ref.read(requestAppleCredentialRepositoryProvider),
        SocialProvider.google => ref.read(requestGoogleCredentialRepositoryProvider),
      }.request();
      if (credResult case ResultFailed()) {
        return credResult.propagate();
      }

      final cred = credResult.asOk.value;
      if (cred == null) {
        return Result.ok(null); // canceled by user
      }

      final authResult = await ref.read(signInByModeUseCaseProvider)
          .execute(mode, cred);
      if (authResult case ResultFailed(:final propagate)) {
        return propagate();
      }

      return authResult;
    });
  }

  void _launchInAppBrowser(String url) {
    unawaited(launchUrlString(url, mode: LaunchMode.inAppBrowserView));
  }
}
