// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'undo_redo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Per-tableId Undo/Redo stack.

@ProviderFor(UndoRedo)
final undoRedoProvider = UndoRedoFamily._();

/// Per-tableId Undo/Redo stack.
final class UndoRedoProvider
    extends
        $NotifierProvider<
          UndoRedo,
          ({
            List<TimetableSnapshot> redoStack,
            List<TimetableSnapshot> undoStack,
          })
        > {
  /// Per-tableId Undo/Redo stack.
  UndoRedoProvider._({
    required UndoRedoFamily super.from,
    required int super.argument,
  }) : super(
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
    ({List<TimetableSnapshot> redoStack, List<TimetableSnapshot> undoStack})
    value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ({
              List<TimetableSnapshot> redoStack,
              List<TimetableSnapshot> undoStack,
            })
          >(value),
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

String _$undoRedoHash() => r'f49f1f45ec946abcf2766b49236131b91c1adf0a';

/// Per-tableId Undo/Redo stack.

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
          int
        > {
  UndoRedoFamily._()
    : super(
        retry: null,
        name: r'undoRedoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Per-tableId Undo/Redo stack.

  UndoRedoProvider call(int tableId) =>
      UndoRedoProvider._(argument: tableId, from: this);

  @override
  String toString() => r'undoRedoProvider';
}

/// Per-tableId Undo/Redo stack.

abstract class _$UndoRedo
    extends
        $Notifier<
          ({
            List<TimetableSnapshot> redoStack,
            List<TimetableSnapshot> undoStack,
          })
        > {
  late final _$args = ref.$arg as int;
  int get tableId => _$args;

  ({List<TimetableSnapshot> redoStack, List<TimetableSnapshot> undoStack})
  build(int tableId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              ({
                List<TimetableSnapshot> redoStack,
                List<TimetableSnapshot> undoStack,
              }),
              ({
                List<TimetableSnapshot> redoStack,
                List<TimetableSnapshot> undoStack,
              })
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({
                  List<TimetableSnapshot> redoStack,
                  List<TimetableSnapshot> undoStack,
                }),
                ({
                  List<TimetableSnapshot> redoStack,
                  List<TimetableSnapshot> undoStack,
                })
              >,
              ({
                List<TimetableSnapshot> redoStack,
                List<TimetableSnapshot> undoStack,
              }),
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
