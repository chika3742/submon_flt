import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:submon/browser.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/method_channel/main.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({Key? key}) : super(key: key);

  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  String _version = "取得中";
  bool? _analyticsEnabled;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = info.version;
      });
    });
    SharedPrefs.use((prefs) {
      _analyticsEnabled = prefs.isAnalyticsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsListView(
      categories: [
        SettingsCategory(
          title: "このアプリについて",
          tiles: [
            SettingsTile(
              title: "バージョン",
              subtitle: _version,
            ),
            SettingsTile(
              title: "更新履歴・開発進捗",
              onTap: () {
                openChangelog();
              },
            ),
            if (_analyticsEnabled != null)
              SwitchSettingsTile(
                title: "ユーザー使用状況の収集を許可",
                subtitle: "個人が特定できないよう加工された統計情報の収集を許可します。",
                value: _analyticsEnabled!,
                onChanged: (value) {
                  setState(() {
                    _analyticsEnabled = value;
                  });
                  SharedPrefs.use((prefs) {
                    prefs.isAnalyticsEnabled = value;
                  });
                  FirebaseAnalytics.instance
                      .setAnalyticsCollectionEnabled(value);
                },
              ),
            SettingsTile(
              title: "ヘルプ",
              leading: const Icon(Icons.help),
              onTap: () {
                openWebPage("ヘルプ", "https://www.chikach.net/submon-help/");
              },
            ),
          ],
        ),
        SettingsCategory(
          title: "法定情報",
          tiles: [
            SettingsTile(
              title: "利用規約",
              onTap: () {
                openTermsOfUse();
              },
            ),
            SettingsTile(
              title: "プライバシーポリシー",
              onTap: () {
                openPrivacyPolicy();
              },
            ),
            SettingsTile(
              title: "ライセンス",
              onTap: () {
                showLicensePage(
                    context: context,
                    applicationLegalese: "©chika 2021",
                    applicationVersion: _version);
              },
            ),
          ],
        ),
      ],
    );
  }
}
