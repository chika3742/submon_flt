// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homePageRoute,
    ];

RouteBase get $homePageRoute => ShellRouteData.$route(
      factory: $HomePageRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/submissions',
          factory: $SubmissionListScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/digestives',
          factory: $DigestiveListScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/timetable',
          factory: $TimetableScreenRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/more',
          factory: $MoreScreenRouteExtension._fromState,
        ),
      ],
    );

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => HomePageRoute();
}

extension $SubmissionListScreenRouteExtension on SubmissionListScreenRoute {
  static SubmissionListScreenRoute _fromState(GoRouterState state) =>
      SubmissionListScreenRoute();

  String get location => GoRouteData.$location(
        '/submissions',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DigestiveListScreenRouteExtension on DigestiveListScreenRoute {
  static DigestiveListScreenRoute _fromState(GoRouterState state) =>
      DigestiveListScreenRoute();

  String get location => GoRouteData.$location(
        '/digestives',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TimetableScreenRouteExtension on TimetableScreenRoute {
  static TimetableScreenRoute _fromState(GoRouterState state) =>
      TimetableScreenRoute();

  String get location => GoRouteData.$location(
        '/timetable',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MoreScreenRouteExtension on MoreScreenRoute {
  static MoreScreenRoute _fromState(GoRouterState state) => MoreScreenRoute();

  String get location => GoRouteData.$location(
        '/more',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
