import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/result/result.dart";
import "../../../logging/domain/error_reporter.dart";
import "../../../logging/infrastructure/crashlytics.dart";
import "../../../shared/domain/app_host.dart";
import "../../domain/models/app_credential.dart";
import "../../domain/models/auth_failure.dart";
import "../../domain/models/auth_mode.dart";
import "../../domain/models/auth_user.dart";
import "../../domain/models/social_provider.dart";
import "../../domain/repositories/auth_repository.dart";
import "../services/email_link_auth_continue_uri_converter.dart";

part "firebase_auth_repository.g.dart";

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final ErrorReporter _reporter;

  const FirebaseAuthRepository(this._auth, this._reporter);

  ResultFuture<T, AuthFailure> guard<T>(Future<T> Function() action) async {
    try {
      return Result.ok(await action());
    } on FirebaseException catch (e, st) {
      final failure = e._toAuthFailure();
      if (!failure.code.isCommonError) {
        _reporter.report(e, st);
      }
      return Result.failed(failure, st);
    } catch (e, st) {
      _reporter.report(e, st);
      return Result.failed(AuthFailure(AuthFailureCode.unknown, e), st);
    }
  }

  @override
  ResultFuture<void, AuthFailure> signIn(AppCredential credential) {
    return guard(() => _auth.signInWithCredential(credential._toFirebase()));
  }

  @override
  ResultFuture<void, AuthFailure> createTrialUser() {
    return guard(() => _auth.signInAnonymously());
  }

  @override
  ResultFuture<void, AuthFailure> reauthenticate(AppCredential credential) async {
    final user = _auth.currentUser;
    if (user == null) {
      return Result.failed(AuthFailure(AuthFailureCode.notSignedIn));
    }
    return await guard(() => user.reauthenticateWithCredential(credential._toFirebase()));
  }

  @override
  ResultFuture<void, AuthFailure> linkWithCredential(AppCredential credential) async {
    final user = _auth.currentUser;
    if (user == null) {
      return Result.failed(AuthFailure(AuthFailureCode.notSignedIn));
    }
    return await guard(() => user.reauthenticateWithCredential(credential._toFirebase()));
  }

  @override
  ResultFuture<void, AuthFailure> unlinkProvider(SocialProvider provider) async {
    final user = _auth.currentUser;
    if (user == null) {
      return Result.failed(AuthFailure(AuthFailureCode.notSignedIn));
    }
    return await guard(() => user.unlink(provider._toProviderId()));
  }

  Future<ActionCodeSettings> _createActionCodeSettings(Uri url) async {
    final packageName = (await PackageInfo.fromPlatform()).packageName;
    return ActionCodeSettings(
      url: url.toString(),
      androidPackageName: packageName,
      iOSBundleId: packageName,
      handleCodeInApp: true,
      linkDomain: appHost,
    );
  }

  @override
  ResultFuture<void, AuthFailure> sendSignInLinkToEmail(String email, AuthMode mode, [String? destinationAfterReAuth]) {
    return guard(() async {
      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: await _createActionCodeSettings(
          EmailLinkAuthContinueUriConverter().toUri(mode, destinationAfterReAuth),
        ),
      );
    });
  }

  @override
  ResultFuture<void, AuthFailure> sendPasswordResetLink(String email) {
    return guard(() => _auth.sendPasswordResetEmail(email: email));
  }

  @override
  ResultFuture<void, AuthFailure> signOut() {
    return guard(() => _auth.signOut());
  }

  @override
  ResultFuture<void, AuthFailure> verifyBeforeUpdateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) {
      return Result.failed(AuthFailure(AuthFailureCode.notSignedIn));
    }
    return await guard(() => user.verifyBeforeUpdateEmail(newEmail));
  }

  @override
  ResultFuture<void, AuthFailure> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      return Result.failed(AuthFailure(AuthFailureCode.notSignedIn));
    }
    return await guard(() => user.updateDisplayName(displayName));
  }

  @override
  ResultFuture<void, AuthFailure> deleteCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      return Result.failed(AuthFailure(AuthFailureCode.notSignedIn));
    }
    return await guard(() => user.delete());
  }

  @override
  Stream<AuthUser?> currentUser() {
    return _auth.authStateChanges().map((user) => user != null ? AuthUser(
      email: user.email,
      hasEmailProvider: user.providerData
          .any((p) => p.providerId == EmailAuthProvider.PROVIDER_ID),
      linkedProviders: user.providerData
          .where((p) => p.providerId != EmailAuthProvider.PROVIDER_ID)
          .map((p) => switch (p.providerId) {
            "google.com" => SocialProvider.google,
            "apple.com" => SocialProvider.apple,
              _ => throw StateError("Unrecognized provider ID"),
          }).toList(),
    ) : null);
  }

  @override
  ResultFuture<void, AuthFailure> checkActionCode(String oobCode) {
    return guard(() async {
      await _auth.checkActionCode(oobCode);
    });
  }
}

extension on SocialProvider {
  String _toProviderId() => switch (this) {
    SocialProvider.apple => "apple.com",
    SocialProvider.google => GoogleAuthProvider.PROVIDER_ID,
  };
}

extension on AppCredential {
  AuthCredential _toFirebase() => switch (this) {
    GoogleAppCredential(:final idToken) => GoogleAuthProvider.credential(
      idToken: idToken,
    ),
    AppleAppCredential(:final idToken, :final accessToken, :final rawNonce) =>
        OAuthProvider("apple.com").credential(
          idToken: idToken,
          accessToken: accessToken,
          rawNonce: rawNonce,
        ),
    EmailLinkAppCredential(:final email, :final emailLink) =>
        EmailAuthProvider.credentialWithLink(email: email, emailLink: emailLink),
    EmailPasswordAppCredential(:final email, :final password) =>
        EmailAuthProvider.credential(email: email, password: password),
  };
}

extension on FirebaseException {
  AuthFailure _toAuthFailure() {
    final AuthFailureCode failureCode = switch (code.replaceFirst(RegExp("^(firebase_)?auth/"), "")) {
      "account-exists-with-different-credential" => .userAlreadyExists,
      "invalid-credential" => .invalidCredential,
      "user-disabled" => .userDisabled,
      "user-not-found" => .userNotFound,
      "wrong-password" => .wrongPassword,
      "network-request-failed" => .networkRequestFailed,
      "user-token-expired" => .userTokenExpired,
      "email-already-in-use" => .emailAlreadyInUse,
      "credential-already-in-use" => .credentialAlreadyInUse,
      "user-mismatch" => .userMismatch,
      "expired-action-code" => .expiredActionCode,
      "weak-password" => .weakPassword,
      "invalid-email" => .invalidEmail,
      "missing-email" => .missingEmail,
      "requires-recent-login" => .requiresRecentLogin,
      _ => .unknown,
    };

    return AuthFailure(failureCode, this);
  }
}

@Riverpod(name: "authRepositoryProvider", keepAlive: true)
AuthRepository firebaseAuthRepository(Ref ref) {
  return FirebaseAuthRepository(
    FirebaseAuth.instance,
    ref.watch(errorReporterProvider),
  );
}

@Riverpod(keepAlive: true)
Stream<AuthUser?> currentUser(Ref ref) {
  return ref.watch(authRepositoryProvider).currentUser();
}
