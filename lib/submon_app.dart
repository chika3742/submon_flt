import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";

import "features/shared/ui/providers/scaffold_messenger.dart";
import "routing/router_provider.dart";

class SubmonApp extends ConsumerWidget {
  const SubmonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme(Brightness brightness) => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: brightness,
      ),
      textTheme: GoogleFonts.mPlusRounded1cTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
    );

    return MaterialApp.router(
      title: "Submon",
      routerConfig: ref.watch(routerProvider),
      theme: theme(.light),
      darkTheme: theme(.dark),
      scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
    );
  }
}
