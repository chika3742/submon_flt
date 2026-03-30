import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "failure.dart";

/// Crashlytics 記録を行う唯一の ProviderObserver。
///
/// プロバイダの状態変化を監視し、[ErrorState] / [AsyncError] からエラーを抽出する。
/// エラーが [Failure] なら [FailureSeverity.unexpected] の場合のみ記録し、
/// [Failure] でないエラーは無条件に記録する。
///
/// グローバルエラーハンドラ（`FlutterError.onError` /
/// `PlatformDispatcher.onError`）を除き、これが Crashlytics 記録の唯一の箇所。
final class CrashlyticsObserver extends ProviderObserver {
  CrashlyticsObserver(this._crashlytics);
  final FirebaseCrashlytics _crashlytics;

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    switch (newValue) {
      case ErrorState(:final error, :final errorStackTrace):
        final prevError =
            previousValue is ErrorState ? previousValue.error : null;
        if (error == prevError) return;

        _record(error, errorStackTrace, context);
      case AsyncError(:final error, :final stackTrace):
        if (previousValue is AsyncError &&
            previousValue.error == error) {
          return;
        }

        _record(error, stackTrace, context);
    }
  }

  /// Provider の build() が throw した場合や、
  /// FutureProvider/StreamProvider がエラーを emit した場合の安全ネット。
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _record(error, stackTrace, context);
  }

  /// エラーの型に応じて Crashlytics に記録する。
  ///
  /// - [Failure] かつ [FailureSeverity.unexpected] → 記録
  /// - [Failure] かつ [FailureSeverity.expected] → スキップ
  /// - [Failure] 以外 → 無条件に記録
  void _record(
    Object error,
    StackTrace stackTrace,
    ProviderObserverContext context,
  ) {
    switch (error) {
      case Failure(:final severity, :final cause, :final causeStackTrace):
        if (severity != FailureSeverity.unexpected) return;
        _crashlytics.recordError(
          cause ?? error,
          causeStackTrace ?? stackTrace,
          reason: error.toString(),
        );
      default:
        _crashlytics.recordError(
          error,
          stackTrace,
          reason: "Non-Failure error: ${context.provider}",
        );
    }
  }
}
