// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Firestore → Isar のデータ同期を行うサービス。Stateは同期状態を表す。
///
/// 旧 `FirestoreProvider.fetchData` / `checkMigration` / `_migrate` を置き換える。

@ProviderFor(DataSyncService)
final dataSyncServiceProvider = DataSyncServiceProvider._();

/// Firestore → Isar のデータ同期を行うサービス。Stateは同期状態を表す。
///
/// 旧 `FirestoreProvider.fetchData` / `checkMigration` / `_migrate` を置き換える。
final class DataSyncServiceProvider
    extends $AsyncNotifierProvider<DataSyncService, void> {
  /// Firestore → Isar のデータ同期を行うサービス。Stateは同期状態を表す。
  ///
  /// 旧 `FirestoreProvider.fetchData` / `checkMigration` / `_migrate` を置き換える。
  DataSyncServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dataSyncServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dataSyncServiceHash();

  @$internal
  @override
  DataSyncService create() => DataSyncService();
}

String _$dataSyncServiceHash() => r'b4250a0fc61f8edd659a27e96722051916effabf';

/// Firestore → Isar のデータ同期を行うサービス。Stateは同期状態を表す。
///
/// 旧 `FirestoreProvider.fetchData` / `checkMigration` / `_migrate` を置き換える。

abstract class _$DataSyncService extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
