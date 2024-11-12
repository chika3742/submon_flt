import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:go_router/go_router.dart";
import 'i18n/strings.g.dart';

import "routes.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MyApp()));
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
    final themeDataBase = ThemeData(
      colorSchemeSeed: Colors.green,
    ).copyWith(
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
        },
      ),
    );

    return MaterialApp.router(
      theme: themeDataBase,
      darkTheme: themeDataBase.copyWith(brightness: Brightness.dark),
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: _router,
    );
  }
}

