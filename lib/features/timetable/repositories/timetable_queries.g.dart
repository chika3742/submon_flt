// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_queries.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(timetableTables)
final timetableTablesProvider = TimetableTablesProvider._();

final class TimetableTablesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TimetableTable>>,
          List<TimetableTable>,
          Stream<List<TimetableTable>>
        >
    with
        $FutureModifier<List<TimetableTable>>,
        $StreamProvider<List<TimetableTable>> {
  TimetableTablesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timetableTablesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timetableTablesHash();

  @$internal
  @override
  $StreamProviderElement<List<TimetableTable>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TimetableTable>> create(Ref ref) {
    return timetableTables(ref);
  }
}

String _$timetableTablesHash() => r'd72ef3c8f70e19e5a6e04d9c07677f4bcfa66655';

@ProviderFor(classTimes)
final classTimesProvider = ClassTimesProvider._();

final class ClassTimesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TimetableClassTime>>,
          List<TimetableClassTime>,
          Stream<List<TimetableClassTime>>
        >
    with
        $FutureModifier<List<TimetableClassTime>>,
        $StreamProvider<List<TimetableClassTime>> {
  ClassTimesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classTimesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classTimesHash();

  @$internal
  @override
  $StreamProviderElement<List<TimetableClassTime>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TimetableClassTime>> create(Ref ref) {
    return classTimes(ref);
  }
}

String _$classTimesHash() => r'99b66d93c2506303f200cf7ffcdfb25f2a19b9f3';

/// Cells of the given table.

@ProviderFor(timetableCells)
final timetableCellsProvider = TimetableCellsFamily._();

/// Cells of the given table.

final class TimetableCellsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Timetable>>,
          List<Timetable>,
          Stream<List<Timetable>>
        >
    with $FutureModifier<List<Timetable>>, $StreamProvider<List<Timetable>> {
  /// Cells of the given table.
  TimetableCellsProvider._({
    required TimetableCellsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'timetableCellsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$timetableCellsHash();

  @override
  String toString() {
    return r'timetableCellsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Timetable>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Timetable>> create(Ref ref) {
    final argument = this.argument as int;
    return timetableCells(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TimetableCellsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$timetableCellsHash() => r'a70e530ce5bfa360bc21870e806dbfd0d2ca043b';

/// Cells of the given table.

final class TimetableCellsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Timetable>>, int> {
  TimetableCellsFamily._()
    : super(
        retry: null,
        name: r'timetableCellsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Cells of the given table.

  TimetableCellsProvider call(int tableId) =>
      TimetableCellsProvider._(argument: tableId, from: this);

  @override
  String toString() => r'timetableCellsProvider';
}

/// Cells of the currently selected table (cellId -> Timetable).
/// Depends on [timetableCellsProvider] and converts it into a [Map].

@ProviderFor(currentTimetable)
final currentTimetableProvider = CurrentTimetableProvider._();

/// Cells of the currently selected table (cellId -> Timetable).
/// Depends on [timetableCellsProvider] and converts it into a [Map].

final class CurrentTimetableProvider
    extends
        $FunctionalProvider<
          TimetableSnapshot,
          TimetableSnapshot,
          TimetableSnapshot
        >
    with $Provider<TimetableSnapshot> {
  /// Cells of the currently selected table (cellId -> Timetable).
  /// Depends on [timetableCellsProvider] and converts it into a [Map].
  CurrentTimetableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTimetableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTimetableHash();

  @$internal
  @override
  $ProviderElement<TimetableSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimetableSnapshot create(Ref ref) {
    return currentTimetable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableSnapshot>(value),
    );
  }
}

String _$currentTimetableHash() => r'e7b54ec9c3173662bb0a5019381f5c09855437ea';
