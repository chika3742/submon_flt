import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

// TODO: Remove this in future version
String get openAppDomain {
  return kReleaseMode ? "open.submon.app" : "dev.open.submon.app";
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
