import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/events.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/main.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import 'db/digestive.dart';
import 'db/shared_prefs.dart';
import 'method_channel/channels.dart';

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
  getPendingUri().then((uriString) {
    if (uriString != null) {
      handleOpenDynamicLink(Uri.parse(uriString));
    }
  });
  return const EventChannel(EventChannels.uri)
      .receiveBroadcastStream()
      .listen((uriString) {
    handleOpenDynamicLink(Uri.parse(uriString));
  });
}

void handleDynamicLink(Uri url) {
  if (url.toString().startsWith("https://submon.chikach.net/__/auth")) {
    handleAuthDynamicLink(url);
  } else if (url.toString().startsWith("https://app.submon.chikach.net")) {
    handleOpenDynamicLink(url);
  }
}

void handleAuthDynamicLink(Uri url) async {
  var context = Application.globalKey.currentContext!;

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
      if (auth.currentUser == null) {
        final pref = SharedPrefs(await SharedPreferences.getInstance());
        final email = pref.emailForUrlLogin;
        if (email != null) {
          var result = await auth.signInWithEmailLink(
              email: email, emailLink: url.toString());

          await completeLogin(result, context);
          Navigator.of(context, rootNavigator: true)
              .pop(); // dismiss loading modal

          Navigator.of(context).popUntil(ModalRoute.withName("welcome"));
          Navigator.of(context).pushReplacementNamed("/");

          return;
        } else {
          showSimpleDialog(
              context, "エラー", "メールアドレスが保存されていません。再度この端末でメールを送信してください。");
        }
      } else {
        showSnackBar(context, "既にログインされています。ログアウトしてからお試しください。");
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

void handleOpenDynamicLink(Uri url) {
  var context = Application.globalKey.currentContext!;
  var paths = url.path.split("/");

  switch (paths[1]) {
    case "submission":
      var id = url.queryParameters["id"];
      if (id == null) {
        showSnackBar(context, "パラメーターが不足しています。");
        return;
      }
      if (int.tryParse(id) == null) {
        showSnackBar(context, "idが整数ではありません");
      }

      Navigator.pushNamed(context, "/submission/detail", arguments: {
        "id": int.parse(id),
      });
      break;

    case "submission-share":
      var title = url.queryParameters["title"];
      var date = url.queryParameters["date"];
      var detail = url.queryParameters["detail"] ?? "";
      var color = url.queryParameters["color"];

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
            var data = await provider.insert(Submission(
              title: title,
              date: DateTime.parse(date).toLocal(),
              detail: detail,
              color: Color(int.parse(color)),
            ));
            eventBus.fire(SubmissionInserted(data.id!));
          });
          showSnackBar(context, "作成しました。");
        },
      );
      break;

    case "create-submission":
      Navigator.pushNamed(context, "/submission/create", arguments: {})
          .then((insertedId) {
        if (insertedId != null) {
          eventBus.fire(SubmissionInserted(insertedId as int));
        }
      });
      break;

    case "focus-timer":
      DigestiveProvider().use((provider) async {
        var digestive =
            await provider.get(int.parse(url.queryParameters["digestiveId"]!));
        if (digestive != null) {
          Navigator.of(context, rootNavigator: true)
              .pushNamed("/focus-timer", arguments: {"digestive": digestive});
        } else {
          showSnackBar(context, "このDigestiveはすでに削除されています");
        }
      });
      break;
  }
}
