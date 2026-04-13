import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";

import "routing/routes.dart";

class SubmonApp extends StatelessWidget {
  SubmonApp({super.key});

  final _router = GoRouter(
    routes: $appRoutes,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Submon",
      routerConfig: _router,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        textTheme: GoogleFonts.ibmPlexSansJpTextTheme(),
      ),
    );
  }
}
