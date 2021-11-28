import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:submon/local_db/shared_prefs.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class SettingFunctions extends StatefulWidget {
  const SettingFunctions({Key? key}) : super(key: key);

  @override
  _SettingFunctionsState createState() => _SettingFunctionsState();
}

class _SettingFunctionsState extends State<SettingFunctions> {
  bool _pwEnabled = true;
  bool? _enableSE;

  @override
  void initState() {
    super.initState();
    SharedPrefs.use((prefs) {
      setState(() {
        _enableSE = prefs.enableSE;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    var displayName = auth.currentUser?.displayName;
    return SettingsList(
      contentPadding: !Platform.isIOS && !Platform.isMacOS
          ? const EdgeInsets.only(top: 16)
          : null,
      backgroundColor: Theme.of(context).canvasColor,
      sections: [
        SettingsSection(
          title: "アカウント",
          tiles: [
            SettingsTile(
              title: auth.currentUser != null ? "ログアウト" : "ログイン / 新規登録",
              onPressed: (context) async {
                if (auth.currentUser == null) {
                  await pushPage(context, const SignInPage());
                  setState(() {});
                } else {
                  showSimpleDialog(context, "確認", "ログアウトしますか？",
                      onOKPressed: () async {
                    await auth.signOut();
                    setState(() {});
                    showSnackBar(context, "ログアウトしました");
                  }, showCancel: true);
                }
              },
            ),
            if (auth.currentUser != null)
              SettingsTile(
                title: emailChangeable() ? "メールアドレスの変更" : "メールアドレス",
                subtitle: auth.currentUser!.email,
                onPressed: emailChangeable()
                    ? (context) async {
                        await Navigator.pushNamed(
                            context, "/account/changeEmail");
                        setState(() {});
                      }
                    : null,
              ),
            if (auth.currentUser != null && passwordChangeable() && _pwEnabled)
              SettingsTile(
                title: "パスワードの変更",
                onPressed: (context) {
                  _changePassword();
                },
              ),
            if (auth.currentUser != null)
              SettingsTile(
                title: "ユーザー名の変更",
                subtitle: displayName != null && displayName.isNotEmpty
                    ? displayName
                    : "未設定",
                onPressed: (context) async {
                  await Navigator.pushNamed(
                      context, "/account/changeDisplayName");
                  setState(() {});
                },
              ),
            if (auth.currentUser != null)
              SettingsTile(
                title: "アカウントの削除",
                titleTextStyle: const TextStyle(color: Colors.red),
                onPressed: (context) async {
                  await Navigator.pushNamed(context, "/account/delete");
                  setState(() {});
                },
              ),
          ],
        ),
        SettingsSection(
          title: "その他の機能",
          titlePadding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
          tiles: [
            if (_enableSE != null)
              SettingsTile.switchTile(
                title: "SEを有効にする",
                subtitle: "一部操作時にサウンドを再生します",
                switchValue: _enableSE,
                onToggle: (value) {
                  SharedPrefs.use((prefs) {
                    prefs.enableSE = value;
                  });
                  setState(() {
                    _enableSE = value;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  void _changePassword() async {
    var auth = FirebaseAuth.instance;
    showLoadingModal(context);
    try {
      var provider =
          await auth.fetchSignInMethodsForEmail(auth.currentUser!.email!);
      if (provider.isEmpty) throw FirebaseAuthException(code: "user-not-found");
      Navigator.pop(context);
      if (provider.first == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD) {
        await Navigator.pushNamed(context, "/account/changePassword");
        setState(() {});
      } else {
        setState(() {
          _pwEnabled = false;
        });
        showSnackBar(context, "パスワードレス アカウントでパスワードの変更はできません");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == "user-not-found") {
        showSnackBar(context, "ユーザーが見つかりません。再度ログインしてください。");
      } else {
        showSnackBar(context, "アカウント状態の取得に失敗しました (Code: ${e.code})");
      }
    } catch (e) {
      showSnackBar(context, "エラーが発生しました");
    }
  }

  bool emailChangeable() {
    var providers = [
      EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD,
      EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD
    ];
    var providerId =
        FirebaseAuth.instance.currentUser?.providerData.first.providerId;
    return providers.contains(providerId);
  }

  bool passwordChangeable() {
    return FirebaseAuth.instance.currentUser?.providerData.first.providerId ==
        EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD;
  }
}
