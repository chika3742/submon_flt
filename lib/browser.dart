import 'dart:io';

import 'package:submon/src/pigeons.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Browser {
  static void openTermsOfUse() {
    BrowserApi()
        .openWebPage("利用規約", "https://www.chikach.net/submon-terms?hideNav=1");
  }

  static void openPrivacyPolicy() {
    BrowserApi().openWebPage(
        "プライバシーポリシー", "https://www.chikach.net/submon-privacy-2?hideNav=1");
  }

  static void openChangelog() {
    BrowserApi()
        .openWebPage("更新履歴", "https://github.com/chika3742/Submon2/releases");
  }

  static void openHelp() {
    BrowserApi().openWebPage("ヘルプ", "https://www.chikach.net/submon-help");
  }

  static void openAnnouncements() {
    BrowserApi()
        .openWebPage("お知らせ", "https://www.chikach.net/category/submon-info");
  }

  static void openStoreListing() {
    if (Platform.isAndroid) {
      launchUrlString(
          "https://play.google.com/store/apps/details?id=net.chikach.submon",
          mode: LaunchMode.externalApplication);
    } else if (Platform.isIOS || Platform.isMacOS) {
      launchUrlString("https://apps.apple.com/jp/app/youtube/id1625033197",
          mode: LaunchMode.externalApplication);
    }
  }
}
