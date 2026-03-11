import "package:flutter/material.dart";

import "../utils/app_links.dart";
import "auth_link_handler.dart";
import "open_link_handler.dart";

class LinkHandler {
  LinkHandler._();

  static void handleLink(Uri url) {
    try {
      if (url.host == appDomain || url.scheme == "submon") {
        if (url.path == "/__/auth/action") {
          AuthLinkHandler.handle(url);
        } else if (url.path == "/__/auth/links") {
          AuthLinkHandler.handle(Uri.parse(url.queryParameters["link"]!));
        } else {
          OpenLinkHandler.handle(url);
        }
      }
    } on RangeError catch (_, stack) {
      debugPrint("Malformed URL or the URL should not be handled here");
      debugPrintStack(stackTrace: stack);
    }
  }
}
