import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:submon/browser.dart';

class SettingGeneral extends StatefulWidget {
  const SettingGeneral({Key? key}) : super(key: key);

  @override
  _SettingGeneralState createState() => _SettingGeneralState();
}

class _SettingGeneralState extends State<SettingGeneral> {
  String _version = "取得中";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = info.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      contentPadding: !Platform.isIOS && !Platform.isMacOS ? const EdgeInsets.only(top: 16) : null,
      backgroundColor: Theme.of(context).canvasColor,
      sections: [
        SettingsSection(
          title: "このアプリについて",
          tiles: [
            SettingsTile(
              title: "バージョン",
              subtitle: _version,
            ),
            SettingsTile(
              title: "更新履歴・開発進捗",
              onPressed: (context) {
                openChangelog();
              },
            ),
            SettingsTile.switchTile(
              title: "ユーザー使用状況の収集を許可",
              switchValue: false,
              onToggle: (value) {

              },
            ),
          ],
        ),
        SettingsSection(
          title: "法定情報",
          titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
          tiles: [
            SettingsTile(
              title: "利用規約",
              onPressed: (context) {
                openTermsOfUse();
              },
            ),
            SettingsTile(
              title: "プライバシーポリシー",
              onPressed: (context) {
                openPrivacyPolicy();
              },
            ),
            SettingsTile(
              title: "ライセンス",
              onPressed: (context) {
                showLicensePage(context: context, applicationLegalese: "©chika 2021", applicationVersion: _version);
              },
            ),
          ],
        ),
      ],
    );
  }
}
