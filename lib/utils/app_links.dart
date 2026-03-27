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

Uri? resolveAppLink(Uri url) {
  if (url.host != appDomain && url.scheme != "submon") return null;

  if (url.path == "/__/auth/links") {
    final link = Uri.tryParse(url.queryParameters["link"] ?? "");
    return link != null && link.host == appDomain ? link : null;
  }

  return url;
}

Uri? resolveAuthActionUrl(Uri url) {
  final resolved = resolveAppLink(url);
  if (resolved == null || resolved.path != "/__/auth/action") return null;

  return resolved;
}

/// Creates a submission share link with the given data.
///
/// Returns the URL of the created link.
Future<String> createSubmissionShareLink(
  Map<String, dynamic> data, {
  required FirebaseFunctions functions,
}) async {
  final createShareLink = functions.httpsCallable("createShareLink");
  final request = {
    ...data,
    "appChannel": kReleaseMode ? "prod" : "dev",
  };
  final result = await createShareLink(request);
  return result.data["url"];
}

/// Creates a submission link for the given submission ID.
String createSubmissionLink(int submissionId, {required String uid}) {
  final uri = Uri(
    scheme: "https",
    host: appDomain,
    path: "/submissions/$submissionId",
    queryParameters: {
      "uid": uid,
    },
  );
  return uri.toString();
}
