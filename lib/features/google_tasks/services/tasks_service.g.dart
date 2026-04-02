// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tasksService)
final tasksServiceProvider = TasksServiceProvider._();

final class TasksServiceProvider
    extends $FunctionalProvider<TasksService?, TasksService?, TasksService?>
    with $Provider<TasksService?> {
  TasksServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksServiceHash();

  @$internal
  @override
  $ProviderElement<TasksService?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TasksService? create(Ref ref) {
    return tasksService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TasksService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TasksService?>(value),
    );
  }
}

String _$tasksServiceHash() => r'21dbb939b487a696650848fc72c527db068b9380';
