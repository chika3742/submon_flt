import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../core/failure.dart";

part "background_tasks_notifier.g.dart";

/// Repository 等がバックグラウンドエラーを報告するためのインターフェース。
abstract interface class BackgroundErrorReporter {
  void report(Object error, StackTrace stackTrace);
}

/// Observer が検出するための内部イベント。
class _BackgroundErrorEvent implements ErrorState {
  _BackgroundErrorEvent(this.error, this.errorStackTrace);

  @override
  final Object error;

  @override
  final StackTrace errorStackTrace;
}

/// バックグラウンドタスクの実行とエラー報告を統合する Notifier。
///
/// state は `Object?` で、`null` はエラーなし、非 null はエラーイベントを表す。
/// [CrashlyticsObserver] は [ErrorState] 経由で自動検出する。
@Riverpod(keepAlive: true)
class BackgroundTasks extends _$BackgroundTasks
    implements BackgroundErrorReporter {
  @override
  Object? build() => null;

  /// バックグラウンドタスクを実行し、エラーを自動的に報告する。
  void run(Future<void> Function() task) {
    unawaited(() async {
      try {
        await task();
      } catch (e, st) {
        state = _BackgroundErrorEvent(e, st);
      }
    }());
  }

  /// バックグラウンドエラーを直接報告する。
  @override
  void report(Object error, StackTrace stackTrace) {
    state = _BackgroundErrorEvent(error, stackTrace);
  }
}
