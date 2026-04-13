import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

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
