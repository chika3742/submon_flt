import "../features/shared/domain/app_host.dart";

/// Client ID for Sign in with Apple
const asiClientId = "net.chikach.submon.asi";

/// Redirect URI for parsing POST request from Apple
final redirectUri = Uri.https(appHost, "/api/v1/redirectToAppleSignInCallback");

/// URI that is ultimately called back to the app.
final callbackUri = Uri.https(appHost, "/apple-auth-callback");
