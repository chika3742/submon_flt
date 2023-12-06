import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:submon/auth/sign_in_handler.dart';
import 'package:submon/models/sign_in_result.dart';
import 'package:submon/utils/ui.dart';

class AccountLinkPage extends StatefulWidget {
  const AccountLinkPage({super.key});

  static const routeName = "/settings/account_link";

  @override
  State<AccountLinkPage> createState() => _AccountLinkPageState();
}

class _AccountLinkPageState extends State<AccountLinkPage> {
  late FirebaseAuth auth;
  bool _notSignedIn = false;
  bool _hasEmailProvider = false;

  final _providers = [
    _Provider(
      name: "Apple",
      providerId: "apple.com",
      iconPath: "assets/vector/apple.svg",
      applyColorFilter: true,
    ),
    _Provider(
      name: "Google",
      providerId: "google.com",
      iconPath: "assets/vector/google.svg",
    ),
  ];

  @override
  void initState() {
    super.initState();

    auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if (user != null) {
      for (final provider in _providers) {
        provider.linked =
            user.providerData.any((e) => e.providerId == provider.providerId);
      }

      _hasEmailProvider = user.providerData
          .any((e) => e.providerId == EmailAuthProvider.PROVIDER_ID);
    } else {
      _notSignedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_notSignedIn) {
      return const Center(
        child: Text("サインインされていません"),
      );
    }

    return ListView(children: [
      ..._providers
          .map((e) => ListTile(
                leading: SvgPicture.asset(
                  e.iconPath,
                  colorFilter: e.applyColorFilter
                      ? ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.light
                              ? const Color(0xFF000000)
                              : const Color(0xFFF9F6EF),
                          BlendMode.srcIn,
                        )
                      : null,
                ),
                title: Text(e.name),
                trailing: _buildLinkButton(e),
              ))
          .toList(),
      if (!_hasEmailProvider)
        const ListTile(
          subtitle: Text("全てのアカウントとの連携を解除するとお試しアカウントになり、"
              "その状態でログアウトすると二度とアカウントにアクセスできなくなります。"),
        )
    ]);
  }

  Widget _buildLinkButton(_Provider provider) {
    if (provider.linked == null || provider.processing) {
      return const CircularProgressIndicator();
    }

    if (provider.linked!) {
      return OutlinedButton(
        onPressed: _providers.none((e) => e.processing)
            ? () {
                showSimpleDialog(
                  context,
                  "連携の解除",
                  "${provider.name}との連携を解除しますか？",
                  showCancel: true,
                  onOKPressed: () {
                    _unlink(provider);
                  },
                );
              }
            : null,
        child: const Text("連携解除"),
      );
    } else {
      return ElevatedButton(
        onPressed: _providers.none((e) => e.processing)
            ? () {
                _link(provider);
              }
            : null,
        child: const Text("連携"),
      );
    }
  }

  Future<void> _link(_Provider provider) async {
    final user = auth.currentUser;
    if (user == null) {
      return;
    }

    setState(() {
      provider.processing = true;
    });

    SignInHandler(SignInMode.upgrade)
        .signIn(provider.providerType)
        .then((value) {
      if (value.errorCode != null) {
        throw value.errorCode!;
      }

      setState(() {
        provider.linked = true;
      });
      showSnackBar(context, "連携しました。");
    }).catchError((e) {
      debugPrint(e.toString());

      if (e is SignInError && e == SignInError.cancelled) {
        return;
      }

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case "credential-already-in-use":
            showSnackBar(context, "この${provider.name}アカウントは既に他のアカウントに連携されています");
            return;
        }
      }

      showSnackBar(context, "連携に失敗しました。(${e.toString()})");
    }).whenComplete(() {
      setState(() {
        provider.processing = false;
      });
    });
  }

  Future<void> _unlink(_Provider provider) async {
    final user = auth.currentUser;
    if (user == null) {
      return;
    }

    setState(() {
      provider.processing = true;
    });

    try {
      await user.unlink(provider.providerId);
      setState(() {
        provider.linked = false;
      });
    } catch (e) {
      showSimpleDialog(context, "エラー", "連携の解除に失敗しました。");
    } finally {
      setState(() {
        provider.processing = false;
      });
    }
  }
}

class _Provider {
  final String name;
  final String providerId;
  final String iconPath;
  final bool applyColorFilter;
  bool? linked;
  bool processing = false;

  _Provider({
    required this.name,
    required this.providerId,
    required this.iconPath,
    this.applyColorFilter = false,
  });

  AuthProvider get providerType {
    switch (providerId) {
      case "apple.com":
        return AuthProvider.apple;
      case "google.com":
        return AuthProvider.google;
      default:
        throw ArgumentError("Invalid providerId: $providerId");
    }
  }
}
