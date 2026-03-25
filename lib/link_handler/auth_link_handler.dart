import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

void handleAuthLink(BuildContext context, Uri url) {
  switch (url.queryParameters["mode"]) {
    case "signIn":
    case "verifyAndChangeEmail":
      break;
    case "resetPassword":
      launchUrl(url, mode: LaunchMode.externalApplication);
    default:
      break;
  }
}
