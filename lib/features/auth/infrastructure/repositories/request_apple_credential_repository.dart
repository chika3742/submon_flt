import "dart:io";

import "package:flutter/services.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";

import "../../../../core/result/result.dart";
import "../../../../utils/sha256_of_string.dart";
import "../../../logging/domain/error_reporter.dart";
import "../../../logging/infrastructure/crashlytics.dart";
import "../../domain/models/app_credential.dart";
import "../../domain/models/auth_failure.dart";
import "../../domain/repositories/request_credential_repository.dart";
import "../services/web_based_sign_in_with_apple.dart";

part "request_apple_credential_repository.g.dart";

class RequestAppleCredentialRepository implements RequestCredentialRepository {
  final ErrorReporter _reporter;

  const RequestAppleCredentialRepository(this._reporter);

  @override
  ResultFuture<AppCredential?, AuthFailure> request() async {
    final rawNonce = generateNonce();
    final securityState = generateNonce();
    final nonce = sha256ofString(rawNonce);

    AuthorizationCredentialAppleID appleCredential;
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
          state: securityState,
        );
      } on SignInWithAppleAuthorizationException catch (e, st) {
        if (e.code == AuthorizationErrorCode.canceled) {
          return Result.ok(null);
        }
        _reporter.report(e, st, reason: "signing in with Apple on Apple devices");
        return Result.failed(AuthFailure(AuthFailureCode.unknown));
      }
    } else {
      try {
        appleCredential = await signInWithAppleWebBased(
            state: securityState, nonce: nonce);
      } catch (e, st) {
        if (e is PlatformException && e.code == "CANCELED") {
          return Result.ok(null);
        }
        _reporter.report(e, st, reason: "signing in with Apple on Android");
        return Result.failed(AuthFailure(AuthFailureCode.unknown));
      }
    }

    if (securityState != appleCredential.state) {
      return Result.failed(AuthFailure(AuthFailureCode.stateMismatch));
    }

    return Result.ok(AppleAppCredential(
      accessToken: appleCredential.authorizationCode,
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    ));
  }
}

@riverpod
RequestAppleCredentialRepository requestAppleCredentialRepository(Ref ref) {
  return RequestAppleCredentialRepository(
    ref.watch(errorReporterProvider),
  );
}
