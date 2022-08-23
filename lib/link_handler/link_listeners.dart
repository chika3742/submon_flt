import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:submon/link_handler/opener_link_helper.dart';

import '../method_channel/channels.dart';
import '../method_channel/main.dart';
import '../utils/dynamic_links.dart';
import 'auth_link_helper.dart';

class LinkListeners {
  StreamSubscription? _dynamicLinksListener;
  StreamSubscription? _uriListener;

  void initialize() {
    _initDynamicLinksListener();
    _initUriHandler();
  }

  void cancel() {
    _dynamicLinksListener?.cancel();
    _uriListener?.cancel();
  }

  void _initDynamicLinksListener() {
    FirebaseDynamicLinks.instance.getInitialLink().then((linkData) {
      if (linkData != null) {
        _handleLink(linkData.link);
      }
    });
    _dynamicLinksListener =
        FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
      _handleLink(linkData.link);
    });
  }

  void _initUriHandler() {
    MainMethodPlugin.getPendingUri().then((uriString) {
      if (uriString != null) {
        _handleLink(Uri.parse(uriString));
      }
    });
    _uriListener = const EventChannel(EventChannels.uri)
        .receiveBroadcastStream()
        .listen((uriString) {
      _handleLink(Uri.parse(uriString));
    });
  }

  void _handleLink(Uri url) {
    try {
      if (url.host == getAppDomain("") || url.scheme == "submon") {
        if (url.path == "/__/auth/action") {
          AuthLinkHelper.handle(url);
        } else {
          OpenerLinkHelper.handle(url);
        }
      }
    } on RangeError catch (e, stack) {
      debugPrint("Malformed URL or the URL should not be handled here");
      debugPrintStack(stackTrace: stack);
    }
  }
}
