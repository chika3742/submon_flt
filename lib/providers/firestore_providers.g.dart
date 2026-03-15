// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 現在の認証ユーザーに対応する Firestore ドキュメント参照。
/// 未認証時は null。

@ProviderFor(userDoc)
final userDocProvider = UserDocProvider._();

/// 現在の認証ユーザーに対応する Firestore ドキュメント参照。
/// 未認証時は null。

final class UserDocProvider extends $FunctionalProvider<
        DocumentReference<Map<String, dynamic>>?,
        DocumentReference<Map<String, dynamic>>?,
        DocumentReference<Map<String, dynamic>>?>
    with $Provider<DocumentReference<Map<String, dynamic>>?> {
  /// 現在の認証ユーザーに対応する Firestore ドキュメント参照。
  /// 未認証時は null。
  UserDocProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userDocProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userDocHash();

  @$internal
  @override
  $ProviderElement<DocumentReference<Map<String, dynamic>>?> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentReference<Map<String, dynamic>>? create(Ref ref) {
    return userDoc(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentReference<Map<String, dynamic>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<DocumentReference<Map<String, dynamic>>?>(value),
    );
  }
}

String _$userDocHash() => r'c358cae1c4936d3ee3380634a55a7cdfc61329b0';

/// Firestore 上のユーザー設定 (UserConfig) を管理する AsyncNotifier。
///
/// `build()` で UserConfig を fetch し、各メソッドでユーザードキュメントの
/// フィールドを更新する。

@ProviderFor(FirestoreUserConfigNotifier)
final firestoreUserConfigProvider = FirestoreUserConfigNotifierProvider._();

/// Firestore 上のユーザー設定 (UserConfig) を管理する AsyncNotifier。
///
/// `build()` で UserConfig を fetch し、各メソッドでユーザードキュメントの
/// フィールドを更新する。
final class FirestoreUserConfigNotifierProvider
    extends $AsyncNotifierProvider<FirestoreUserConfigNotifier, UserConfig?> {
  /// Firestore 上のユーザー設定 (UserConfig) を管理する AsyncNotifier。
  ///
  /// `build()` で UserConfig を fetch し、各メソッドでユーザードキュメントの
  /// フィールドを更新する。
  FirestoreUserConfigNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firestoreUserConfigProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firestoreUserConfigNotifierHash();

  @$internal
  @override
  FirestoreUserConfigNotifier create() => FirestoreUserConfigNotifier();
}

String _$firestoreUserConfigNotifierHash() =>
    r'1abb23cd8370e0e4a72f235dc234accdb333e23e';

/// Firestore 上のユーザー設定 (UserConfig) を管理する AsyncNotifier。
///
/// `build()` で UserConfig を fetch し、各メソッドでユーザードキュメントの
/// フィールドを更新する。

abstract class _$FirestoreUserConfigNotifier
    extends $AsyncNotifier<UserConfig?> {
  FutureOr<UserConfig?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserConfig?>, UserConfig?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserConfig?>, UserConfig?>,
        AsyncValue<UserConfig?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreCollectionProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```

@ProviderFor(FirestoreCollectionNotifier)
final firestoreCollectionProvider = FirestoreCollectionNotifierFamily._();

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreCollectionProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```
final class FirestoreCollectionNotifierProvider
    extends $NotifierProvider<FirestoreCollectionNotifier, void> {
  /// Firestore コレクションへの CRUD をラップし、
  /// 書き込み時にタイムスタンプを自動更新する Notifier。
  ///
  /// コレクションごとにインスタンスが生成される (family provider)。
  /// ```dart
  /// final notifier = ref.watch(firestoreCollectionProvider("submission").notifier);
  /// await notifier.set(docId, data);
  /// ```
  FirestoreCollectionNotifierProvider._(
      {required FirestoreCollectionNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'firestoreCollectionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firestoreCollectionNotifierHash();

  @override
  String toString() {
    return r'firestoreCollectionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FirestoreCollectionNotifier create() => FirestoreCollectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FirestoreCollectionNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$firestoreCollectionNotifierHash() =>
    r'a2141d746a7d7941a114b74c9adf0dd67ae04887';

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreCollectionProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```

final class FirestoreCollectionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<FirestoreCollectionNotifier, void, void, void,
            String> {
  FirestoreCollectionNotifierFamily._()
      : super(
          retry: null,
          name: r'firestoreCollectionProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Firestore コレクションへの CRUD をラップし、
  /// 書き込み時にタイムスタンプを自動更新する Notifier。
  ///
  /// コレクションごとにインスタンスが生成される (family provider)。
  /// ```dart
  /// final notifier = ref.watch(firestoreCollectionProvider("submission").notifier);
  /// await notifier.set(docId, data);
  /// ```

  FirestoreCollectionNotifierProvider call(
    String collectionId,
  ) =>
      FirestoreCollectionNotifierProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'firestoreCollectionProvider';
}

/// Firestore コレクションへの CRUD をラップし、
/// 書き込み時にタイムスタンプを自動更新する Notifier。
///
/// コレクションごとにインスタンスが生成される (family provider)。
/// ```dart
/// final notifier = ref.watch(firestoreCollectionProvider("submission").notifier);
/// await notifier.set(docId, data);
/// ```

abstract class _$FirestoreCollectionNotifier extends $Notifier<void> {
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
