import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "i18n/strings.g.dart";

import "routes.dart";
import "ui_core/theme_extension.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locale = await LocaleSettings.useDeviceLocale();
  Intl.defaultLocale = locale.flutterLocale.toLanguageTag();
  // TODO: add font licenses
  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const MyApp(),
      ),
    ),
  );
}

final _router = GoRouter(
  initialLocation: "/submissions",
  routes: $appRoutes,
  redirect: (context, state) {
    if (state.uri.path == "/") {
      return "/submissions";
    }
    return null;
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchemeSeed = Colors.green;
    final pageTransitionsTheme = PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
      },
    );

    return MaterialApp.router(
      theme: ThemeData(
        colorSchemeSeed: colorSchemeSeed,
        pageTransitionsTheme: pageTransitionsTheme,
        extensions: [
          SubmonThemeExtension(
            safeDueTextColor: Colors.green.shade800,
            nearDueTextColor: Colors.orange.shade800,
            overdueTextColor: Colors.red.shade600,
            starColor: Colors.yellow.shade800,
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: colorSchemeSeed,
        pageTransitionsTheme: pageTransitionsTheme,
        extensions: [
          SubmonThemeExtension(
            safeDueTextColor: Colors.green.shade300,
            nearDueTextColor: Colors.orange.shade300,
            overdueTextColor: Colors.red.shade300,
            starColor: Colors.yellow.shade300,
          ),
        ],
      ),
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: _router,
    );
  }
}
