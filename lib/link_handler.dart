import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/auth/sign_in_handler.dart';
import 'package:submon/events.dart';
import 'package:submon/isar_db/isar_digestive.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/main.dart';
import 'package:submon/pages/focus_timer_page.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/pages/submission_detail_page.dart';
import 'package:submon/utils/dynamic_links.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import 'db/shared_prefs.dart';
import 'method_channel/channels.dart';

StreamSubscription initSignInDynamicLinks() {
  FirebaseDynamicLinks.instance.getInitialLink().then((linkData) {
    if (linkData != null) {
      handleSignInDynamicLink(linkData.link);
    }
  });
  return FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
    handleSignInDynamicLink(linkData.link);
  });
}

StreamSubscription initDynamicLinks() {
  FirebaseDynamicLinks.instance.getInitialLink().then((linkData) {
    if (linkData != null) {
      handleDynamicLink(linkData.link);
    }
  });
  return FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
    handleDynamicLink(linkData.link);
  });
}

StreamSubscription initUriHandler() {
  MainMethodPlugin.getPendingUri().then((uriString) {
    if (uriString != null) {
      handleDynamicLink(Uri.parse(uriString));
    }
  });
  return const EventChannel(EventChannels.uri)
      .receiveBroadcastStream()
      .listen((uriString) {
    handleDynamicLink(Uri.parse(uriString));
  });
}

void handleDynamicLink(Uri url) {
  try {
    if (url.host == getAppDomain("") || url.scheme == "submon") {
        switch (url.path.split("/")[1]) {
          case "__":
            if (url.path == "/__/auth/action") {
              handleAuthUri(url, [AuthUriMode.verifyAndChangeEmail]);
            }
            break;

          case "submission":
            openSubmission(url);
            break;
          case "submission-sharing":
            showSubmissionSharingDialog(url);
            break;
          case "create-submission":
            openCreateSubmissionPage();
            break;
          case "focus-timer":
            openFocusTimer(url);
            break;
          case "tab":
            setDefaultTab(url);
            break;
        }
      }
  } on RangeError catch (e, stack) {
    debugPrint("Malformed URL or the URL should not be handled here");
    debugPrintStack(stackTrace: stack);
  }
}

void handleSignInDynamicLink(Uri url) {
  if (url.host == getAppDomain("") || url.scheme == "submon") {
    switch (url.path) {
      case "/__/auth/action":
      case "/__/auth/handler":
        handleAuthUri(url, [
          AuthUriMode.verifyAndChangeEmail,
          AuthUriMode.signInWithEmailLink
        ]);
        break;
    }
  }
}

void handleAuthUri(Uri url, List<AuthUriMode> acceptableMode) async {
  var navigator = Navigator.of(globalContext!, rootNavigator: true);
  var auth = FirebaseAuth.instance;
  var code = url.queryParameters["oobCode"];
  if (code == null) return;

  showLoadingModal(globalContext!);

  ActionCodeInfo codeInfo;
  try {
    codeInfo = await auth.checkActionCode(code);
  } on FirebaseAuthException catch (e, stack) {
    navigator.pop();
    switch (e.code) {
      case "invalid-action-code":
      case "firebase_auth/invalid-action-code":
        showSnackBar(globalContext!, "このリンクは無効です。期限が切れたか、形式が正しくありません。");
        break;
      default:
        handleAuthError(e, stack, globalContext!);
        break;
    }
    return;
  }

  try {
    if (acceptableMode.contains(AuthUriMode.signInWithEmailLink) &&
        auth.isSignInWithEmailLink(url.toString())) {
      if (auth.currentUser == null) {
        final pref = SharedPrefs(await SharedPreferences.getInstance());
        final email = pref.emailForUrlLogin;
        if (email != null) {
          var handler = SignInHandler(SignInMode.normal);
          var result = await handler.signInWithLink(
              email: email, emailLink: url.toString());
          await handler.handleSignInResult(result);
        } else {
          showSnackBar(globalContext!, "エラーが発生しました。(emailNotFound)");
        }
      } else {
        showSnackBar(globalContext!, "既にログインされています。ログアウトしてからお試しください。");
      }
    } else if (acceptableMode.contains(AuthUriMode.verifyAndChangeEmail) &&
        codeInfo.operation == ActionCodeInfoOperation.verifyAndChangeEmail) {
      await auth.applyActionCode(code);
      await auth.signOut();
      navigator.pop(); // dismiss loading modal
      showSnackBar(globalContext!, "メールアドレスの変更が完了しました。再度ログインが必要となります。");
      backToWelcomePage(globalContext!);
    } else {
      navigator.pop();
    }
  } on FirebaseAuthException catch (e, stack) {
    navigator.pop(); // dismiss loading modal
    handleAuthError(e, stack, globalContext!);
  }
}

void openSubmission(Uri url) {
  var id = url.queryParameters["id"];
  var uid = url.queryParameters["uid"];
  print(url.toString());
  var context = globalContext!;
  if (id == null) {
    showSnackBar(context, "パラメーターが不足しています。");
    return;
  }
  if (uid != null && uid != FirebaseAuth.instance.currentUser?.uid) {
    showSnackBar(context, "このアカウントで作成された提出物ではありません。");
    return;
  }
  if (int.tryParse(id) == null) {
    showSnackBar(context, "idが整数ではありません");
    return;
  }

  Navigator.pushNamed(context, SubmissionDetailPage.routeName, arguments: SubmissionDetailPageArguments(int.parse(id)));
}

void showSubmissionSharingDialog(Uri url) {
  var title = url.queryParameters["title"];
  var date = url.queryParameters["date"];
  var detail = url.queryParameters["detail"] ?? "";
  var color = url.queryParameters["color"];

  var context = globalContext!;

  if (title == null || date == null || color == null) {
    showSnackBar(context, "パラメーターが不足しています。");
    return;
  }

  showSimpleDialog(
    context,
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
            color: Color(int.parse(color)),
          ));
          eventBus.fire(SubmissionInserted(id));
        });
      });
      showSnackBar(globalContext!, "作成しました。");
    },
  );
}

void openCreateSubmissionPage() {
  Navigator.pushNamed(globalContext!, CreateSubmissionPage.routeName, arguments: CreateSubmissionPageArguments())
      .then((insertedId) {
    if (insertedId != null) {
      eventBus.fire(SubmissionInserted(insertedId as int));
    }
  });
}

void openFocusTimer(Uri url) {
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

void setDefaultTab(Uri url) {
  switch (url.path.split("/")[2]) {
    case "digestive":
      eventBus.fire(SwitchBottomNav("digestive"));
      break;
    case "timetable":
      eventBus.fire(SwitchBottomNav("timetable"));
      break;
  }
}

enum AuthUriMode {
  signInWithEmailLink,
  verifyAndChangeEmail,
}
