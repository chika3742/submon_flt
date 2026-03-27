import "package:cloud_functions/cloud_functions.dart";
import "package:flutter/foundation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../isar_db/isar_submission.dart";

part "functions_service.g.dart";

@Riverpod(keepAlive: true)
FunctionsService functionsService(Ref ref) {
  return FunctionsService(
    FirebaseFunctions.instanceFor(region: "asia-northeast1"),
  );
}

class FunctionsService {
  final FirebaseFunctions _functions;

  const FunctionsService(this._functions);

  /// Creates a submission share link with the given data.
  ///
  /// Returns the URL of the created link.
  Future<String> createShareLink(Map<String, Object> data) async {
    final createShareLink = _functions.httpsCallable("createShareLink");
    final request = {
      ...data,
      "appChannel": kReleaseMode ? "prod" : "dev",
    };
    final result = await createShareLink(request);
    return result.data["url"];
  }

  static Map<String, Object> submissionToShareLinkData(Submission submission) {
    return {
      "title": submission.title,
      "due": submission.due.toUtc().toIso8601String(),
      if (submission.details.isNotEmpty) "details": submission.details,
    };
  }

  Future<void> createUser() {
    return _functions.httpsCallable("createUser").call();
  }
}
