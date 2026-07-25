import "dart:async";

import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../domain/error_reporter.dart";

part "crashlytics.g.dart";

class CrashlyticsErrorReporter implements ErrorReporter {
  final FirebaseCrashlytics _crashlytics;

  const CrashlyticsErrorReporter(this._crashlytics);

  @override
  void report(Object error, StackTrace? stackTrace, {String? reason}) {
    unawaited(_crashlytics.recordError(error, stackTrace, reason: reason));
  }
}

@Riverpod(name: "errorReporterProvider", keepAlive: true)
ErrorReporter crashlyticsErrorReporter(Ref ref) {
  return CrashlyticsErrorReporter(FirebaseCrashlytics.instance);
}
