// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(timetableRepository)
final timetableRepositoryProvider = TimetableRepositoryProvider._();

final class TimetableRepositoryProvider extends $FunctionalProvider<
    TimetableRepository,
    TimetableRepository,
    TimetableRepository> with $Provider<TimetableRepository> {
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    r'22f73e6587520e657dad1bbfdd7e1c04f347180f';

@ProviderFor(timetableTableRepository)
final timetableTableRepositoryProvider = TimetableTableRepositoryProvider._();

final class TimetableTableRepositoryProvider extends $FunctionalProvider<
    TimetableTableRepository,
    TimetableTableRepository,
    TimetableTableRepository> with $Provider<TimetableTableRepository> {
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    r'a820fe7c27b0f0829d1efae5edd6ba585dce9736';

@ProviderFor(timetableClassTimeRepository)
final timetableClassTimeRepositoryProvider =
    TimetableClassTimeRepositoryProvider._();

final class TimetableClassTimeRepositoryProvider extends $FunctionalProvider<
    TimetableClassTimeRepository,
    TimetableClassTimeRepository,
    TimetableClassTimeRepository> with $Provider<TimetableClassTimeRepository> {
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    r'519dd5e818b4983778db32fb5097e0734f0f728b';

@ProviderFor(timetableTables)
final timetableTablesProvider = TimetableTablesProvider._();

final class TimetableTablesProvider extends $FunctionalProvider<
        AsyncValue<List<TimetableTable>>,
        List<TimetableTable>,
        Stream<List<TimetableTable>>>
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TimetableTable>> create(Ref ref) {
    return timetableTables(ref);
  }
}

String _$timetableTablesHash() => r'd72ef3c8f70e19e5a6e04d9c07677f4bcfa66655';

@ProviderFor(classTimes)
final classTimesProvider = ClassTimesProvider._();

final class ClassTimesProvider extends $FunctionalProvider<
        AsyncValue<List<TimetableClassTime>>,
        List<TimetableClassTime>,
        Stream<List<TimetableClassTime>>>
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<TimetableClassTime>> create(Ref ref) {
    return classTimes(ref);
  }
}

String _$classTimesHash() => r'99b66d93c2506303f200cf7ffcdfb25f2a19b9f3';

/// 指定テーブルのセル一覧。

@ProviderFor(timetableCells)
final timetableCellsProvider = TimetableCellsFamily._();

/// 指定テーブルのセル一覧。

final class TimetableCellsProvider extends $FunctionalProvider<
        AsyncValue<List<Timetable>>, List<Timetable>, Stream<List<Timetable>>>
    with $FutureModifier<List<Timetable>>, $StreamProvider<List<Timetable>> {
  /// 指定テーブルのセル一覧。
  TimetableCellsProvider._(
      {required TimetableCellsFamily super.from, required int super.argument})
      : super(
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Timetable>> create(Ref ref) {
    final argument = this.argument as int;
    return timetableCells(
      ref,
      argument,
    );
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

/// 指定テーブルのセル一覧。

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

  /// 指定テーブルのセル一覧。

  TimetableCellsProvider call(
    int tableId,
  ) =>
      TimetableCellsProvider._(argument: tableId, from: this);

  @override
  String toString() => r'timetableCellsProvider';
}

/// 現在選択中のテーブルのセル一覧 (cellId → Timetable)。
/// [timetableCellsProvider] に依存し、Map に変換する。

@ProviderFor(currentTimetable)
final currentTimetableProvider = CurrentTimetableProvider._();

/// 現在選択中のテーブルのセル一覧 (cellId → Timetable)。
/// [timetableCellsProvider] に依存し、Map に変換する。

final class CurrentTimetableProvider extends $FunctionalProvider<
    TimetableSnapshot,
    TimetableSnapshot,
    TimetableSnapshot> with $Provider<TimetableSnapshot> {
  /// 現在選択中のテーブルのセル一覧 (cellId → Timetable)。
  /// [timetableCellsProvider] に依存し、Map に変換する。
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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

/// Undo/Redo スタックの SSoT。

@ProviderFor(UndoRedo)
final undoRedoProvider = UndoRedoProvider._();

/// Undo/Redo スタックの SSoT。
final class UndoRedoProvider extends $NotifierProvider<
    UndoRedo,
    ({
      List<TimetableSnapshot> redoStack,
      List<TimetableSnapshot> undoStack,
    })> {
  /// Undo/Redo スタックの SSoT。
  UndoRedoProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'undoRedoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$undoRedoHash();

  @$internal
  @override
  UndoRedo create() => UndoRedo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
      ({
        List<TimetableSnapshot> redoStack,
        List<TimetableSnapshot> undoStack,
      }) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<
          ({
            List<TimetableSnapshot> redoStack,
            List<TimetableSnapshot> undoStack,
          })>(value),
    );
  }
}

String _$undoRedoHash() => r'd3d9bf21b173e1864568b1dfc8f8a94545a53b3b';

/// Undo/Redo スタックの SSoT。

abstract class _$UndoRedo extends $Notifier<
    ({
      List<TimetableSnapshot> redoStack,
      List<TimetableSnapshot> undoStack,
    })> {
  ({
    List<TimetableSnapshot> redoStack,
    List<TimetableSnapshot> undoStack,
  }) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<
        ({
          List<TimetableSnapshot> redoStack,
          List<TimetableSnapshot> undoStack,
        }),
        ({
          List<TimetableSnapshot> redoStack,
          List<TimetableSnapshot> undoStack,
        })>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<
            ({
              List<TimetableSnapshot> redoStack,
              List<TimetableSnapshot> undoStack,
            }),
            ({
              List<TimetableSnapshot> redoStack,
              List<TimetableSnapshot> undoStack,
            })>,
        ({
          List<TimetableSnapshot> redoStack,
          List<TimetableSnapshot> undoStack,
        }),
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(timetableEditUseCase)
final timetableEditUseCaseProvider = TimetableEditUseCaseProvider._();

final class TimetableEditUseCaseProvider extends $FunctionalProvider<
    TimetableEditUseCase,
    TimetableEditUseCase,
    TimetableEditUseCase> with $Provider<TimetableEditUseCase> {
  TimetableEditUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'timetableEditUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$timetableEditUseCaseHash();

  @$internal
  @override
  $ProviderElement<TimetableEditUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimetableEditUseCase create(Ref ref) {
    return timetableEditUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableEditUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableEditUseCase>(value),
    );
  }
}

String _$timetableEditUseCaseHash() =>
    r'20f3abf9da42cdb1edae3062a2386ccb0a3e73c9';
