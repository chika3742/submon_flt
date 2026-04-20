import "dart:async";

import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

import "../features/auth/domain/models/auth_mode.dart";
import "../features/auth/ui/pages/email_sign_in_page.dart";
import "../features/auth/ui/pages/sign_in_page.dart";
import "../features/auth/ui/pages/welcome_page.dart";

part "routes.g.dart";

@TypedGoRoute<WelcomeRoute>(path: "/welcome")
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WelcomePage();
  }
}

@TypedGoRoute<SignInRoute>(path: "/sign-in", routes: [
  TypedGoRoute<EmailSignInRoute>(path: "email"),
])
class SignInRoute extends GoRouteData with $SignInRoute {
  final AuthMode? mode;
  /// {@macro signInContinueUri}
  final Uri? continueUri;

  const SignInRoute({this.mode, this.continueUri});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignInPage(mode: mode ?? .signIn, continueUri: continueUri);
  }
}

class EmailSignInRoute extends GoRouteData with $EmailSignInRoute {
  final AuthMode? mode;
  /// {@macro signInContinueUri}
  final Uri? continueUri;

  const EmailSignInRoute({this.mode, this.continueUri});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmailSignInPage(mode: mode ?? .signIn, continueUri: continueUri);
  }
}
