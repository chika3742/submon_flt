abstract interface class ErrorReporter {
  const ErrorReporter();

  void report(Object error, StackTrace? stackTrace, {String? reason});
}
