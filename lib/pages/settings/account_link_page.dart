import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../features/auth/models/auth_exception.dart";
import "../../features/auth/presentation/account_link_notifier.dart";
import "../../features/auth/repositories/auth_repository.dart";
import "../../utils/ui.dart";

class AccountLinkPage extends ConsumerWidget {
  const AccountLinkPage({super.key});

  static const routeName = "/settings/account_link";

  static const _providerUiInfo = <AuthProvider, _ProviderUi>{
    AuthProvider.apple: _ProviderUi(
      name: "Apple",
      iconPath: "assets/vector/apple.svg",
      applyColorFilter: true,
    ),
    AuthProvider.google: _ProviderUi(
      name: "Google",
      iconPath: "assets/vector/google.svg",
    ),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkState = ref.watch(accountLinkProvider);
    final providerInfo = ref.watch(linkedProviderInfoProvider);

    ref.listen(accountLinkProvider, (prev, next) {
      switch (next) {
        case AccountLinkLinkSucceeded():
          showSnackBar(context, "連携しました。");
        case AccountLinkUnlinkSucceeded():
          showSnackBar(context, "連携を解除しました。");
        case AccountLinkFailed(:final error):
          final message = error is AuthException
              ? error.code.userFriendlyMessage
              : "エラーが発生しました。";
          showSnackBar(context, message);
        case AccountLinkIdle():
        case AccountLinkProcessing():
        // no action
      }
    });

    return ListView(
      children: [
        for (final provider in AuthProvider.values)
          _buildProviderTile(
            context,
            ref,
            provider: provider,
            isLinked: providerInfo.linkedProviders.contains(provider),
            isProcessing: linkState is AccountLinkProcessing &&
                linkState.processingProvider == provider,
            isDisabled: linkState is AccountLinkProcessing ||
                (providerInfo.linkedProviders.contains(provider) && !_canUnlink(providerInfo)),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "※Apple Accountを非公開メールアドレスで新たに連携する場合、"
                "すでに紐づけられたGoogleアカウントやメールアドレスと紐づけられます。",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (!_canUnlink(providerInfo))
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "外部アカウントを使用して作成されたアカウントのため、最低1つのプロバイダを"
                  "連携させておく必要があります。",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  static bool _canUnlink(LinkedProviderInfo providerInfo) {
    return providerInfo.hasEmailProvider ||
        providerInfo.linkedProviders.length >= 2;
  }

  Widget _buildProviderTile(
    BuildContext context,
    WidgetRef ref, {
    required AuthProvider provider,
    required bool isLinked,
    required bool isProcessing,
    required bool isDisabled,
  }) {
    final ui = _providerUiInfo[provider]!;

    return ListTile(
      leading: SvgPicture.asset(
        ui.iconPath,
        colorFilter: ui.applyColorFilter
            ? ColorFilter.mode(
                Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFF000000)
                    : const Color(0xFFF9F6EF),
                BlendMode.srcIn,
              )
            : null,
      ),
      title: Text(ui.name),
      trailing: isProcessing
          ? const CircularProgressIndicator()
          : isLinked
              ? OutlinedButton(
                  onPressed: isDisabled
                      ? null
                      : () => _confirmUnlink(context, ref, provider, ui.name),
                  child: const Text("連携解除"),
                )
              : ElevatedButton(
                  onPressed: isDisabled
                      ? null
                      : () => ref
                          .read(accountLinkProvider.notifier)
                          .link(provider),
                  child: const Text("連携"),
                ),
    );
  }

  void _confirmUnlink(
    BuildContext context,
    WidgetRef ref,
    AuthProvider provider,
    String providerName,
  ) {
    showSimpleDialog(
      context,
      "連携の解除",
      "$providerNameとの連携を解除しますか？",
      showCancel: true,
      onOKPressed: () {
        ref.read(accountLinkProvider.notifier).unlink(provider);
      },
    );
  }
}

class _ProviderUi {
  final String name;
  final String iconPath;
  final bool applyColorFilter;

  const _ProviderUi({
    required this.name,
    required this.iconPath,
    this.applyColorFilter = false,
  });
}
