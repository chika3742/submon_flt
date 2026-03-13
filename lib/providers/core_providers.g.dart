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

/// main() で初期化済みの SharedPreferencesWithCache を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// main() で初期化済みの SharedPreferencesWithCache を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。

final class SharedPreferencesProvider extends $FunctionalProvider<
    SharedPreferencesWithCache,
    SharedPreferencesWithCache,
    SharedPreferencesWithCache> with $Provider<SharedPreferencesWithCache> {
  /// main() で初期化済みの SharedPreferencesWithCache を受け取る同期 Provider。
  /// ProviderScope の overrides で実体を注入する。
  SharedPreferencesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sharedPreferencesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesWithCache> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SharedPreferencesWithCache create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesWithCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesWithCache>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'8bd9188983387667f2ad9695ca168ded6d1065c4';

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
