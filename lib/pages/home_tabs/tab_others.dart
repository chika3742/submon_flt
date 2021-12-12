import 'package:flutter/material.dart';
import 'package:submon/components/settings_ui.dart';

class TabOthers extends StatefulWidget {
  const TabOthers({Key? key}) : super(key: key);

  @override
  _TabOthersState createState() => _TabOthersState();
}

class _TabOthersState extends State<TabOthers> {
  @override
  Widget build(BuildContext context) {
    return SettingsListView(
      categories: [
        SettingsCategory(title: "Have a nice day", tiles: [
          SettingsTile(
            title: "完了済みの提出物",
            leading: const Icon(Icons.check),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed("/done");
            },
          ),
          SettingsTile(
            title: "カスタマイズ設定",
            leading: const Icon(Icons.auto_fix_high),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed("/settings/customize");
            },
          ),
          SettingsTile(
            title: "機能設定",
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed("/settings/functions");
            },
          ),
          SettingsTile(
            title: "全般",
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed("/settings/general");
            },
          ),
        ]),
      ],
    );
  }
}
