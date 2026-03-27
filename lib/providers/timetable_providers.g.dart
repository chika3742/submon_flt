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
    r'235a2f12fbf7b9db3a9df4ce84819cba0d5bd199';

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
    r'2e038104e2affac03348968334500b1370a7e891';

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
    r'df05b8bfdeca853742f0751119cd6b0d84e8b2d2';

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

/// tableId ごとの Undo/Redo スタック。

@ProviderFor(UndoRedo)
final undoRedoProvider = UndoRedoFamily._();

/// tableId ごとの Undo/Redo スタック。
final class UndoRedoProvider extends $NotifierProvider<
    UndoRedo,
    ({
      List<TimetableSnapshot> redoStack,
      List<TimetableSnapshot> undoStack,
    })> {
  /// tableId ごとの Undo/Redo スタック。
  UndoRedoProvider._(
      {required UndoRedoFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'undoRedoProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$undoRedoHash();

  @override
  String toString() {
    return r'undoRedoProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is UndoRedoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$undoRedoHash() => r'55a4934a1dce573dac62c3d8b82d3838fed0b373';

/// tableId ごとの Undo/Redo スタック。

final class UndoRedoFamily extends $Family
    with
        $ClassFamilyOverride<
            UndoRedo,
            ({
              List<TimetableSnapshot> redoStack,
              List<TimetableSnapshot> undoStack,
            }),
            ({
              List<TimetableSnapshot> redoStack,
              List<TimetableSnapshot> undoStack,
            }),
            ({
              List<TimetableSnapshot> redoStack,
              List<TimetableSnapshot> undoStack,
            }),
            int> {
  UndoRedoFamily._()
      : super(
          retry: null,
          name: r'undoRedoProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  /// tableId ごとの Undo/Redo スタック。

  UndoRedoProvider call(
    int tableId,
  ) =>
      UndoRedoProvider._(argument: tableId, from: this);

  @override
  String toString() => r'undoRedoProvider';
}

/// tableId ごとの Undo/Redo スタック。

abstract class _$UndoRedo extends $Notifier<
    ({
      List<TimetableSnapshot> redoStack,
      List<TimetableSnapshot> undoStack,
    })> {
  late final _$args = ref.$arg as int;
  int get tableId => _$args;

  ({
    List<TimetableSnapshot> redoStack,
    List<TimetableSnapshot> undoStack,
  }) build(
    int tableId,
  );
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
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

/// tableId スコープの UseCase プロバイダー。

@ProviderFor(timetableEditUseCase)
final timetableEditUseCaseProvider = TimetableEditUseCaseFamily._();

/// tableId スコープの UseCase プロバイダー。

final class TimetableEditUseCaseProvider extends $FunctionalProvider<
    TimetableEditUseCase,
    TimetableEditUseCase,
    TimetableEditUseCase> with $Provider<TimetableEditUseCase> {
  /// tableId スコープの UseCase プロバイダー。
  TimetableEditUseCaseProvider._(
      {required TimetableEditUseCaseFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'timetableEditUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$timetableEditUseCaseHash();

  @override
  String toString() {
    return r'timetableEditUseCaseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TimetableEditUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimetableEditUseCase create(Ref ref) {
    final argument = this.argument as int;
    return timetableEditUseCase(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimetableEditUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimetableEditUseCase>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TimetableEditUseCaseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$timetableEditUseCaseHash() =>
    r'6ccf1b6c9dc2cea1319d5a54e362f773570abb09';

/// tableId スコープの UseCase プロバイダー。

final class TimetableEditUseCaseFamily extends $Family
    with $FunctionalFamilyOverride<TimetableEditUseCase, int> {
  TimetableEditUseCaseFamily._()
      : super(
          retry: null,
          name: r'timetableEditUseCaseProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// tableId スコープの UseCase プロバイダー。

  TimetableEditUseCaseProvider call(
    int tableId,
  ) =>
      TimetableEditUseCaseProvider._(argument: tableId, from: this);

  @override
  String toString() => r'timetableEditUseCaseProvider';
}
