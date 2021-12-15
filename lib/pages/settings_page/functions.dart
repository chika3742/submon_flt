
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class FunctionsSettingsPage extends StatefulWidget {
  const FunctionsSettingsPage({Key? key}) : super(key: key);

  @override
  _FunctionsSettingsPageState createState() => _FunctionsSettingsPageState();
}

class _FunctionsSettingsPageState extends State<FunctionsSettingsPage> {
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
    return SettingsListView(
      categories: [
        SettingsCategory(title: "アカウント", tiles: [
          SettingsTile(
            title: auth.currentUser != null ? "ログアウト" : "ログイン / 新規登録",
            onTap: () async {
              if (auth.currentUser == null) {
                await pushPage(context, const SignInPage());
                setState(() {});
              } else {
                showSimpleDialog(context, "確認", "ログアウトしますか？",
                    onOKPressed: () async {
                  await auth.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "welcome");
                  showSnackBar(context, "ログアウトしました");
                }, showCancel: true);
              }
            },
          ),
          if (auth.currentUser != null)
            SettingsTile(
              title: emailChangeable() ? "メールアドレスの変更" : "メールアドレス",
              subtitle: auth.currentUser!.email,
              onTap: emailChangeable()
                  ? () async {
                      await Navigator.pushNamed(
                          context, "/account/changeEmail");
                      setState(() {});
                    }
                  : null,
            ),
          if (auth.currentUser != null && passwordChangeable() && _pwEnabled)
            SettingsTile(
              title: "パスワードの変更",
              onTap: () {
                _changePassword();
              },
            ),
          if (auth.currentUser != null)
            SettingsTile(
              title: "ユーザー名の変更",
              subtitle: displayName != null && displayName.isNotEmpty
                  ? displayName
                  : "未設定",
              onTap: () async {
                await Navigator.pushNamed(
                    context, "/account/changeDisplayName");
                setState(() {});
              },
            ),
          if (auth.currentUser != null)
            SettingsTile(
              title: "アカウントの削除",
              titleTextStyle: const TextStyle(color: Colors.red),
              onTap: () async {
                await Navigator.pushNamed(context, "/account/delete");
                setState(() {});
              },
            ),
        ]),
        SettingsCategory(title: "その他の機能", tiles: [
          if (_enableSE != null)
            SwitchSettingsTile(
              title: "SEを有効にする",
              subtitle: "一部操作時にサウンドを再生します",
              value: _enableSE!,
              onChanged: (value) {
                SharedPrefs.use((prefs) {
                  prefs.enableSE = value;
                });
                setState(() {
                  _enableSE = value;
                });
              },
            ),
          SettingsTile(
            title: "時間割表設定",
            onTap: () {
              Navigator.pushNamed(context, "/settings/timetable");
            },
          )
        ])
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
