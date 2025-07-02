import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:submon/link_handler/open_link_handler.dart';

import '../utils/app_links.dart';
import 'auth_link_handler.dart';

// ignore_for_file: deprecated_member_use

class LinkHandler {
  LinkHandler._();

  static var dynamicLinksListenerInitialized = false;

  static void initDynamicLinksListener() {
    if (!dynamicLinksListenerInitialized) {
      // get initial link
      FirebaseDynamicLinks.instance.getInitialLink().then((linkData) {
        if (linkData != null) {
          handleLink(linkData.link);
        }
      });
      // register listener
      FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
        handleLink(linkData.link);
      });
      dynamicLinksListenerInitialized = true;
    }
  }

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
        } else {
          FirebaseDynamicLinks.instance.getDynamicLink(url).then((value) {
            if (value != null) {
              handleLink(value.link);
            }
          }).catchError((e, stack) {
            FirebaseCrashlytics.instance.recordError(e, stack);
          });
        }
      }
    } on RangeError catch (e, stack) {
      debugPrint("Malformed URL or the URL should not be handled here");
      debugPrintStack(stackTrace: stack);
    }
  }
}
