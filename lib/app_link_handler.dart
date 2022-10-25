import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/sign_in_handler.dart';
import 'db/shared_prefs.dart';
import 'events.dart';
import 'isar_db/isar_digestive.dart';
import 'isar_db/isar_submission.dart';
import 'main.dart';
import 'pages/focus_timer_page.dart';
import 'pages/submission_create_page.dart';
import 'pages/submission_detail_page.dart';
import 'utils/dynamic_links.dart';
import 'utils/ui.dart';
import 'utils/utils.dart';

class AppLinkHandler {
  AppLinkHandler._();

  static initDynamicLinksListener() {
    FirebaseDynamicLinks.instance.getInitialLink().then((linkData) {
      if (linkData != null) {
        handleLink(linkData.link);
      }
    });
    FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
      handleLink(linkData.link);
    });
  }

  static void handleLink(Uri url) {
    try {
      if (url.host == getAppDomain("") || url.scheme == "submon") {
        if (url.path == "/__/auth/action") {
          AuthLinkHandler.handle(url);
        } else {
          InAppLinkHandler.handle(url);
        }
      }
    } on RangeError catch (e, stack) {
      debugPrint("Malformed URL or the URL should not be handled here");
      debugPrintStack(stackTrace: stack);
    }
  }
}

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
    var codeInfo = await _checkAuthActionCode(url);

    if (codeInfo != null &&
        codeInfo.operation == ActionCodeInfoOperation.emailSignIn) {
      if (FirebaseAuth.instance.currentUser == null) {
        final pref = SharedPrefs(await SharedPreferences.getInstance());
        final email = pref.emailForUrlLogin;
        if (email != null) {
          final handler = SignInHandler(SignInMode.normal);
          showLoadingModal(globalContext!);
          try {
            final result = await handler.signInWithLink(
                email: email, emailLink: url.toString());
            await handler.handleSignInResult(result);
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

class InAppLinkHandler {
  InAppLinkHandler._();

  static void handle(Uri url) {
    if (FirebaseAuth.instance.currentUser == null) {
      showSnackBar(globalContext!, "ログインする必要があります");
      return;
    }

    switch (url.path.split("/")[1]) {
      case "submission":
        _openSubmissionDetailPage(url);
        break;
      case "submission-sharing":
        _showSubmissionSharingDialog(url);
        break;
      case "create-submission":
        _openCreateSubmissionPage();
        break;
      case "focus-timer":
        _openFocusTimer(url);
        break;
      case "tab":
        _setDefaultTab(url);
        break;
    }
  }

  static void _openSubmissionDetailPage(Uri url) {
    var id = url.queryParameters["id"];
    var uid = url.queryParameters["uid"];

    // Insufficient parameter
    if (id == null) {
      showSnackBar(globalContext!, "パラメーターが不足しています。");
      return;
    }
    // UID provided and mismatch
    if (uid != null && uid != FirebaseAuth.instance.currentUser?.uid) {
      showSnackBar(globalContext!, "このアカウントで作成された提出物ではありません。");
      return;
    }
    // ID is not integer
    if (int.tryParse(id) == null) {
      showSnackBar(globalContext!, "idが整数ではありません");
      return;
    }

    Navigator.pushNamed(globalContext!, SubmissionDetailPage.routeName,
        arguments: SubmissionDetailPageArguments(int.parse(id)));
  }

  static void _showSubmissionSharingDialog(Uri url) {
    var title = url.queryParameters["title"];
    var date = url.queryParameters["date"];
    var detail = url.queryParameters["detail"] ?? "";
    var color = url.queryParameters["color"];

    if (title == null || date == null || color == null) {
      showSnackBar(globalContext!, "パラメーターが不足しています。");
      return;
    }

    showSimpleDialog(
      globalContext!,
      "提出物のシェア",
      "以下の内容で登録します。よろしいですか？\n\n"
          "タイトル: $title\n"
          "期限: ${DateTime.parse(date).toLocal().toString()}\n"
          "詳細: $detail",
      showCancel: true,
      onOKPressed: () async {
        await SubmissionProvider().use((provider) async {
          provider.writeTransaction(() async {
            var id = await provider.put(Submission.from(
              title: title,
              due: DateTime.parse(date).toLocal(),
              details: detail,
              color: SubmissionColor.of(int.parse(color)),
            ));
            eventBus.fire(SubmissionInserted(id));
          });
        });
        showSnackBar(globalContext!, "作成しました。");
      },
    );
  }

  static void _openCreateSubmissionPage() {
    Navigator.pushNamed(globalContext!, CreateSubmissionPage.routeName,
            arguments: CreateSubmissionPageArguments())
        .then((insertedId) {
      if (insertedId != null) {
        eventBus.fire(SubmissionInserted(insertedId as int));
      }
    });
  }

  static void _openFocusTimer(Uri url) {
    DigestiveProvider().use((provider) async {
      var digestive =
          await provider.get(int.parse(url.queryParameters["digestiveId"]!));
      if (digestive != null) {
        FocusTimerPage.openFocusTimer(globalContext!, digestive);
      } else {
        showSnackBar(globalContext!, "このDigestiveはすでに削除されています");
      }
    });
  }

  static var initialTabId = "home";

  static void _setDefaultTab(Uri url) {
    print("called");
    var tabId = url.path.split("/")[2];
    initialTabId = tabId;
    eventBus.fire(SwitchBottomNav(tabId));
  }
}
