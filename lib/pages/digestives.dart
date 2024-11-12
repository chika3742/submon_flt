import "package:flutter/material.dart";

import "../i18n/strings.g.dart";

class DigestiveListScreen extends StatelessWidget {
  const DigestiveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.pages.digestives),
      ),
      body: Placeholder(),
    );
  }
}
