import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeDataBase = ThemeData(
      colorSchemeSeed: Colors.green,
    );

    return MaterialApp(
      theme: themeDataBase,
      darkTheme: themeDataBase.copyWith(brightness: Brightness.dark),
      supportedLocales: [
        Locale("ja", "jp"),
        Locale("en", "us"),
      ],
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}

