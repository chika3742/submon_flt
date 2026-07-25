// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$welcomeRoute, $signInRoute];

RouteBase get $welcomeRoute =>
    GoRouteData.$route(path: '/welcome', factory: $WelcomeRoute._fromState);

mixin $WelcomeRoute on GoRouteData {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  @override
  String get location => GoRouteData.$location('/welcome');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRoute => GoRouteData.$route(
  path: '/sign-in',
  factory: $SignInRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'email', factory: $EmailSignInRoute._fromState),
  ],
);

mixin $SignInRoute on GoRouteData {
  static SignInRoute _fromState(GoRouterState state) => SignInRoute(
    mode: _$convertMapValue(
      'mode',
      state.uri.queryParameters,
      _$AuthModeEnumMap._$fromName,
    ),
    continueUri: _$convertMapValue(
      'continue-uri',
      state.uri.queryParameters,
      Uri.tryParse,
    ),
  );

  SignInRoute get _self => this as SignInRoute;

  @override
  String get location => GoRouteData.$location(
    '/sign-in',
    queryParams: {
      if (_self.mode != null) 'mode': _$AuthModeEnumMap[_self.mode!],
      if (_self.continueUri != null)
        'continue-uri': _self.continueUri!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

const _$AuthModeEnumMap = {
  AuthMode.signIn: 'sign-in',
  AuthMode.reauthenticate: 'reauthenticate',
  AuthMode.upgrade: 'upgrade',
};

mixin $EmailSignInRoute on GoRouteData {
  static EmailSignInRoute _fromState(GoRouterState state) => EmailSignInRoute(
    mode: _$convertMapValue(
      'mode',
      state.uri.queryParameters,
      _$AuthModeEnumMap._$fromName,
    ),
    continueUri: _$convertMapValue(
      'continue-uri',
      state.uri.queryParameters,
      Uri.tryParse,
    ),
  );

  EmailSignInRoute get _self => this as EmailSignInRoute;

  @override
  String get location => GoRouteData.$location(
    '/sign-in/email',
    queryParams: {
      if (_self.mode != null) 'mode': _$AuthModeEnumMap[_self.mode!],
      if (_self.continueUri != null)
        'continue-uri': _self.continueUri!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}
