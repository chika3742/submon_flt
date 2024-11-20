import "package:flutter/material.dart";

import "../i18n/strings.g.dart";

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.pages.timetable),
      ),
      body: Placeholder(),
    );
  }
}
