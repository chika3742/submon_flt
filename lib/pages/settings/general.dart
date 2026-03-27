import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";

import "../../browser.dart";
import "../../core/pref_key.dart";
import "../../providers/firebase_providers.dart";
import "../../ui_components/settings_ui.dart";

class GeneralSettingsPage extends ConsumerStatefulWidget {
  const GeneralSettingsPage({super.key});

  static const routeName = "/settings/general";

  @override
  ConsumerState<GeneralSettingsPage> createState() =>
      _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends ConsumerState<GeneralSettingsPage> {
  String _version = "取得中";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      setState(() {
        _version = "${info.version} (build ${info.buildNumber})";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyticsEnabled = ref.watchPref(PrefKey.isAnalyticsEnabled);

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
              title: "更新履歴",
              onTap: () {
                Browser.openChangelog();
              },
            ),
            SwitchSettingsTile(
              title: "ユーザー使用状況の収集を許可",
              subtitle: "個人が特定できないよう加工された統計情報の収集を許可します。",
              value: analyticsEnabled,
              onChanged: (value) {
                ref.updatePref(PrefKey.isAnalyticsEnabled, value);
                ref
                    .read(analyticsProvider)
                    .setAnalyticsCollectionEnabled(value);
              },
            ),
            SettingsTile(
              title: "Q&A (よくあると思う質問)",
              subtitle: "他にも質問があれば、リンク先ページにコメントしていただければ回答追記するかも",
              leading: const Icon(Icons.help),
              onTap: () {
                Browser.openHelp();
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
                Browser.openTermsOfUse();
              },
            ),
            SettingsTile(
              title: "プライバシーポリシー",
              onTap: () {
                Browser.openPrivacyPolicy();
              },
            ),
            SettingsTile(
              title: "ライセンス",
              onTap: () {
                showLicensePage(
                    context: context,
                    applicationLegalese: "©chika 2023",
                    applicationVersion: _version);
              },
            ),
          ],
        ),
      ],
    );
  }
}
