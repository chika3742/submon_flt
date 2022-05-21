import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

ActionCodeSettings actionCodeSettings(String url) {
  return ActionCodeSettings(
    url: url,
    androidPackageName: "net.chikach.submon",
    iOSBundleId: "net.chikach.submon",
    handleCodeInApp: true,
    dynamicLinkDomain: getDynamicLinkDomain(),
  );
}

String getDynamicLinkDomain({bool withScheme = false}) {
  if (kReleaseMode) {
    return "${withScheme ? "https://" : ""}open.submon.app";
  } else {
    return "${withScheme ? "https://" : ""}dev.open.submon.app";
  }
}

String getAppDomain(String path, {bool withScheme = false}) {
  if (kReleaseMode) {
    return "${withScheme ? "https://" : ""}submon.app$path";
  } else {
    return "${withScheme ? "https://" : ""}dev.submon.app$path";
  }
}

String getAppleSignInRedirectorUrl() {
  if (kReleaseMode) {
    return "https://asia-northeast1-submon-prod.cloudfunctions.net/appleSignInRedirector";
  } else {
    return "https://asia-northeast1-submon-mgr.cloudfunctions.net/appleSignInRedirector";
  }
}

Future<ShortDynamicLink> buildShortDynamicLink(String path) {
  return FirebaseDynamicLinks.instance.buildShortLink(DynamicLinkParameters(
    link: Uri.parse(getAppDomain(path, withScheme: true)),
    uriPrefix: getDynamicLinkDomain(withScheme: true),
    iosParameters: const IOSParameters(
      appStoreId: "1625033197",
      bundleId: "net.chikach.submon",
    ),
    androidParameters: const AndroidParameters(
      packageName: "net.chikach.submon",
    ),
  ));
}
