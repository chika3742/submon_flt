import 'dart:io';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:submon/pages/done_submissions_page.dart';
import 'package:submon/pages/settings_page.dart';
import 'package:submon/pages/settings_page/customize.dart';
import 'package:submon/pages/settings_page/functions.dart';
import 'package:submon/pages/settings_page/general.dart';

import '../../utils.dart';

class TabOthers extends StatefulWidget {
  const TabOthers({Key? key}) : super(key: key);

  @override
  _TabOthersState createState() => _TabOthersState();
}

class _TabOthersState extends State<TabOthers> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      contentPadding: !Platform.isIOS && !Platform.isMacOS ? const EdgeInsets.only(top: 16) : null,
      backgroundColor: Theme.of(context).canvasColor,
      sections: [
        SettingsSection(
          title: "Have a nice day",
          tiles: [
            SettingsTile(
              title: "完了済みの提出物",
              leading: const Icon(Icons.check),
              onPressed: (context) { _pushPage(const DoneSubmissionsPage()); },
            ),
            SettingsTile(
              title: "カスタマイズ設定",
              leading: const Icon(Icons.auto_fix_high),
              onPressed: (context) { _pushPage(const SettingsPage("カスタマイズ設定", page: SettingCustomize())); },
            ),
            SettingsTile(
              title: "機能設定",
              leading: const Icon(Icons.settings),
              onPressed: (context) { _pushPage(const SettingsPage("機能設定", page: SettingFunctions())); },
            ),
            SettingsTile(
              title: "全般",
              leading: const Icon(Icons.info),
              onPressed: (context) { _pushPage(const SettingsPage("全般", page: SettingGeneral())); },
            ),
          ],
        )
      ],
    );
  }

  void _pushPage(Widget page) {
    pushPage(context, page);
  }
}
