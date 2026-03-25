import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../utils/app_links.dart";
import "auth_link_handler.dart";
import "open_link_handler.dart";

void handleLink(
  BuildContext context,
  WidgetRef ref,
  Uri url, {
  required void Function(String tabName) onSwitchTab,
}) {
  try {
    if (url.host == appDomain || url.scheme == "submon") {
      if (url.path == "/__/auth/action") {
        handleAuthLink(context, url);
      } else if (url.path == "/__/auth/links") {
        handleAuthLink(
          context,
          Uri.parse(url.queryParameters["link"]!),
        );
      } else {
        handleOpenLink(context, ref, url, onSwitchTab: onSwitchTab);
      }
    }
  } on RangeError catch (_, stack) {
    debugPrint("Malformed URL or the URL should not be handled here");
    debugPrintStack(stackTrace: stack);
  }
}
