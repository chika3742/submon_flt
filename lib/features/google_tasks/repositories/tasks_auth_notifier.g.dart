// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TasksAuthNotifier)
final tasksAuthProvider = TasksAuthNotifierProvider._();

final class TasksAuthNotifierProvider
    extends $AsyncNotifierProvider<TasksAuthNotifier, AuthClient?> {
  TasksAuthNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tasksAuthProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tasksAuthNotifierHash();

  @$internal
  @override
  TasksAuthNotifier create() => TasksAuthNotifier();
}

String _$tasksAuthNotifierHash() => r'03a76c33abedfdf87eeb2c1d699646df76b6fec2';

abstract class _$TasksAuthNotifier extends $AsyncNotifier<AuthClient?> {
  FutureOr<AuthClient?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthClient?>, AuthClient?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AuthClient?>, AuthClient?>,
        AsyncValue<AuthClient?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
