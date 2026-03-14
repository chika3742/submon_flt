// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreNotifierProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```

@ProviderFor(FirestoreNotifier)
final firestoreProvider = FirestoreNotifierFamily._();

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreNotifierProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```
final class FirestoreNotifierProvider
    extends $NotifierProvider<FirestoreNotifier, void> {
  /// Firestore コレクションへの CRUD をラップし、
  /// 書き込み時にタイムスタンプを自動更新する Notifier。
  ///
  /// コレクションごとにインスタンスが生成される (family provider)。
  /// ```dart
  /// final notifier = ref.watch(firestoreNotifierProvider("submission").notifier);
  /// await notifier.set(docId, data);
  /// ```
  FirestoreNotifierProvider._(
      {required FirestoreNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'firestoreProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firestoreNotifierHash();

  @override
  String toString() {
    return r'firestoreProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FirestoreNotifier create() => FirestoreNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FirestoreNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$firestoreNotifierHash() => r'dd4bf9b8e3b0b24fc83ba34cbf6ece6ec3ed0d4e';

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreNotifierProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```

final class FirestoreNotifierFamily extends $Family
    with $ClassFamilyOverride<FirestoreNotifier, void, void, void, String> {
  FirestoreNotifierFamily._()
      : super(
          retry: null,
          name: r'firestoreProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Firestore コレクションへの CRUD をラップし、
  /// 書き込み時にタイムスタンプを自動更新する Notifier。
  ///
  /// コレクションごとにインスタンスが生成される (family provider)。
  /// ```dart
  /// final notifier = ref.watch(firestoreNotifierProvider("submission").notifier);
  /// await notifier.set(docId, data);
  /// ```

  FirestoreNotifierProvider call(
    String collectionId,
  ) =>
      FirestoreNotifierProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'firestoreProvider';
}

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreNotifierProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```

abstract class _$FirestoreNotifier extends $Notifier<void> {
  late final _$args = ref.$arg as String;
  String get collectionId => _$args;

  void build(
    String collectionId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

/// Firestore 上のユーザー設定 (UserConfig) を取得する Provider。

@ProviderFor(userConfig)
final userConfigProvider = UserConfigProvider._();

/// Firestore 上のユーザー設定 (UserConfig) を取得する Provider。

final class UserConfigProvider extends $FunctionalProvider<
        AsyncValue<UserConfig?>, UserConfig?, FutureOr<UserConfig?>>
    with $FutureModifier<UserConfig?>, $FutureProvider<UserConfig?> {
  /// Firestore 上のユーザー設定 (UserConfig) を取得する Provider。
  UserConfigProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userConfigProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userConfigHash();

  @$internal
  @override
  $FutureProviderElement<UserConfig?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserConfig?> create(Ref ref) {
    return userConfig(ref);
  }
}

String _$userConfigHash() => r'b8b5bf0c9fccf5be0c941619327214faa4d48b8f';
