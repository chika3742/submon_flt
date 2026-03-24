import "package:flutter/foundation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

mixin NotifierStateGuard<StateT, ValueT> on AnyNotifier<StateT, ValueT> {
  @protected
  StateT getErrorState(Object error, StackTrace st);

  @protected
  Future<void> guard(StateT initLoading, Future<StateT> Function() action) async {
    state = initLoading;
    try {
      state = await action();
    } catch (e, st) {
      state = getErrorState(e, st);
    }
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
