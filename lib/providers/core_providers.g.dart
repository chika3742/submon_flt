// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isar)
final isarProvider = IsarProvider._();

final class IsarProvider
    extends $FunctionalProvider<AsyncValue<Isar>, Isar, FutureOr<Isar>>
    with $FutureModifier<Isar>, $FutureProvider<Isar> {
  IsarProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isarProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isarHash();

  @$internal
  @override
  $FutureProviderElement<Isar> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Isar> create(Ref ref) {
    return isar(ref);
  }
}

String _$isarHash() => r'6ae460417b62705de43397fca348fc4f268eda3c';

/// main() で初期化済みの [SharedPreferencesWithCache] を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。
/// 外部からは [prefProvider] を通じてアクセスすること。

@ProviderFor(sharedPrefsService)
final sharedPrefsServiceProvider = SharedPrefsServiceProvider._();

/// main() で初期化済みの [SharedPreferencesWithCache] を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。
/// 外部からは [prefProvider] を通じてアクセスすること。

final class SharedPrefsServiceProvider extends $FunctionalProvider<
    SharedPreferencesWithCache,
    SharedPreferencesWithCache,
    SharedPreferencesWithCache> with $Provider<SharedPreferencesWithCache> {
  /// main() で初期化済みの [SharedPreferencesWithCache] を受け取る同期 Provider。
  /// ProviderScope の overrides で実体を注入する。
  /// 外部からは [prefProvider] を通じてアクセスすること。
  SharedPrefsServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sharedPrefsServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sharedPrefsServiceHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesWithCache> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SharedPreferencesWithCache create(Ref ref) {
    return sharedPrefsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesWithCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesWithCache>(value),
    );
  }
}

String _$sharedPrefsServiceHash() =>
    r'0d9972ff4770b843f6fc9b27d2d217d0c1e4d99c';

@ProviderFor(PrefNotifier)
final prefProvider = PrefNotifierFamily._();

final class PrefNotifierProvider<T extends Object?>
    extends $NotifierProvider<PrefNotifier<T>, T> {
  PrefNotifierProvider._(
      {required PrefNotifierFamily super.from,
      required PrefKey<T> super.argument})
      : super(
          retry: null,
          name: r'prefProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$prefNotifierHash();

  @override
  String toString() {
    return r'prefProvider'
        '<${T}>'
        '($argument)';
  }

  @$internal
  @override
  PrefNotifier<T> create() => PrefNotifier<T>();

  $R _captureGenerics<$R>($R Function<T extends Object?>() cb) {
    return cb<T>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(T value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<T>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PrefNotifierProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$prefNotifierHash() => r'c461662b203c70ca6af831492f5da4c5781e2cc0';

final class PrefNotifierFamily extends $Family {
  PrefNotifierFamily._()
      : super(
          retry: null,
          name: r'prefProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PrefNotifierProvider<T> call<T extends Object?>(
    PrefKey<T> key,
  ) =>
      PrefNotifierProvider<T>._(argument: key, from: this);

  @override
  String toString() => r'prefProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(PrefNotifier<T> Function<T extends Object?>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as PrefNotifierProvider;
            return provider._captureGenerics(<T extends Object?>() {
              provider as PrefNotifierProvider<T>;
              return provider.$view(create: create<T>).$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          T Function<T extends Object?>(Ref ref, PrefNotifier<T> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as PrefNotifierProvider;
            return provider._captureGenerics(<T extends Object?>() {
              provider as PrefNotifierProvider<T>;
              return provider
                  .$view(runNotifierBuildOverride: build<T>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$PrefNotifier<T extends Object?> extends $Notifier<T> {
  late final _$args = ref.$arg as PrefKey<T>;
  PrefKey<T> get key => _$args;

  T build(
    PrefKey<T> key,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<T, T>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<T, T>, T, Object?, Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

@ProviderFor(firebaseUser)
final firebaseUserProvider = FirebaseUserProvider._();

final class FirebaseUserProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  FirebaseUserProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firebaseUserProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firebaseUserHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return firebaseUser(ref);
  }
}

String _$firebaseUserHash() => r'41ccd6f03a5c4ed94888741812ccad955176fcc0';

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

@ProviderFor(googleSignedInAccount)
final googleSignedInAccountProvider = GoogleSignedInAccountProvider._();

final class GoogleSignedInAccountProvider extends $FunctionalProvider<
        AsyncValue<GoogleSignInAccount?>,
        GoogleSignInAccount?,
        Stream<GoogleSignInAccount?>>
    with
        $FutureModifier<GoogleSignInAccount?>,
        $StreamProvider<GoogleSignInAccount?> {
  GoogleSignedInAccountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'googleSignedInAccountProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$googleSignedInAccountHash();

  @$internal
  @override
  $StreamProviderElement<GoogleSignInAccount?> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<GoogleSignInAccount?> create(Ref ref) {
    return googleSignedInAccount(ref);
  }
}

String _$googleSignedInAccountHash() =>
    r'23463f17bc7b28e302f6af93b97b039fc3436915';

/// This provider must be refreshed manually when the authorized scopes changed.

@ProviderFor(googleAuthenticatedClient)
final googleAuthenticatedClientProvider = GoogleAuthenticatedClientProvider._();

/// This provider must be refreshed manually when the authorized scopes changed.

final class GoogleAuthenticatedClientProvider extends $FunctionalProvider<
        AsyncValue<AuthClient?>, AuthClient?, FutureOr<AuthClient?>>
    with $FutureModifier<AuthClient?>, $FutureProvider<AuthClient?> {
  /// This provider must be refreshed manually when the authorized scopes changed.
  GoogleAuthenticatedClientProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'googleAuthenticatedClientProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$googleAuthenticatedClientHash();

  @$internal
  @override
  $FutureProviderElement<AuthClient?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthClient?> create(Ref ref) {
    return googleAuthenticatedClient(ref);
  }
}

String _$googleAuthenticatedClientHash() =>
    r'd8c49a4517e18f51f5bb1049e47a038a18c4cbfd';
