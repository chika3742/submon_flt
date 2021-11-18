import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/utils.dart';

class SettingFunctions extends StatefulWidget {
  const SettingFunctions({Key? key}) : super(key: key);

  @override
  _SettingFunctionsState createState() => _SettingFunctionsState();
}

class _SettingFunctionsState extends State<SettingFunctions> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      contentPadding: !Platform.isIOS && !Platform.isMacOS ? const EdgeInsets.only(top: 16) : null,
      backgroundColor: Theme.of(context).canvasColor,
      sections: [
        SettingsSection(
          title: "アカウント",
          tiles: [
            SettingsTile(
              title: FirebaseAuth.instance.currentUser != null ? "ログアウト" : "ログイン / 新規登録",
              subtitle: FirebaseAuth.instance.currentUser?.displayName,
              onPressed: (context) {
                pushPage(context, const SignInPage());
              },
            )
          ],
        )
      ],
    );
  }
}
