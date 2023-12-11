import 'package:flutter/material.dart';
import 'package:submon/components/submissions/submission_editor.dart';

class CreateSubmissionPage extends StatelessWidget {
  const CreateSubmissionPage(
      {super.key, this.initialTitle, this.initialDeadline});

  static const routeName = "/submission/create";

  final String? initialTitle;
  final DateTime? initialDeadline;

  @override
  Widget build(BuildContext context) {
    final focusScopeNode = FocusScope.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('新規作成'),
        ),
        body: PopScope(
          canPop: focusScopeNode.focusedChild?.hasFocus != true,
          onPopInvoked: (didPop) async {
            if (!didPop) {
              focusScopeNode.unfocus();
              await Future.delayed(const Duration(milliseconds: 130));
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          },
          child: SubmissionEditor(
              initialTitle: initialTitle, initialDeadline: initialDeadline),
        ));
  }
}

class CreateSubmissionPageArguments {
  final String? initialTitle;
  final DateTime? initialDeadline;

  CreateSubmissionPageArguments({this.initialTitle, this.initialDeadline});
}

