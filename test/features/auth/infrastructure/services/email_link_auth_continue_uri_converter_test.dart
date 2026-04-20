import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/features/auth/domain/models/auth_mode.dart";
import "package:submon/features/auth/infrastructure/services/email_link_auth_continue_uri_converter.dart";

void main() {
  const converter = EmailLinkAuthContinueUriConverter();

  // debugDefaultTargetPlatformOverride cannot change kReleaseMode,
  // so in debug mode appHost = "dev.submon.app"
  const expectedHost = kReleaseMode ? "submon.app" : "dev.submon.app";
  
  const emailAuthCallbackPath = "/email-auth-callback";

  group("isEmailLinkAuthContinueUrl", () {
    test("returns true for valid URL", () {
      final uri = Uri.https(expectedHost, emailAuthCallbackPath);
      expect(
        EmailLinkAuthContinueUriConverter.isEmailLinkAuthContinueUrl(uri),
        isTrue,
      );
    });

    test("returns false for HTTP scheme", () {
      final uri = Uri.http(expectedHost, emailAuthCallbackPath);
      expect(
        EmailLinkAuthContinueUriConverter.isEmailLinkAuthContinueUrl(uri),
        isFalse,
      );
    });

    test("returns false for wrong host", () {
      final uri = Uri.https("evil.com", emailAuthCallbackPath);
      expect(
        EmailLinkAuthContinueUriConverter.isEmailLinkAuthContinueUrl(uri),
        isFalse,
      );
    });

    test("returns false for wrong path", () {
      final uri = Uri.https(expectedHost, "/other-path");
      expect(
        EmailLinkAuthContinueUriConverter.isEmailLinkAuthContinueUrl(uri),
        isFalse,
      );
    });
  });

  group("toUri", () {
    test("builds URI with mode and destination", () {
      final uri = converter.toUri(
        AuthMode.reauthenticate,
        "/settings",
      );
      expect(uri.scheme, "https");
      expect(uri.host, expectedHost);
      expect(uri.path, emailAuthCallbackPath);
      expect(uri.queryParameters["mode"], "reauthenticate");
      expect(uri.queryParameters["destinationAfterReAuth"], "/settings");
    });

  });

  group("fromUri", () {
    test("returns record for valid URL", () {
      final uri = converter.toUri(AuthMode.upgrade, "/account");
      final result = converter.fromUri(uri);
      expect(result, isNotNull);
      expect(result!.mode, AuthMode.upgrade);
      expect(result.destinationAfterReAuth, "/account");
    });

    test("returns null for invalid URL", () {
      final uri = Uri.https("evil.com", emailAuthCallbackPath, {
        "mode": "signIn",
      });
      expect(converter.fromUri(uri), isNull);

      // Invalid mode
      final uri2 = Uri.https(expectedHost, emailAuthCallbackPath, {
        "mode": "invalid",
      });
      expect(converter.fromUri(uri2), isNull);
    });

    test("roundtrips all AuthMode values", () {
      for (final mode in AuthMode.values) {
        const continueUri = "/test?value=1";
        final uri = converter.toUri(mode, continueUri);
        final result = converter.fromUri(uri);
        expect(result, isNotNull, reason: "${mode.name} roundtrip failed");
        expect(result!.mode, mode);
        expect(result.destinationAfterReAuth, continueUri);
      }
    });
  });
}
