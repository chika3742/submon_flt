import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:submon/apple_web_auth_options.dart';
import 'package:submon/main.dart';
import 'package:submon/models/sign_in_result.dart';
import 'package:submon/pages/email_sign_in_page.dart';
import 'package:submon/src/pigeons.g.dart';

import '../db/firestore_provider.dart';
import '../db/shared_prefs.dart';
import '../isar_db/isar_provider.dart';
import '../pages/home_page.dart';
import '../pages/welcome_page.dart';
import '../user_config.dart';
import '../utils/firestore.dart';
import '../utils/ui.dart';
import 'apple_sign_in.dart';

class SignInHandler {
  final _auth = FirebaseAuth.instance;
  final SignInMode mode;

  SignInHandler(this.mode);

  static Future<void> signOut() async {
    showLoadingModal(globalContext!);
    await FirestoreProvider.removeNotificationToken();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    GeneralApi().updateWidgets();
    backToWelcomePage(globalContext!);
  }

  Future<void> handleSignInResult(SignInResult result) async {
    if (result.errorCode != null) {
      switch (result.errorCode) {
        case SignInError.cancelled:
          // do nothing
          return;

        case SignInError.notificationPermissionDenied:
          showSnackBar(globalContext!, "通知が許可されなかったため、通知が受信できません。");
          // enter to home screen
          break;

        case SignInError.userNotFound:
          await signupUser(result.credential!);
          showSnackBar(globalContext!, "アカウントを作成しました！");
          // enter to home screen
          break;

        default:
          showSnackBar(globalContext!, result.toErrorMessageString());
          // cancel
          return;
      }
    } else {
      showSnackBar(globalContext!, mode != SignInMode.upgrade ? "ログインしました。" : "アカウントをアップグレードしました。");
      Navigator.pop(globalContext!);
    }

    if (mode == SignInMode.normal) {
      if (Navigator.canPop(globalContext!)) {
        Navigator.popUntil(
            globalContext!, ModalRoute.withName(WelcomePage.routeName));
      }
      Navigator.pushReplacementNamed(globalContext!, HomePage.routeName);
    }
  }

  Future<SignInResult> signIn(AuthProvider provider,
      {BuildContext? context}) async {
    var result = await _signInByProvider(provider, context: context);

    if (result.errorCode != null) {
      return result;
    }

    var completionResult = await completeSignIn(result.credential!);

    return SignInResult(
        credential: result.credential, errorCode: completionResult);
  }

  Future<SignInResult> signInWithLink(
      {required String email, required String emailLink}) async {

    final credential = EmailAuthProvider.credentialWithLink(email: email, emailLink: emailLink);
    final result = await _signInByMode(credential);
    if (result == null) {
      return SignInResult(errorCode: SignInError.cancelled);
    }

    var completionResult = await completeSignIn(result);

    return SignInResult(credential: result, errorCode: completionResult);
  }

  Future<SignInResult> _signInByProvider(AuthProvider provider,
      {BuildContext? context}) async {
    switch (provider) {
      case AuthProvider.google:
        return await _signInWithGoogle();

      case AuthProvider.apple:
        return await _signInWithApple();

      case AuthProvider.email:
        assert(context != null);
        var result = await Navigator.pushNamed<SignInResult>(
            context!, EmailSignInPage.routeName,
            arguments: EmailSignInPageArguments(mode));
        if (result == null) {
          return SignInResult(errorCode: SignInError.cancelled);
        }
        return result;

      default:
        throw "not implemented";
    }
  }

  Future<UserCredential?> _signInByMode(AuthCredential credential) async {
    switch (mode) {
      case SignInMode.normal:
        return await _auth.signInWithCredential(credential);

      case SignInMode.reauthenticate:
        assert(_auth.currentUser != null);
        return await _auth.currentUser
            ?.reauthenticateWithCredential(credential);

      case SignInMode.upgrade:
        assert(_auth.currentUser != null);
        return await _auth.currentUser?.linkWithCredential(credential);
    }
  }

  Future<SignInResult> _signInWithGoogle() async {
    var googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); // sign out before signing in

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return SignInResult(
          errorCode: SignInError.cancelled); // if canceled (aborted)
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    return SignInResult(credential: await _signInByMode(credential));
  }

  Future<SignInResult> _signInWithApple() async {
    final rawNonce = generateNonce();
    final state = generateNonce();
    final nonce = AppleSignIn.sha256ofString(rawNonce);

    AuthorizationCredentialAppleID? appleCredential;
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
          state: state,
          webAuthenticationOptions: AppleWebAuthOptions.currentBuild,
        );
      } on SignInWithAppleAuthorizationException catch (e) {
        if (e.code == AuthorizationErrorCode.canceled) {
          return SignInResult(errorCode: SignInError.cancelled);
        } else {
          return SignInResult(
              errorCode: SignInError.appleSignInFailed,
              errorMessage: "サインインに失敗しました");
        }
      }
    } else {
      appleCredential = await AppleSignIn().signIn(state: state, nonce: nonce);
    }

    if (appleCredential == null) {
      return SignInResult(errorCode: SignInError.cancelled);
    }

    if (state != appleCredential.state) {
      FirebaseCrashlytics.instance
          .recordError(Exception("Apple sign in state mismatch."), null);
      return SignInResult(errorMessage: "セキュリティ情報が一致しません (state mismatch)");
    }

    if (mode == SignInMode.upgrade
        && (appleCredential.email?.endsWith("@privaterelay.appleid.com") ?? false)) {
      final result = await showSimpleDialog(
        globalContext!,
        "この匿名化アドレスをメールアドレスと紐づけることに同意しますか？",
        "このプライベートリレー（非公開）アドレスは、すでに登録されているメールアドレスと紐づけられます。",
        okText: "同意する",
        cancelText: "同意しない",
        showCancel: true,
      );
      if (result != true) {
        return SignInResult(errorCode: SignInError.cancelled);
      }
    }

    final credential = OAuthProvider("apple.com").credential(
        accessToken: appleCredential.authorizationCode,
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce);
    final userCredential = await _signInByMode(credential);

    return SignInResult(credential: userCredential);
  }

  Future<SignInError?> completeSignIn(UserCredential userCred) async {
    if (mode == SignInMode.reauthenticate) {
      return null;
    }

    try {
      SharedPrefs.use((prefs) {
        prefs.firestoreLastChanged = null;
      });
      await IsarProvider.clear();

      try {
        // check account exists
        var doc = await userDoc!
            .withConverter(
                fromFirestore: UserConfig.fromFirestore,
                toFirestore: (_, __) {
                  return {};
                })
            .get();

        var data = doc.data()!;

        FirebaseAnalytics.instance.logLogin(
            loginMethod: userCred.additionalUserInfo?.providerId ?? "unknown");

        // save messaging token
        var notificationToken = await MessagingApi().getToken();
        await FirestoreProvider.saveNotificationToken(notificationToken);
        GeneralApi().updateWidgets();

        var requestPermResult =
            await requestNotificationPermissionIfEnabled(data);
        if (requestPermResult == NotificationPermissionState.denied) {
          return SignInError.notificationPermissionDenied;
        }

        return null;
      } on FirebaseException catch (e) {
        if (e.code == "permission-denied") {
          return SignInError.userNotFound;
        } else {
          rethrow;
        }
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return SignInError.unknown;
    }
  }

  Future<NotificationPermissionState?> requestNotificationPermissionIfEnabled(
      UserConfig data) async {
    if (data.reminderNotificationTime != null ||
        data.timetableNotificationTime != null ||
        data.digestiveNotifications.isNotEmpty) {
      return (await MessagingApi().requestNotificationPermission())?.value;
    }
    return null;
  }

  Future<void> signupUser(UserCredential userCred) async {
    await FirestoreProvider.initializeUser();
    await FirebaseAnalytics.instance.logSignUp(
        signUpMethod: userCred.additionalUserInfo?.providerId ?? "unknown");
  }
}

enum AuthProvider {
  google,
  email,
  anonymous,
  apple,
}

enum SignInMode {
  normal,
  reauthenticate,
  upgrade,
}
