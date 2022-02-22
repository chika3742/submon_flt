import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/events.dart';
import 'package:submon/main.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import 'db/shared_prefs.dart';

StreamSubscription initDynamicLinks() {
  FirebaseDynamicLinks.instance.getInitialLink().then((linkData) {
    if (linkData != null) handleDynamicLink(linkData.link);
  });
  return FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
    handleDynamicLink(linkData.link);
  });
}

void handleDynamicLink(Uri url) async {
  var context = MyApp.globalKey.currentContext!;

  var auth = FirebaseAuth.instance;
  var code = url.queryParameters["oobCode"];
  if (code == null) return;

  showLoadingModal(context);

  ActionCodeInfo codeInfo;
  try {
    codeInfo = await auth.checkActionCode(code);
  } on FirebaseAuthException catch (e) {
    Navigator.of(context).pop();
    switch (e.code) {
      case "invalid-action-code":
      case "firebase_auth/invalid-action-code":
        showSnackBar(context, "このリンクは無効です。期限が切れたか、形式が正しくありません。");
        break;
      default:
        handleAuthError(e, context);
        break;
    }
    return;
  }

  try {
    if (auth.isSignInWithEmailLink(url.toString())) {
      final pref = SharedPrefs(await SharedPreferences.getInstance());
      final email = pref.emailForUrlLogin;
      if (email != null) {
        var result = await auth.signInWithEmailLink(
            email: email, emailLink: url.toString());

        await completeLogin(result, context);
        Navigator.of(context, rootNavigator: true)
            .pop(); // dismiss loading modal

        eventBus.fire(SignedInWithLink());

        return;
      } else {
        showSimpleDialog(
            context, "エラー", "メールアドレスが保存されていません。再度この端末でメールを送信してください。");
      }
    } else if (codeInfo.operation ==
        ActionCodeInfoOperation.verifyAndChangeEmail) {
      await auth.applyActionCode(code);
      await auth.signOut();
      Navigator.of(context, rootNavigator: true).pop(); // dismiss loading modal
      showSnackBar(context, "メールアドレスの変更が完了しました。再度ログインが必要となります。");
      Navigator.pushNamed(context, "/signIn");
    }
  } on FirebaseAuthException catch (e) {
    Navigator.of(context, rootNavigator: true).pop(); // dismiss loading modal
    handleAuthError(e, context);
  }
}
