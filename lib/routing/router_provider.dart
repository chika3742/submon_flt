import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../features/shared/ui/providers/modals.dart";
import "routes.dart";

part "router_provider.g.dart";

@riverpod
bool initialSignInState(Ref ref) {
  throw UnsupportedError("This provider should be initialized via overrides");
}

@riverpod
GoRouter router(Ref ref) {
  final isSignedInInitially = ref.watch(initialSignInStateProvider);

  final router = GoRouter(
    routes: $appRoutes,
    navigatorKey: ref.watch(navigatorKeyProvider),
    initialLocation: isSignedInInitially
        ? const SignInRoute().location // TODO: home page
        : const WelcomeRoute().location,
    debugLogDiagnostics: true,
  );

  return router;
}
