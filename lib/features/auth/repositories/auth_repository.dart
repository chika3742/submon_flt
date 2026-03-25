import "dart:io";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";

import "../../../apple_web_auth_options.dart";
import "../../../auth/apple_sign_in.dart";
import "../../../providers/core_providers.dart";
import "../../../utils/app_links.dart";
import "../models/auth_exception.dart";

part "auth_repository.g.dart";
part "auth_repository.freezed.dart";

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(firebaseAuthProvider),
    ref.watch(crashlyticsProvider),
    ref.watch(googleSignInProvider),
    ref.watch(appleSignInAndroidProvider),
  );
}

@freezed
sealed class FetchCredentialResult with _$FetchCredentialResult {
  const factory FetchCredentialResult.success({
    required OAuthCredential credential,
    @Default(false) bool mayRequireConsent,
  }) = FetchCredentialResultSuccess;

  const factory FetchCredentialResult.canceled() =
      FetchCredentialResultCanceled;
}

abstract interface class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseCrashlytics _crashlytics;
  final AppleSignInAndroid _appleSignInAndroid;

  const AuthRepository(
    this._auth,
    this._crashlytics,
    this._googleSignIn,
    this._appleSignInAndroid,
  );

  Future<FetchCredentialResult> fetchGoogleCredential();

  Future<FetchCredentialResult> fetchAppleCredential();

  Future<void> signIn(AuthCredential credential);

  Future<void> reauthenticate(AuthCredential credential);

  Future<void> linkWithCredential(AuthCredential credential);

  Future<void> unlinkProvider(AuthProvider provider);

  Future<void> sendSignInLinkToEmail(String email, String continueUri);

  Future<void> sendPasswordResetLink(String email);

  Future<List<String>> fetchSignInMethodsForEmail(String email);

  Future<void> signOut();

  Future<ActionCodeInfo> checkActionCode(String oobCode);

  Future<void> createUserWithEmailAndPassword(String email, String password);

  Future<void> verifyBeforeUpdateEmail(String newEmail);

  Future<void> updateDisplayName(String displayName);

  Future<void> deleteUser();

  static AuthCredential createEmailLinkCredential(String email, String emailLink) {
    return EmailAuthProvider.credentialWithLink(
      email: email,
      emailLink: emailLink,
    );
  }
}

class AuthRepositoryImpl extends AuthRepository {
  const AuthRepositoryImpl(
    super._auth,
    super._crashlytics,
    super._googleSignIn,
    super._appleSignInAndroid,
  );

  User get requireUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw AuthException(AuthErrorCode.notSignedIn);
    }
    return user;
  }

  @override
  Future<FetchCredentialResult> fetchGoogleCredential() async {
    await _googleSignIn.signOut(); // sign out before signing in

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e, st) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          return FetchCredentialResult.canceled();
        default:
          await _crashlytics.recordError(e, st, reason: "Google sign-in failed");
          throw AuthException(AuthErrorCode.unknown);
      }
    }

    return FetchCredentialResult.success(
      credential: GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      ),
    );
  }

  @override
  Future<FetchCredentialResult> fetchAppleCredential() async {
    final rawNonce = generateNonce();
    final securityState = generateNonce();
    final nonce = AppleSignInAndroid.sha256ofString(rawNonce);

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
          webAuthenticationOptions: AppleWebAuthOptions.currentBuild,
        );
      } on SignInWithAppleAuthorizationException catch (e, st) {
        if (e.code == AuthorizationErrorCode.canceled) {
          return FetchCredentialResult.canceled();
        }
        await _crashlytics.recordError(e, st);
        rethrow;
      }
    } else {
      final cred = await _appleSignInAndroid.signIn(state: securityState, nonce: nonce);
      if (cred == null) {
        return FetchCredentialResult.canceled(); // user canceled
      }
      appleCredential = cred;
    }

    if (securityState != appleCredential.state) {
      throw AuthException(AuthErrorCode.stateMismatch);
    }

    final credential = OAuthProvider("apple.com").credential(
      accessToken: appleCredential.authorizationCode,
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    final usesPrivateRelayEmail = () {
      if (appleCredential.email case final email?) {
        return email.endsWith("@privaterelay.appleid.com");
      }
      return false;
    }();

    return FetchCredentialResult.success(
      credential: credential,
      mayRequireConsent: usesPrivateRelayEmail,
    );
  }

  @override
  Future<void> signIn(AuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e, st) {
      _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> reauthenticate(AuthCredential credential) async {
    final user = requireUser;
    try {
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> linkWithCredential(AuthCredential credential) async {
    final user = requireUser;
    try {
      await user.linkWithCredential(credential);
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> unlinkProvider(AuthProvider provider) {
    final user = requireUser;
    return user.unlink(provider.providerId);
  }

  @override
  Future<void> sendSignInLinkToEmail(String email, String continueUri) {
    return _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings(
        continueUri,
      ),
    );
  }

  @override
  Future<void> sendPasswordResetLink(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    try {
      return await _auth.fetchSignInMethodsForEmail(email);
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> signOut() {
    return Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<ActionCodeInfo> checkActionCode(String oobCode) async {
    try {
      return await _auth.checkActionCode(oobCode);
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail) async {
    final user = requireUser;
    try {
      await user.verifyBeforeUpdateEmail(
        newEmail,
        actionCodeSettings(
          Uri(scheme: "https", host: appDomain).toString(),
        ),
      );
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = requireUser;
    try {
      await user.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  @override
  Future<void> deleteUser() async {
    final user = requireUser;
    try {
      await user.delete();
    } on FirebaseAuthException catch (e, st) {
      await _recordErrorIfUnexpected(e, st);
      throw AuthException(AuthErrorCode.fromFirebaseAuthErrorCode(e.code));
    }
  }

  Future<void> _recordErrorIfUnexpected(FirebaseAuthException e, StackTrace st) async {
    if (!AuthErrorCode.fromFirebaseAuthErrorCode(e.code).isCommonError) {
      await _crashlytics.recordError(e, st);
    }
  }
}

enum AuthProvider {
  apple("apple.com"),
  google("google.com"),
  ;

  final String providerId;

  const AuthProvider(this.providerId);
}
