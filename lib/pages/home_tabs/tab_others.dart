import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/hidable_progress_indicator.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/firestore.dart';
import 'package:submon/utils/ui.dart';

class TabOthers extends StatefulWidget {
  const TabOthers({Key? key}) : super(key: key);

  @override
  _TabOthersState createState() => _TabOthersState();
}

class _TabOthersState extends State<TabOthers> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SettingsListView(
          categories: [
            SettingsCategory(title: "Have a nice day", tiles: [
              SettingsTile(
                title: "今すぐ同期",
                enabled: !_loading,
                leading: const Icon(Icons.sync),
                onTap: () async {
                  setState(() {
                    _loading = true;
                  });
                  try {
                    await FirestoreProvider.fetchData(force: true);
                  } on Error catch (e) {
                    showSnackBar(context, "エラーが発生しました");
                    FirebaseCrashlytics.instance.recordError(e, e.stackTrace);
                  }
                  setState(() {
                    _loading = false;
                  });
                },
              ),
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
        ),
        HidableLinearProgressIndicator(show: _loading)
      ],
    );
  }
}
