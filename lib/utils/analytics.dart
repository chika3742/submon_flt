import "package:firebase_analytics/firebase_analytics.dart";

void logMarkedAsDone(
  FirebaseAnalytics analytics, {
  required bool done,
  required String method,
}) {
  if (!done) {
    analytics.logEvent(name: "marked_submission_as_done", parameters: {
      "method": method,
    });
  } else {
    analytics.logEvent(name: "unmarked_submission_as_done", parameters: {
      "method": method,
    });
  }
}
