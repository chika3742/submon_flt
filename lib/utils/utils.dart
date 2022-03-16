import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
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
      showSnackBar(context, "このアカウントは停止されています。");
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
      showSnackBar(context, "$message現在サーバーメンテナンス中です。");
      break;

    default:
      showSnackBar(context, "$message(${e.code})",
          duration: const Duration(seconds: 20));
  }
  FirebaseCrashlytics.instance.recordError(e, stackTrace);
}

Future<bool> canAccessCalendar() async {
  try {
    var client = await googleSignIn.authenticatedClient();
    if (client == null) return false;

    await calendar.CalendarApi(client).events.list("primary", maxResults: 1);
    return true;
  } on AccessDeniedException catch (e, stackTrace) {
    if (e.message.contains("invalid_token")) {
      await googleSignIn.disconnect();
      return await canAccessCalendar();
    }

    debugPrint(e.toString());
    debugPrint(stackTrace.toString());
    return false;
  }
}

extension SubmissionExtension on calendar.EventsResource {
  Future<calendar.Event?> getEventForSubmissionId(int submissionId) async {
    var events = await list("primary",
        maxResults: 1,
        privateExtendedProperty: ["submission_id=$submissionId"]);
    if (events.items == null || events.items!.isEmpty) return null;

    return events.items!.first;
  }
}

enum AdUnit {
  homeBottomBanner,
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
    }
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