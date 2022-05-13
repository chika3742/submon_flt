import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/oauth2/v2.dart' as oauth;
import 'package:googleapis_auth/auth_io.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';

Future<dynamic> pushPage(BuildContext context, Widget page) async {
  PageRoute route;
  if (Platform.isIOS || Platform.isMacOS) {
    route = CupertinoPageRoute(builder: (settings) => page);
  } else {
    route = MaterialPageRoute(builder: (settings) => page);
  }
  return await Navigator.of(context, rootNavigator: true).push(route);
}

int getTimetableCellId(int period, int weekday) {
  return period * 6 + weekday;
}

ActionCodeSettings actionCodeSettings([String url = "https://chikach.net"]) {
  return ActionCodeSettings(
    url: url,
    androidPackageName: "net.chikach.submon",
    iOSBundleId: "net.chikach.submon",
    handleCodeInApp: true,
    dynamicLinkDomain: "submon.page.link",
  );
}

void handleAuthError(FirebaseAuthException e, BuildContext context) {
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
      break;
    default:
      showSnackBar(context, "エラーが発生しました。(${e.code})",
          duration: const Duration(minutes: 1));
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
        onOKPressed: () {
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
      .pushNamed("/submission/create", arguments: {
    "initialTitle": name,
    "initialDeadline": deadline,
  });
}

enum AdUnit {
  homeBottomBanner,
  submissionDetailBanner,
  focusTimerInterstitial,
}

String? getAdUnitId(AdUnit adUnit) {
  var adUnitIds = {
    AdUnit.homeBottomBanner: {
      "debug": {
        "iOS": dotenv.get("AD_UNIT_DEBUG_BANNER_IOS"),
        "Android": dotenv.get("AD_UNIT_DEBUG_BANNER_ANDROID"),
      },
      "release": {
        "iOS": dotenv.get("AD_UNIT_HOME_IOS"),
        "Android": dotenv.get("AD_UNIT_HOME_ANDROID"),
      }
    },
    AdUnit.submissionDetailBanner: {
      "debug": {
        "iOS": dotenv.get("AD_UNIT_DEBUG_BANNER_IOS"),
        "Android": dotenv.get("AD_UNIT_DEBUG_BANNER_ANDROID"),
      },
      "release": {
        "iOS": dotenv.get("AD_UNIT_SUBMISSION_DETAIL_IOS"),
        "Android": dotenv.get("AD_UNIT_SUBMISSION_DETAIL_ANDROID"),
      }
    },
    AdUnit.focusTimerInterstitial: {
      "debug": {
        "iOS": dotenv.get("AD_UNIT_DEBUG_INTERSTITIAL_IOS"),
        "Android": dotenv.get("AD_UNIT_DEBUG_INTERSTITIAL_ANDROID"),
      },
      "release": {
        "iOS": dotenv.get("AD_UNIT_FOCUS_TIMER_INTERSTITIAL_IOS"),
        "Android": dotenv.get("AD_UNIT_FOCUS_TIMER_INTERSTITIAL_ANDROID"),
      }
    },
  };
  String platform;
  if (Platform.isIOS) {
    platform = "iOS";
  } else if (Platform.isAndroid) {
    platform = "Android";
  } else {
    return null;
  }
  return adUnitIds[adUnit]?[kReleaseMode ? "release" : "debug"]?[platform];
}

extension TimeOfDayToMinutes on TimeOfDay {
  int toMinutes() {
    return hour * 60 + minute;
  }

  bool isInsideRange(TimeOfDay start, TimeOfDay end) {
    return start.toMinutes() <= toMinutes() && toMinutes() < end.toMinutes();
  }
}
