import "dart:async";

import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

import "pages/digestives.dart";
import "pages/home.dart";
import "pages/more.dart";
import "pages/submissions/submissions.dart";
import "pages/timetable.dart";

part "routes.g.dart";

@TypedShellRoute<HomePageRoute>(
  routes: [
    TypedGoRoute<SubmissionListScreenRoute>(path: "/submissions"),
    TypedGoRoute<DigestiveListScreenRoute>(path: "/digestives"),
    TypedGoRoute<TimetableScreenRoute>(path: "/timetable"),
    TypedGoRoute<MoreScreenRoute>(path: "/more"),
  ],
)
class HomePageRoute extends ShellRouteData {
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return HomePage(child: navigator);
  }

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return null;
  }
}

class SubmissionListScreenRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildCustomTransitionPage(
      child: SubmissionListScreen(),
    );
  }
}

class DigestiveListScreenRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildCustomTransitionPage(
      child: DigestiveListScreen(),
    );
  }
}

class TimetableScreenRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildCustomTransitionPage(
      child: TimetableScreen(),
    );
  }
}

class MoreScreenRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildCustomTransitionPage(
      child: MoreScreen(),
    );
  }
}


Page _buildCustomTransitionPage({required Widget child}) {
  return CustomTransitionPage(
    key: UniqueKey(),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
