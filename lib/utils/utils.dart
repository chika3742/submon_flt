import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/oauth2/v2.dart' as oauth;
import 'package:googleapis_auth/auth_io.dart';
import 'package:submon/browser.dart';
import 'package:submon/main.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/utils/ui.dart';

bool get isAdEnabled {
  return FirebaseAuth.instance.currentUser?.email != dotenv.get("ADMIN_EMAIL");
}

int getTimetableCellId(int period, int weekday) {
  return period * 6 + weekday;
}

void handleAuthError(
    FirebaseAuthException e, StackTrace stack, BuildContext context) {
  switch (e.code) {
    case "user-not-found":
      showSnackBar(context, "ユーザーが見つかりません。既に削除された可能性があります。");
      break;
    case "user-disabled":
      showSnackBar(context, "このアカウントは凍結されています。");
      break;
    case "network-request-failed":
      showSnackBar(context, "通信に失敗しました。ネットワーク接続を確認してください。");
      break;
    case "user-token-expired":
      showSnackBar(context, "トークンの有効期限が切れました。再度ログインする必要があります。");
      FirebaseAuth.instance.signOut();
      backToWelcomePage(Application.globalKey.currentContext!);
      break;
    default:
      showSnackBar(context, "エラーが発生しました。(${e.code})",
          duration: const Duration(seconds: 30));
      recordErrorToCrashlytics(e, stack);
  }
  debugPrint(e.message);
}

void handleFirebaseError(FirebaseException e, StackTrace stackTrace,
    BuildContext context, String message) {
  switch (e.code) {
    case "permission-denied":
      showSimpleDialog(
        context,
        "エラー",
        "$message\n\nアカウントがすでに削除されたか、サーバーメンテナンス中である可能性があります。",
        allowCancel: false,
        showCancel: true,
        cancelText: "ログアウト",
        onCancelPressed: () {
          FirebaseAuth.instance.signOut();
          backToWelcomePage(context);
        },
        okText: "お知らせを開く",
        onOKPressed: () {
          Browser.openAnnouncements();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
      );
      break;

    default:
      showSnackBar(context, "$message(${e.code})",
          duration: const Duration(seconds: 20));
  }
  FirebaseCrashlytics.instance.recordError(e, stackTrace);
}

Future<bool> canAccessTasks() async {
  try {
    var client = await googleSignIn.authenticatedClient();
    if (client == null) return false;

    var tokenInfo = await oauth.Oauth2Api(client).tokeninfo();

    return tokenInfo.scope
            ?.split(" ")
            .contains("https://www.googleapis.com/auth/tasks") ==
        true;
  } on AccessDeniedException catch (e, stackTrace) {
    if (e.message.contains("invalid_token")) {
      await googleSignIn.disconnect();
      return await canAccessTasks();
    }

    debugPrint(e.toString());
    debugPrint(stackTrace.toString());
    return false;
  } catch (e, st) {
    await googleSignIn.disconnect();
    debugPrint(e.toString());
    debugPrint(st.toString());
    return false;
  }
}

void createNewSubmissionForTimetable(
    BuildContext context, int weekday, String name) {
  var now = DateTime.now();
  now = DateTime(now.year, now.month, now.day, 23, 59);
  DateTime deadline;
  if (now.weekday == weekday + 1) {
    deadline = now.add(const Duration(days: 7));
  } else {
    deadline = now;
    while (deadline.weekday != weekday + 1) {
      deadline = deadline.add(const Duration(days: 1));
    }
  }
  Navigator.of(context, rootNavigator: true)
      .pushNamed(CreateSubmissionPage.routeName, arguments: CreateSubmissionPageArguments(
    initialTitle: name,
    initialDeadline: deadline,
  ));
}

void recordErrorToCrashlytics(dynamic exception, StackTrace stackTrace) {
  FirebaseCrashlytics.instance.recordError(exception, stackTrace);
}

extension TimeOfDayToMinutes on TimeOfDay {
  int toMinutes() {
    return hour * 60 + minute;
  }

  bool isInsideRange(TimeOfDay start, TimeOfDay end) {
    return start.toMinutes() <= toMinutes() && toMinutes() < end.toMinutes();
  }
}

Iterable<int> range(int start, int end, [int step = 1]) sync* {
  if (step == 0) throw ArgumentError('step cannot be 0');
  if (step < 0) throw ArgumentError('step cannot be negative');

  for (int value = start; value <= end; value += step) {
    yield value;
  }
}
