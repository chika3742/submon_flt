import 'package:flutter/services.dart';

const channel = "submon/main";

void openTermsOfUse() {
  _openWebPage("利用規約", "https://www.chikach.net/submon-terms/?nonav=1");
}

void openPrivacyPolicy() {
  _openWebPage("プライバシーポリシー", "https://www.chikach.net/submon-terms/?nonav=1");
}

void openChangelog() {
  _openWebPage("更新履歴・開発進捗", "https://www.chikach.net/submon-changelog/");
}

void _openWebPage(String title, String url) {
  var mc = const MethodChannel(channel);
  mc.invokeMethod("openWebPage", {"title": title, "url": url});
}