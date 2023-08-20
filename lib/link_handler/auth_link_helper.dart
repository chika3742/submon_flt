import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/pages/settings/account_edit_page.dart';

import '../auth/sign_in_handler.dart';
import '../db/shared_prefs.dart';
import '../main.dart';
import '../utils/ui.dart';
import '../utils/utils.dart';

class AuthLinkHelper {
  AuthLinkHelper._();

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
    var codeInfo = await _checkAuthActionCode(url);

    if (codeInfo != null &&
        codeInfo.operation == ActionCodeInfoOperation.emailSignIn) {
      var continueUri = Uri.parse(url.queryParameters["continueUrl"]!);

      var isReauth = continueUri.path != "/sign-in-from-email";
      if (FirebaseAuth.instance.currentUser == null || isReauth) {
        final pref = SharedPrefs(await SharedPreferences.getInstance());
        final email = pref.emailForUrlLogin;
        if (email != null) {
          final handler = SignInHandler(
              isReauth ? SignInMode.reauthenticate : SignInMode.normal);
          showLoadingModal(globalContext!);
          try {
            final result = await handler.signInWithLink(
                email: email, emailLink: url.toString());
            await handler.handleSignInResult(result);

            if (isReauth) {
              Navigator.popAndPushNamed(globalContext!, continueUri.path,
                  arguments: AccountEditPageArguments(
                      continueUri.queryParameters["new_email"]));
            }
          } catch (e, stack) {
            showSnackBar(globalContext!, "エラーが発生しました。");
            FirebaseCrashlytics.instance.recordError(e, stack);
            Navigator.of(globalContext!, rootNavigator: true).pop();
          }
        } else {
          showSnackBar(globalContext!, "エラーが発生しました。");
        }
      } else {
        showSnackBar(globalContext!, "既にログインされています。ログアウトしてからお試しください。");
      }
    }
  }

  static Future<void> _handleVerifyAndChangeEmail(Uri url) async {
    var codeInfo = await _checkAuthActionCode(url);

    if (codeInfo != null &&
        codeInfo.operation == ActionCodeInfoOperation.verifyAndChangeEmail) {
      var auth = FirebaseAuth.instance;
      await auth.applyActionCode(url.queryParameters["oobCode"]!);
      await auth.signOut();
      showSnackBar(globalContext!, "メールアドレスの変更が完了しました。再度ログインが必要となります。");
      backToWelcomePage(globalContext!);
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
