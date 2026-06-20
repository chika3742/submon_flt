import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../utils/distinguish.dart";

part "firestore_error_notifier.g.dart";

abstract interface class FirestoreErrorNotifierAddable {
  void add(Object? error);
}

@riverpod
class FirestoreErrorNotifier extends _$FirestoreErrorNotifier
    implements FirestoreErrorNotifierAddable {
  final _controller = StreamController<Distinguish<Object?>>.broadcast();

  @override
  Stream<Distinguish<Object?>> build() => _controller.stream;

  @override
  void add(Object? error) {
    _controller.add(Distinguish(error));
  }
}
