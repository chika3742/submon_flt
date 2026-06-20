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

@ProviderFor(appleSignInAndroid)
final appleSignInAndroidProvider = AppleSignInAndroidProvider._();

final class AppleSignInAndroidProvider
    extends
        $FunctionalProvider<
          AppleSignInAndroid,
          AppleSignInAndroid,
          AppleSignInAndroid
        >
    with $Provider<AppleSignInAndroid> {
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
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

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
