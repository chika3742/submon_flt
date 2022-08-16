import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsHelper {
  static void logMarkedAsDone(bool done, String method) {
    if (!done) {
      FirebaseAnalytics.instance
          .logEvent(name: "marked_submission_as_done", parameters: {
        "method": method,
      });
    } else {
      FirebaseAnalytics.instance
          .logEvent(name: "unmarked_submission_as_done", parameters: {
        "method": method,
      });
    }
  }
}