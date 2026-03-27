// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_error_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FirestoreErrorNotifier)
final firestoreErrorProvider = FirestoreErrorNotifierProvider._();

final class FirestoreErrorNotifierProvider extends $StreamNotifierProvider<
    FirestoreErrorNotifier, Distinguish<Object?>> {
  FirestoreErrorNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firestoreErrorProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firestoreErrorNotifierHash();

  @$internal
  @override
  FirestoreErrorNotifier create() => FirestoreErrorNotifier();
}

String _$firestoreErrorNotifierHash() =>
    r'f1766d06b16fc9cd6cc8f28e546471c53007773a';

abstract class _$FirestoreErrorNotifier
    extends $StreamNotifier<Distinguish<Object?>> {
  Stream<Distinguish<Object?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<Distinguish<Object?>>, Distinguish<Object?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Distinguish<Object?>>, Distinguish<Object?>>,
        AsyncValue<Distinguish<Object?>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
