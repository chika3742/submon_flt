import "package:flutter/material.dart";

import "../i18n/strings.g.dart";

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.pages.more),
      ),
      body: Placeholder(),
    );
  }
}
