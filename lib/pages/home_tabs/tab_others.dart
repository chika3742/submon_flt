import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.check),
          title: const Text("完了済みの提出物"),
          onTap: () { _pushPage(const DoneSubmissionsPage()); },
        ),
        ListTile(
          leading: const Icon(Icons.auto_fix_high),
          title: const Text("カスタマイズ設定"),
          onTap: () { _pushPage(const SettingsPage("カスタマイズ設定", page: SettingCustomize())); },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("機能設定"),
          onTap: () { _pushPage(const SettingsPage("機能設定", page: SettingFunctions())); },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text("全般"),
          onTap: () { _pushPage(const SettingsPage("全般", page: SettingGeneral())); },
        ),

      ],
    );
  }

  void _pushPage(Widget page) {
    pushPage(context, page);
  }
}
