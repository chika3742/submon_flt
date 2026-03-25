import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../utils/app_links.dart";
import "open_link_handler.dart";

void handleLink(
  BuildContext context,
  WidgetRef ref,
  Uri url, {
  required void Function(String tabName) onSwitchTab,
}) {
  final resolvedUrl = resolveAppLink(url);
  if (resolvedUrl == null) return;

  if (resolvedUrl.path != "/__/auth/action") {
    handleOpenLink(context, ref, resolvedUrl, onSwitchTab: onSwitchTab);
  }
}
