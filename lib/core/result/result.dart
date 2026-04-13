import "dart:async";

sealed class Result<T, E extends Object> {
  const factory Result.ok(T value) = ResultOk._;

  const factory Result.failed(E error, [StackTrace? st]) = ResultFailed._;

  /// Runs [action] and wraps the outcome in a [Result].
  ///
  /// If [action] completes successfully, its [ResultFutureOr] value is returned
  /// as-is. If [action] throws, the exception and stack trace are captured and
  /// returned as [Result.failed].
  ///
  /// Use this to call code that may throw and turn it into a non-throwing
  /// [ResultFutureOr] at the boundary.
  static ResultFutureOr<T, Object> guard<T>(FutureOr<T> Function() action) async {
    try {
      return Result.ok(await action());
    } catch (e, st) {
      return Result.failed(e, st);
    }
  }

  /// Executes a side effect based on the state of this [Result],
  /// without transforming the value.
  ///
  /// Calls [ok] if this is a [ResultOk], or [failed] if this is a
  /// [ResultFailed]. Neither callback returns a value, making this
  /// method suitable for fire-and-forget side effects such as logging
  /// or showing UI notifications.
  ///
  /// ```dart
  /// result.tap(
  ///   ok: (value) => logger.i('Succeeded: $value'),
  ///   failed: (error, st) => logger.e('Failed: $error', error, st),
  /// );
  /// ```
  void tap({
    void Function(T value)? ok,
    void Function(E error, StackTrace? stackTrace)? failed,
  });

  /// Transforms the error value into a new error type [NewE].
  ///
  /// If this is a [ResultFailed], [transform] is called and its return value is
  /// used as the new error.
  ///
  /// If this is a [ResultOk], the value is preserved and neither callback
  /// is invoked.
  ///
  /// See also:
  /// - [mapErrorWhen], which transforms the error conditionally.
  Result<T, NewE> mapError<NewE extends Object>(
      NewE Function(E error) transform);

  /// Transforms the error value into a new error type [NewE], with
  /// type-conditional branching.
  ///
  /// If this is a [ResultFailed] whose error is of type [ConditionE],
  /// [transform] is called and its return value is used as the new error.
  /// If the error does not match [ConditionE], [orElse] is called instead
  /// with the original error as an [Object].
  ///
  /// If this is a [ResultOk], the value is preserved and neither callback
  /// is invoked.
  ///
  /// [ConditionE] must be specified explicitly, as it cannot be inferred:
  ///
  /// ```dart
  /// // Narrow HttpException into a domain-level Failure.
  /// final Result<User, Failure> result = apiResult.mapErrorWhen<HttpException, Failure>(
  ///   (e) => Failure.network(e.statusCode),
  ///   orElse: (e) => Failure.unexpected(e),
  /// );
  /// ```
  ///
  /// See also:
  /// - [mapError], which transforms the error unconditionally.
  Result<T, NewE> mapErrorWhen<ConditionE, NewE extends Object>(
      NewE Function(ConditionE error) transform, {
        required NewE Function(Object error) orElse,
      });

  ResultOk<T, E> get asOk;
}

final class ResultOk<T, E extends Object> implements Result<T, E> {
  final T value;

  const ResultOk._(this.value);

  @override
  void tap({void Function(T value)? ok, void Function(E error, StackTrace? stackTrace)? failed}) =>
      ok?.call(value);

  @override
  Result<T, NewE> mapError<NewE extends Object>(NewE Function(E error) transform) =>
      Result.ok(value);

  @override
  Result<T, NewE> mapErrorWhen<ConditionE, NewE extends Object>(NewE Function(ConditionE error) transform, {required NewE Function(Object error) orElse}) =>
      Result.ok(value);

  @override
  ResultOk<T, E> get asOk => this;
}

final class ResultFailed<T, E extends Object> implements Result<T, E> {
  final E error;
  final StackTrace? stackTrace;

  const ResultFailed._(this.error, [this.stackTrace]);

  @override
  void tap({void Function(T value)? ok, void Function(E error, StackTrace? stackTrace)? failed}) =>
      failed?.call(error, stackTrace);

  @override
  Result<T, NewE> mapError<NewE extends Object>(NewE Function(E error) transform) =>
      Result.failed(transform(error), stackTrace);

  /// Wraps the error in a new type, propagating this failure up to the caller.
  ///
  /// [transform] is applied to the current error to produce a [NewE].
  /// The stack trace is preserved. [NewT] is not used at runtime; it exists
  /// solely to satisfy the return type at the call site.
  ///
  /// ```dart
  /// if (result case ResultFailed()) {
  ///   return result.propagate(NetworkFailure.new);
  /// }
  /// ```
  ///
  /// See also:
  /// - [mapError], which handles both [ResultOk] and [ResultFailed] without
  ///   a prior pattern match.
  Result<NewT, NewE> propagateError<NewT, NewE extends Object>(NewE Function(E error) transform) =>
      Result.failed(transform(error), stackTrace);

  /// Propagates this [ResultFailed] as-is only transforming success type.
  Result<NewT, E> propagate<NewT, NewE extends Object>() =>
      Result.failed(error, stackTrace);

  @override
  Result<T, NewE> mapErrorWhen<ConditionE, NewE extends Object>(NewE Function(ConditionE error) transform, {required NewE Function(Object error) orElse}) =>
      switch (error) {
        final ConditionE error => Result.failed(transform(error), stackTrace),
        _ => Result.failed(orElse(error), stackTrace),
      };

  @override
  ResultOk<T, E> get asOk => throw StateError("Cannot cast ResultFailre to ResultOk");
}

/// [Future] that returns [Result] and does not throw anything.
typedef ResultFuture<T, E extends Object> = Future<Result<T, E>>;

/// [FutureOr] that returns [Result] and does not throw anything.
typedef ResultFutureOr<T, E extends Object> = FutureOr<Result<T, E>>;

extension FutureResultExtension<T, E extends Object> on FutureOr<Result<T, E>> {
  ResultFuture<T, NewE> mapError<NewE extends Object>(
      NewE Function(E error) transform) async {
    return (await this).mapError(transform);
  }
}
