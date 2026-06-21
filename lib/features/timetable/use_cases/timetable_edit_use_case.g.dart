// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_edit_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// tableId-scoped UseCase provider.

@ProviderFor(timetableEditUseCase)
final timetableEditUseCaseProvider = TimetableEditUseCaseFamily._();

/// tableId-scoped UseCase provider.

final class TimetableEditUseCaseProvider
    extends
        $FunctionalProvider<
          TimetableEditUseCase,
          TimetableEditUseCase,
          TimetableEditUseCase
        >
    with $Provider<TimetableEditUseCase> {
  /// tableId-scoped UseCase provider.
  TimetableEditUseCaseProvider._({
    required TimetableEditUseCaseFamily super.from,
    required int super.argument,
  }) : super(
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
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimetableEditUseCase create(Ref ref) {
    final argument = this.argument as int;
    return timetableEditUseCase(ref, argument);
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

/// tableId-scoped UseCase provider.

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

  /// tableId-scoped UseCase provider.

  TimetableEditUseCaseProvider call(int tableId) =>
      TimetableEditUseCaseProvider._(argument: tableId, from: this);

  @override
  String toString() => r'timetableEditUseCaseProvider';
}
