// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pref_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// main() で初期化済みの [SharedPreferencesWithCache] を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。
/// 外部からは [prefProvider] を通じてアクセスすること。

@ProviderFor(sharedPrefsService)
final sharedPrefsServiceProvider = SharedPrefsServiceProvider._();

/// main() で初期化済みの [SharedPreferencesWithCache] を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。
/// 外部からは [prefProvider] を通じてアクセスすること。

final class SharedPrefsServiceProvider
    extends
        $FunctionalProvider<
          SharedPreferencesWithCache,
          SharedPreferencesWithCache,
          SharedPreferencesWithCache
        >
    with $Provider<SharedPreferencesWithCache> {
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
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

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
  PrefNotifierProvider._({
    required PrefNotifierFamily super.from,
    required PrefKey<T> super.argument,
  }) : super(
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

  PrefNotifierProvider<T> call<T extends Object?>(PrefKey<T> key) =>
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
        },
      );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    T Function<T extends Object?>(Ref ref, PrefNotifier<T> notifier) build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as PrefNotifierProvider;
      return provider._captureGenerics(<T extends Object?>() {
        provider as PrefNotifierProvider<T>;
        return provider
            .$view(runNotifierBuildOverride: build<T>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$PrefNotifier<T extends Object?> extends $Notifier<T> {
  late final _$args = ref.$arg as PrefKey<T>;
  PrefKey<T> get key => _$args;

  T build(PrefKey<T> key);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<T, T>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<T, T>, T, Object?, Object?>;
    element.handleCreate(ref, () => build(_$args));
  }
}
