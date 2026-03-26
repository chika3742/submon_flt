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

String _$prefNotifierHash() => r'902ec897aced9f954fd7e46e69220bd6f1af73de';

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

@ProviderFor(firebaseAuth)
final firebaseAuthProvider = FirebaseAuthProvider._();

final class FirebaseAuthProvider
    extends $FunctionalProvider<FirebaseAuth, FirebaseAuth, FirebaseAuth>
    with $Provider<FirebaseAuth> {
  FirebaseAuthProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firebaseAuthProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthHash();

  @$internal
  @override
  $ProviderElement<FirebaseAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAuth create(Ref ref) {
    return firebaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAuth>(value),
    );
  }
}

String _$firebaseAuthHash() => r'8c3e9d11b27110ca96130356b5ef4d5d34a5ffc2';

@ProviderFor(googleSignIn)
final googleSignInProvider = GoogleSignInProvider._();

final class GoogleSignInProvider
    extends $FunctionalProvider<GoogleSignIn, GoogleSignIn, GoogleSignIn>
    with $Provider<GoogleSignIn> {
  GoogleSignInProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'googleSignInProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$googleSignInHash();

  @$internal
  @override
  $ProviderElement<GoogleSignIn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleSignIn create(Ref ref) {
    return googleSignIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignIn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignIn>(value),
    );
  }
}

String _$googleSignInHash() => r'be6e657edfb1790d127cff1d3820a50c34e65011';

@ProviderFor(crashlytics)
final crashlyticsProvider = CrashlyticsProvider._();

final class CrashlyticsProvider extends $FunctionalProvider<
    FirebaseCrashlytics,
    FirebaseCrashlytics,
    FirebaseCrashlytics> with $Provider<FirebaseCrashlytics> {
  CrashlyticsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'crashlyticsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$crashlyticsHash();

  @$internal
  @override
  $ProviderElement<FirebaseCrashlytics> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseCrashlytics create(Ref ref) {
    return crashlytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseCrashlytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseCrashlytics>(value),
    );
  }
}

String _$crashlyticsHash() => r'155108b0d2e2c244304ed72e1be15318f2f933c5';

@ProviderFor(analytics)
final analyticsProvider = AnalyticsProvider._();

final class AnalyticsProvider extends $FunctionalProvider<FirebaseAnalytics,
    FirebaseAnalytics, FirebaseAnalytics> with $Provider<FirebaseAnalytics> {
  AnalyticsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'analyticsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$analyticsHash();

  @$internal
  @override
  $ProviderElement<FirebaseAnalytics> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAnalytics create(Ref ref) {
    return analytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAnalytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAnalytics>(value),
    );
  }
}

String _$analyticsHash() => r'8fb06ce3653ba0d954e4379b42d73d731065c520';

@ProviderFor(appleSignInAndroid)
final appleSignInAndroidProvider = AppleSignInAndroidProvider._();

final class AppleSignInAndroidProvider extends $FunctionalProvider<
    AppleSignInAndroid,
    AppleSignInAndroid,
    AppleSignInAndroid> with $Provider<AppleSignInAndroid> {
  AppleSignInAndroidProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appleSignInAndroidProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appleSignInAndroidHash();

  @$internal
  @override
  $ProviderElement<AppleSignInAndroid> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppleSignInAndroid create(Ref ref) {
    return appleSignInAndroid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppleSignInAndroid value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppleSignInAndroid>(value),
    );
  }
}

String _$appleSignInAndroidHash() =>
    r'310303d2bc041da9059f23f5e870e5c697263b57';

@ProviderFor(messagingApi)
final messagingApiProvider = MessagingApiProvider._();

final class MessagingApiProvider
    extends $FunctionalProvider<MessagingApi, MessagingApi, MessagingApi>
    with $Provider<MessagingApi> {
  MessagingApiProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'messagingApiProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$messagingApiHash();

  @$internal
  @override
  $ProviderElement<MessagingApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MessagingApi create(Ref ref) {
    return messagingApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessagingApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessagingApi>(value),
    );
  }
}

String _$messagingApiHash() => r'28e12dc1c33cb0da097d6509addf5369b6326936';

@ProviderFor(generalApi)
final generalApiProvider = GeneralApiProvider._();

final class GeneralApiProvider
    extends $FunctionalProvider<GeneralApi, GeneralApi, GeneralApi>
    with $Provider<GeneralApi> {
  GeneralApiProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'generalApiProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generalApiHash();

  @$internal
  @override
  $ProviderElement<GeneralApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GeneralApi create(Ref ref) {
    return generalApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeneralApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeneralApi>(value),
    );
  }
}

String _$generalApiHash() => r'e05c61c908667fae59dab08ee2a9f4a98bfe6863';

@ProviderFor(browserApi)
final browserApiProvider = BrowserApiProvider._();

final class BrowserApiProvider
    extends $FunctionalProvider<BrowserApi, BrowserApi, BrowserApi>
    with $Provider<BrowserApi> {
  BrowserApiProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'browserApiProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$browserApiHash();

  @$internal
  @override
  $ProviderElement<BrowserApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BrowserApi create(Ref ref) {
    return browserApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowserApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowserApi>(value),
    );
  }
}

String _$browserApiHash() => r'981ae7550902cee190b40773e45d675c5f08c92b';

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
          isAutoDispose: false,
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

String _$firebaseUserHash() => r'5b024f43ad3d70c4d847f7a7deb854c3ce160e6a';
