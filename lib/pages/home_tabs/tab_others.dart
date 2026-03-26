import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:url_launcher/url_launcher_string.dart";

import "../../browser.dart";
import "../../core/pref_key.dart";
import "../../providers/data_sync_service.dart";
import "../../ui_components/hidable_progress_indicator.dart";
import "../../ui_components/settings_ui.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";
import "../done_submissions_page.dart";
import "../settings/customize.dart";
import "../settings/functions.dart";
import "../settings/general.dart";

class TabOthers extends ConsumerWidget {
  const TabOthers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(dataSyncServiceProvider).isLoading;
    final showReviewBtn = ref.watchPref(PrefKey.showReviewBtn);

    return Stack(
      children: [
        Material(
          child: SettingsListView(
            categories: [
              SettingsCategory(title: "Have a nice day", tiles: [
                SettingsTile(
                  title: "今すぐ同期",
                  enabled: !isLoading,
                  leading: const Icon(Icons.sync),
                  onTap: () {
                    ref.read(dataSyncServiceProvider.notifier)
                        .fetchData(force: true);
                  },
                ),
                SettingsTile(
                  title: "完了済みの提出物",
                  leading: const Icon(Icons.check),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(DoneSubmissionsPage.routeName);
                  },
                ),
                SettingsTile(
                  title: "カスタマイズ設定",
                  leading: const Icon(Icons.auto_fix_high),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(CustomizeSettingsPage.routeName);
                  },
                ),
                SettingsTile(
                  title: "機能設定",
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(FunctionsSettingsPage.routeName);
                  },
                ),
                SettingsTile(
                  title: "全般",
                  leading: const Icon(Icons.info),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed(GeneralSettingsPage.routeName);
                  },
                ),
              ]),
              SettingsCategory(
                title: "フィードバック・お知らせ",
                tiles: [
                  if (showReviewBtn)
                    SettingsTile(
                      title: "レビューを書く",
                      subtitle: "全体的なアプリ評価はこちら。",
                      leading: const Icon(Icons.star),
                      onTap: () {
                        Browser.openStoreListing();
                      },
                    ),
                  SettingsTile(
                    title: "フィードバックを書く",
                    subtitle: "不具合報告や細かな改善要望はこちら。",
                    leading: const Icon(Icons.rate_review),
                    onTap: () async {
                      final deviceInfoPlugin = DeviceInfoPlugin();
                      var deviceNameAndVer = "";

                      // TODO: macOS / Windows
                      if (Platform.isAndroid) {
                        final info = await deviceInfoPlugin.androidInfo;
                        deviceNameAndVer =
                            "${info.model} / Android ${info.version.release}";
                      } else if (Platform.isIOS) {
                        final info = await deviceInfoPlugin.iosInfo;
                        deviceNameAndVer =
                            "${info.utsname.machine} / iOS ${info.systemVersion}";
                      }

                      final appVer = (await PackageInfo.fromPlatform()).version;

                      final url =
                          "https://docs.google.com/forms/d/e/1FAIpQLSeb0kHMcYWkl8LDpiS6NqoViuU5DHL8FcRRBHyMXXSzhiCx3Q/viewform?usp=pp_url&entry.1179597929=${Uri.encodeQueryComponent(deviceNameAndVer)}&entry.1250051436=${Uri.encodeQueryComponent(appVer)}";
                      launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                  SettingsTile(
                    title: "Submonに関するお知らせ",
                    subtitle: "サービスに関するお知らせを掲載しています。",
                    leading: const Icon(Icons.newspaper),
                    onTap: () {
                      Browser.openAnnouncements();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        // HidableLinearProgressIndicator(show: isLoading),
      ],
    );
  }
}
