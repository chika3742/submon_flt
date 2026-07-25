import "package:collection/collection.dart";

import "../../../shared/domain/app_host.dart";
import "../../domain/models/auth_mode.dart";

class EmailLinkAuthContinueUriConverter {
  const EmailLinkAuthContinueUriConverter();

  static const _callbackPath = "/email-auth-callback";

  static bool isEmailLinkAuthContinueUrl(Uri uri) {
    return uri.isScheme("https")
        && uri.host == appHost
        && uri.path == _callbackPath;
  }

  Uri toUri(AuthMode mode, [String? destinationAfterReAuth]) {
    return Uri.https(appHost, _callbackPath, {
      "mode": mode.name,
      "destinationAfterReAuth": destinationAfterReAuth,
    });
  }

  ({AuthMode mode, String? destinationAfterReAuth})? fromUri(Uri uri) {
    if (!isEmailLinkAuthContinueUrl(uri)) {
      return null;
    }
    final resolvedMode = AuthMode.values.firstWhereOrNull((e) => e.name == uri.queryParameters["mode"]);
    if (resolvedMode == null) {
      return null;
    }
    return (
      mode: resolvedMode,
      destinationAfterReAuth: uri.queryParameters["destinationAfterReAuth"],
    );
  }
}
