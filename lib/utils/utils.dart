import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      showSnackBar(context, "エラーが発生しました (Code: ${e.code})",
          duration: const Duration(minutes: 1));
  }
  debugPrint(e.message);
}
