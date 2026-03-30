import "dart:async";

import "package:flutter/foundation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

mixin NotifierStateGuard<StateT, ValueT> on AnyNotifier<StateT, ValueT> {
  @protected
  StateT getErrorState(Object error, StackTrace st);

  @protected
  void guard(StateT initLoading, Future<StateT> Function() action) {
    unawaited(() async {
      state = initLoading;
      try {
        state = await action();
      } catch (e, st) {
        state = getErrorState(e, st);
      }
    }());
  }

  @protected
  Future<ReturnT?> guardReturning<ReturnT>(StateT initLoading, Future<(StateT, ReturnT)> Function() action) async {
    state = initLoading;
    try {
      final result = await action();
      state = result.$1;
      return result.$2;
    } catch (e, st) {
      state = getErrorState(e, st);
      return null;
    }
  }
}

mixin NotifierStateGuardAsync<ValueT> on AnyNotifier<AsyncValue<ValueT>, ValueT> {
  @protected
  void guard(Future<ValueT> Function() action) {
    unawaited(guardAwaited(action));
  }

  @protected
  Future<void> guardAwaited(Future<ValueT> Function() action) async {
    // ignore: invalid_use_of_internal_member
    state = AsyncValue<ValueT>.loading().copyWithPrevious(state);
    try {
      state = AsyncValue.data(await action());
    } catch (e, st) {
      // ignore: invalid_use_of_internal_member
      state = AsyncValue<ValueT>.error(e, st).copyWithPrevious(state);
      onError(e, st);
    }
  }

  /// A callback that is called when an error occurs in [guard].
  @protected
  void onError(Object error, StackTrace st) {}
}
