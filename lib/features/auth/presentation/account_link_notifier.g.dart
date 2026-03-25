// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_link_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(linkedProviderInfo)
final linkedProviderInfoProvider = LinkedProviderInfoProvider._();

final class LinkedProviderInfoProvider extends $FunctionalProvider<
    LinkedProviderInfo,
    LinkedProviderInfo,
    LinkedProviderInfo> with $Provider<LinkedProviderInfo> {
  LinkedProviderInfoProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'linkedProviderInfoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$linkedProviderInfoHash();

  @$internal
  @override
  $ProviderElement<LinkedProviderInfo> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkedProviderInfo create(Ref ref) {
    return linkedProviderInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkedProviderInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkedProviderInfo>(value),
    );
  }
}

String _$linkedProviderInfoHash() =>
    r'1ca71ab341ef9bab26caf3b5bc30bbfc3214977e';

@ProviderFor(AccountLinkNotifier)
final accountLinkProvider = AccountLinkNotifierProvider._();

final class AccountLinkNotifierProvider
    extends $NotifierProvider<AccountLinkNotifier, AccountLinkState> {
  AccountLinkNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'accountLinkProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$accountLinkNotifierHash();

  @$internal
  @override
  AccountLinkNotifier create() => AccountLinkNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountLinkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountLinkState>(value),
    );
  }
}

String _$accountLinkNotifierHash() =>
    r'3c072bbe16f0d7f8fbc12bdb73f06baed1285c3b';

abstract class _$AccountLinkNotifier extends $Notifier<AccountLinkState> {
  AccountLinkState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AccountLinkState, AccountLinkState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AccountLinkState, AccountLinkState>,
        AccountLinkState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
