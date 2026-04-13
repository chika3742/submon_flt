import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../features/logging/infrastructure/crashlytics.dart";
import "result.dart";

mixin ResultStateGuard<StateT, ValueT, E extends Object> on AnyNotifier<StateT, ValueT> {
  StateT get stableState;

  E mapUnexpectedError(Object e);

  ResultFutureOr<T, E> guard<T>(
    ResultFutureOr<({T result, StateT newState}), E> Function() action, {
    bool setErrorStateOnFail = false,
  }) async {
    try {
      final result = await action();
      switch (result) {
        case ResultOk(value: (:final result, :final newState)):
          state = newState;
          return Result.ok(result);
        case ResultFailed(:final propagate):
          state = stableState;
          return propagate();
      }
    } catch (e, st) {
      state = stableState;
      ref.read(errorReporterProvider).report(e, st);
      return Result.failed(mapUnexpectedError(e), st);
    }
  }
}
