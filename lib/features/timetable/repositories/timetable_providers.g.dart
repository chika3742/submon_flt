// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(timetableRepository)
final timetableRepositoryProvider = TimetableRepositoryProvider._();

final class TimetableRepositoryProvider
    extends
        $FunctionalProvider<
          TimetableRepository,
          TimetableRepository,
          TimetableRepository
        >
    with $Provider<TimetableRepository> {
  TimetableRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timetableRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timetableRepositoryHash();

  @$internal
  @override
  $ProviderElement<TimetableRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimetableRepository create(Ref ref) {
    return timetableRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableRepository>(value),
    );
  }
}

String _$timetableRepositoryHash() =>
    r'235a2f12fbf7b9db3a9df4ce84819cba0d5bd199';

@ProviderFor(timetableTableRepository)
final timetableTableRepositoryProvider = TimetableTableRepositoryProvider._();

final class TimetableTableRepositoryProvider
    extends
        $FunctionalProvider<
          TimetableTableRepository,
          TimetableTableRepository,
          TimetableTableRepository
        >
    with $Provider<TimetableTableRepository> {
  TimetableTableRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timetableTableRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timetableTableRepositoryHash();

  @$internal
  @override
  $ProviderElement<TimetableTableRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimetableTableRepository create(Ref ref) {
    return timetableTableRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableTableRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableTableRepository>(value),
    );
  }
}

String _$timetableTableRepositoryHash() =>
    r'2e038104e2affac03348968334500b1370a7e891';

@ProviderFor(timetableClassTimeRepository)
final timetableClassTimeRepositoryProvider =
    TimetableClassTimeRepositoryProvider._();

final class TimetableClassTimeRepositoryProvider
    extends
        $FunctionalProvider<
          TimetableClassTimeRepository,
          TimetableClassTimeRepository,
          TimetableClassTimeRepository
        >
    with $Provider<TimetableClassTimeRepository> {
  TimetableClassTimeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timetableClassTimeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timetableClassTimeRepositoryHash();

  @$internal
  @override
  $ProviderElement<TimetableClassTimeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimetableClassTimeRepository create(Ref ref) {
    return timetableClassTimeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableClassTimeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableClassTimeRepository>(value),
    );
  }
}

String _$timetableClassTimeRepositoryHash() =>
    r'df05b8bfdeca853742f0751119cd6b0d84e8b2d2';
