import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

import "pages/home_page.dart";
import "ui_core/adaptive_transition_page.dart";

part "routes.g.dart";

@TypedGoRoute<HomePageRoute>(
  path: "/",
  routes: [],
)
class HomePageRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildAdaptivePage(
      context: context,
      child: HomePage(),
    );
  }
}
