import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../providers/core_providers.dart";
import "../../../utils/notifier_state_guard.dart";
import "../repositories/auth_repository.dart";
import "../use_cases/auth_ui_use_case.dart";
import "../use_cases/common.dart";

part "account_link_notifier.freezed.dart";
part "account_link_notifier.g.dart";

@freezed
sealed class LinkedProviderInfo with _$LinkedProviderInfo {
  const factory LinkedProviderInfo({
    required Set<AuthProvider> linkedProviders,
    required bool hasEmailProvider,
  }) = _LinkedProviderInfo;
}

@riverpod
LinkedProviderInfo linkedProviderInfo(Ref ref) {
  final user = ref.watch(firebaseUserProvider).value;
  if (user == null) {
    return const LinkedProviderInfo(
      linkedProviders: {},
      hasEmailProvider: false,
    );
  }
  return LinkedProviderInfo(
    linkedProviders: {
      for (final p in AuthProvider.values)
        if (user.providerData.any((d) => d.providerId == p.providerId)) p,
    },
    hasEmailProvider: user.providerData
        .any((e) => e.providerId == EmailAuthProvider.PROVIDER_ID),
  );
}

@freezed
sealed class AccountLinkState with _$AccountLinkState {
  const factory AccountLinkState.idle() = AccountLinkIdle;

  const factory AccountLinkState.processing({
    required AuthProvider processingProvider,
  }) = AccountLinkProcessing;

  const factory AccountLinkState.linkSucceeded() = AccountLinkLinkSucceeded;

  const factory AccountLinkState.unlinkSucceeded() =
      AccountLinkUnlinkSucceeded;

  const factory AccountLinkState.failed(Object error) = AccountLinkFailed;
}

@riverpod
class AccountLinkNotifier extends _$AccountLinkNotifier
    with NotifierStateGuard {
  @override
  AccountLinkState build() => const AccountLinkState.idle();

  @override
  @protected
  AccountLinkState getErrorState(Object error, StackTrace st) {
    ref.read(crashlyticsProvider).recordError(error, st);
    return AccountLinkState.failed(error);
  }

  Future<void> link(AuthProvider provider) {
    return guard(
      AccountLinkState.processing(processingProvider: provider),
      () async {
        final result = await ref
            .read(authUiUseCaseProvider)
            .execute(provider, AuthMode.upgrade);
        if (!result) {
          return const AccountLinkState.idle();
        }
        ref.invalidate(firebaseUserProvider);
        return const AccountLinkState.linkSucceeded();
      },
    );
  }

  Future<void> unlink(AuthProvider provider) {
    return guard(
      AccountLinkState.processing(processingProvider: provider),
      () async {
        await ref.read(authRepositoryProvider).unlinkProvider(provider);
        ref.invalidate(firebaseUserProvider);
        return const AccountLinkState.unlinkSucceeded();
      },
    );
  }
}
