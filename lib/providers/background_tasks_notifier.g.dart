// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_tasks_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// バックグラウンドタスクの実行とエラー報告を統合する Notifier。
///
/// state は `Object?` で、`null` はエラーなし、非 null はエラーイベントを表す。
/// [CrashlyticsObserver] は [ErrorState] 経由で自動検出する。

@ProviderFor(BackgroundTasks)
final backgroundTasksProvider = BackgroundTasksProvider._();

/// バックグラウンドタスクの実行とエラー報告を統合する Notifier。
///
/// state は `Object?` で、`null` はエラーなし、非 null はエラーイベントを表す。
/// [CrashlyticsObserver] は [ErrorState] 経由で自動検出する。
final class BackgroundTasksProvider
    extends $NotifierProvider<BackgroundTasks, Object?> {
  /// バックグラウンドタスクの実行とエラー報告を統合する Notifier。
  ///
  /// state は `Object?` で、`null` はエラーなし、非 null はエラーイベントを表す。
  /// [CrashlyticsObserver] は [ErrorState] 経由で自動検出する。
  BackgroundTasksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'backgroundTasksProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$backgroundTasksHash();

  @$internal
  @override
  BackgroundTasks create() => BackgroundTasks();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Object? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Object?>(value),
    );
  }
}

String _$backgroundTasksHash() => r'ea82e0550ac3ad5111fe38214ee8d92e74e934a5';

/// バックグラウンドタスクの実行とエラー報告を統合する Notifier。
///
/// state は `Object?` で、`null` はエラーなし、非 null はエラーイベントを表す。
/// [CrashlyticsObserver] は [ErrorState] 経由で自動検出する。

abstract class _$BackgroundTasks extends $Notifier<Object?> {
  Object? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Object?, Object?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Object?, Object?>, Object?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
