import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/pages/settings/account_edit_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/sign_in_handler.dart';
import '../db/shared_prefs.dart';
import '../main.dart';
import '../utils/ui.dart';
import '../utils/utils.dart';

class AuthLinkHandler {
  AuthLinkHandler._();

  static void handle(Uri url) {
    switch (url.queryParameters["mode"]) {
      case "signIn":
        _handleSignIn(url);
        break;
      case "verifyAndChangeEmail":
        _handleVerifyAndChangeEmail(url);
        break;
      default:
        showSnackBar(globalContext!, "URLの形式が正しくありません");
    }
  }

  static Future<void> _handleSignIn(Uri url) async {
    if (FirebaseAuth.instance.isSignInWithEmailLink(url.toString())) {
      print("Handling sign-in with email link: ${url.toString()}");
      var c = url.queryParameters["continueUrl"];
      var continueUri = c != null ? Uri.parse(c) : url;

      var mode = continueUri.queryParameters["internalMode"];
      if (mode == SignInMode.normal.name
          && FirebaseAuth.instance.currentUser == null) {
        showSnackBar(globalContext!, "既にログインされています。ログアウトしてからお試しください。");
        return;
      }

      final pref = SharedPrefs(await SharedPreferences.getInstance());
      final email = pref.emailForUrlLogin;
      if (email != null) {
        final handler = SignInHandler(SignInMode.values.firstWhere((e) => e.name == mode));
        showLoadingModal(globalContext!);
        try {
          final result = await handler.signInWithLink(
              email: email, emailLink: url.toString());
          await handler.handleSignInResult(result);

          if (mode == SignInMode.reauthenticate.name) {
            Navigator.popAndPushNamed(globalContext!, continueUri.path,
                arguments: AccountEditPageArguments(
                    continueUri.queryParameters["new_email"]));
          }
        } on FirebaseAuthException catch (e, stack) {
          if (e.code == "invalid-action-code") {
            showSnackBar(globalContext!, "URLの有効期限が切れたか、コードが正しくありません。");
          } else {
            showSnackBar(globalContext!, "エラーが発生しました。(${e.code})");
            FirebaseCrashlytics.instance.recordError(e, stack);
          }
          Navigator.of(globalContext!, rootNavigator: true).pop();
        } catch (e, stack) {
          showSnackBar(globalContext!, "エラーが発生しました。");
          FirebaseCrashlytics.instance.recordError(e, stack);
          Navigator.of(globalContext!, rootNavigator: true).pop();
        }
      } else {
        showSnackBar(globalContext!, "ログインするデバイスと同じものでリンクを開いてください。");
      }
    }
  }

  static Future<void> _handleVerifyAndChangeEmail(Uri url) async {
    var codeInfo = await _checkAuthActionCode(url);

    if (codeInfo != null) {
      await FirebaseAuth.instance.signOut();
      backToWelcomePage(globalContext!);
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<ActionCodeInfo?> _checkAuthActionCode(Uri url) async {
    var oobCode = url.queryParameters["oobCode"];
    if (oobCode == null) {
      showSnackBar(globalContext!, "URLの形式が正しくありません");
      return null;
    }

    showLoadingModal(globalContext!);

    try {
      return await FirebaseAuth.instance.checkActionCode(oobCode);
    } on FirebaseAuthException catch (e, stack) {
      switch (e.code) {
        case "invalid-action-code":
        case "firebase_auth/invalid-action-code":
          showSnackBar(globalContext!, "URLの有効期限が切れたか、コードが正しくありません。");
          break;
        default:
          handleAuthError(e, stack, globalContext!);
          break;
      }
    } catch (e, stack) {
      showSnackBar(globalContext!, "エラーが発生しました。");
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      Navigator.of(globalContext!, rootNavigator: true).pop();
    }
    return null;
  }
}
