import 'package:submon/app_link_handler.dart';
import 'package:submon/main.dart';
import 'package:submon/messages.dart';

class AppLinkHandlerFlutterApi implements AppLinkHandlerApi {
  String? pendingUri;

  ///
  /// Called when it seems to be [globalContext] initialized.
  ///
  void contextInitialized() {
    if (pendingUri != null) {
      handleUri(pendingUri!);
      pendingUri = null;
    }
  }

  @override
  void handleUri(String uri) {
    if (globalContext == null) {
      pendingUri = uri;
      return;
    }

    AppLinkHandler.handleLink(Uri.parse(uri));
  }
}
