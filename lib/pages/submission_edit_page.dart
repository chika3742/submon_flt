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
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            var focusScopeNode = FocusScope.of(context);
            if (focusScopeNode.focusedChild?.hasFocus == true) {
              focusScopeNode.unfocus();
              await Future.delayed(const Duration(milliseconds: 130));
            }

            if (context.mounted) {
              Navigator.pop(context, didPop);
            }
          },
          child: SubmissionEditor(submissionId: submissionId),
        ));
  }
}

class SubmissionEditPageArguments {
  final int submissionId;

  SubmissionEditPageArguments(this.submissionId);
}
