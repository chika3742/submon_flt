import "package:cloud_functions/cloud_functions.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";

ActionCodeSettings actionCodeSettings(String url) {
  String packageName;
  if (kReleaseMode) {
    packageName = "net.chikach.submon";
  } else {
    packageName = "net.chikach.submon.debug";
  }
  return ActionCodeSettings(
    url: url,
    androidPackageName: packageName,
    iOSBundleId: packageName,
    handleCodeInApp: true,
    linkDomain: appDomain,
  );
}

String get appDomain {
  return kReleaseMode ? "submon.app" : "dev.submon.app";
}

/// Firebase Auth のアクションURL (`/__/auth/action`) を解決する。
///
/// `/__/auth/links` ラッパーの場合は内部の `link` パラメータを展開する。
/// アプリドメイン外の URL や関係のないパスは `null` を返す。
Uri? resolveAuthActionUrl(Uri url) {
  if (url.host != appDomain && url.scheme != "submon") return null;

  if (url.path == "/__/auth/action") return url;

  if (url.path == "/__/auth/links") {
    final link = url.queryParameters["link"];
    return link != null ? Uri.parse(link) : null;
  }

  return null;
}

/// Creates a submission share link with the given data.
///
/// Returns the document ID of the created link.
Future<String> createSubmissionShareLink(Map<String, dynamic> data) async {
  final createShareLink = FirebaseFunctions.instanceFor(region: "asia-northeast1")
      .httpsCallable("createShareLink");
  final request = {
    ...data,
    "appChannel": kReleaseMode ? "prod" : "dev",
  };
  final result = await createShareLink(request);
  return result.data["url"];
}

/// Creates a submission share link with the given data.
///
/// Returns the document ID of the created link.
String createSubmissionLink(int submissionId) {
  final uri = Uri(
    scheme: "https",
    host: appDomain,
    path: "/submissions/$submissionId",
    queryParameters: {
      "uid": FirebaseAuth.instance.currentUser!.uid,
    },
  );
  return uri.toString();
}
