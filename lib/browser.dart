import 'package:flutter/services.dart';

const channel = "submon/main";

void openTermsOfUse() {
  _openWebPage("利用規約", "https://www.chikach.net/nonav/submon-terms/");
}

void openPrivacyPolicy() {
  _openWebPage("プライバシーポリシー", "https://www.chikach.net/nonav/submon-privacy/");
}

void openChangelog() {
  _openWebPage("更新履歴・開発進捗", "https://www.chikach.net/submon-changelog/");
}

void _openWebPage(String title, String url) {
  var mc = const MethodChannel(channel);
  mc.invokeMethod("openWebPage", {"title": title, "url": url});
}

Future<String?> openCustomTabs(String url) async {
  var mc = const MethodChannel(channel);
  return await mc.invokeMethod<String>("openCustomTabs", {"url": url});
}
