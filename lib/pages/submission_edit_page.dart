import 'package:flutter/material.dart';
import 'package:submon/components/submissions/submission_editor.dart';

class SubmissionEditPage extends StatelessWidget {
  const SubmissionEditPage(this.submissionId, {super.key});

  static const routeName = "/submission/edit";

  final int submissionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('編集'),
        ),
        body: SubmissionEditor(submissionId: submissionId));
  }
}

class SubmissionEditPageArguments {
  final int submissionId;

  SubmissionEditPageArguments(this.submissionId);
}
