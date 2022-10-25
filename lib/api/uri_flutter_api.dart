import 'package:submon/app_link_handler.dart';
import 'package:submon/main.dart';
import 'package:submon/messages.dart';

class UriFlutterApi implements UriApi {
  String? pendingUri;

  ///
  /// Called when widget initialized.
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
