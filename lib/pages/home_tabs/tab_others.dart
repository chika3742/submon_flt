import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:submon/components/hidable_progress_indicator.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../browser.dart';

class TabOthers extends StatefulWidget {
  const TabOthers({Key? key}) : super(key: key);

  @override
  TabOthersState createState() => TabOthersState();
}

class TabOthersState extends State<TabOthers> {
  var _loading = false;
  SharedPrefs? prefs;

  @override
  void initState() {
    super.initState();
    SharedPrefs.use((prefs) {
      setState(() {
        this.prefs = prefs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          child: SettingsListView(
            categories: [
              SettingsCategory(title: "Have a nice day", tiles: [
                SettingsTile(
                  title: AppLocalizations.of(context)!.syncNow,
                  enabled: !_loading,
                  leading: const Icon(Icons.sync),
                  onTap: () async {
                    setState(() {
                      _loading = true;
                    });
                    try {
                      await FirestoreProvider.fetchData(
                          context: context, force: true);
                    } on FirebaseException catch (e, stackTrace) {
                      handleFirebaseError(e, stackTrace, context, "同期に失敗しました。");
                    } catch (e, stackTrace) {
                      FirebaseCrashlytics.instance.recordError(e, stackTrace);
                    }
                    setState(() {
                      _loading = false;
                    });
                  },
                ),
                SettingsTile(
                  title: AppLocalizations.of(context)!.doneSubmissions,
                  leading: const Icon(Icons.check),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed("/done");
                  },
                ),
                SettingsTile(
                  title: AppLocalizations.of(context)!.customizeSettings,
                  leading: const Icon(Icons.auto_fix_high),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed("/settings/customize");
                  },
                ),
                SettingsTile(
                  title: AppLocalizations.of(context)!.functionSettings,
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed("/settings/functions");
                  },
                ),
                SettingsTile(
                  title: AppLocalizations.of(context)!.general,
                  leading: const Icon(Icons.info),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed("/settings/general");
                  },
                ),
              ]),
              SettingsCategory(
                title: AppLocalizations.of(context)!.feedbackAndAnnouncements,
                tiles: [
                  if (prefs == null || prefs!.showReviewBtn)
                    SettingsTile(
                      title: AppLocalizations.of(context)!.writeReview,
                      subtitle:
                          AppLocalizations.of(context)!.writeReviewDescription,
                      leading: const Icon(Icons.star),
                      onTap: () {
                        Browser.openStoreListing();
                      },
                    ),
                  SettingsTile(
                    title: AppLocalizations.of(context)!.writeFeedback,
                    subtitle:
                        AppLocalizations.of(context)!.writeFeedbackDescription,
                    leading: const Icon(Icons.rate_review),
                    onTap: () async {
                      var deviceInfoPlugin = DeviceInfoPlugin();
                      var deviceNameAndVer = "";

                      // TODO: macOS / Windows
                      if (Platform.isAndroid) {
                        var info = await deviceInfoPlugin.androidInfo;
                        deviceNameAndVer =
                            "${info.model} / Android ${info.version.release}";
                      } else if (Platform.isIOS) {
                        var info = await deviceInfoPlugin.iosInfo;
                        deviceNameAndVer =
                            "${info.utsname.machine} / iOS ${info.systemVersion}";
                      }

                      var appVer = (await PackageInfo.fromPlatform()).version;

                      var url =
                          "https://docs.google.com/forms/d/e/1FAIpQLSeb0kHMcYWkl8LDpiS6NqoViuU5DHL8FcRRBHyMXXSzhiCx3Q/viewform?usp=pp_url&entry.1179597929=${Uri.encodeQueryComponent(deviceNameAndVer)}&entry.1250051436=${Uri.encodeQueryComponent(appVer)}";
                      print(url);
                      launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    },
                  ),
                  SettingsTile(
                    title:
                        AppLocalizations.of(context)!.announcementsAboutSubmon,
                    subtitle: AppLocalizations.of(context)!
                        .announcementsAboutSubmonDescription,
                    leading: const Icon(Icons.newspaper),
                    onTap: () {
                      Browser.openInfo();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        HidableLinearProgressIndicator(show: _loading)
      ],
    );
  }
}
