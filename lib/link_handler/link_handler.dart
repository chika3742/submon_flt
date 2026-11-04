import 'package:flutter/material.dart';
import 'package:submon/link_handler/open_link_handler.dart';

import '../utils/app_links.dart';
import 'auth_link_handler.dart';

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
      } else if (url.host == openAppDomain) {
        if (url.queryParameters.containsKey("link")) {
          handleLink(Uri.parse(url.queryParameters["link"]!));
        }
      }
    } on RangeError catch (e, stack) {
      debugPrint("Malformed URL or the URL should not be handled here");
      debugPrintStack(stackTrace: stack);
    }
  }
}
