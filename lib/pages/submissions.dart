import "package:flutter/material.dart";

import "../i18n/strings.g.dart";

class SubmissionListScreen extends StatelessWidget {
  const SubmissionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.pages.submissions),
      ),
      body: Placeholder(),
    );
  }
}
