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
    return Scaffold(
        appBar: AppBar(
          title: const Text('新規作成'),
        ),
        body: WillPopScope(
          child: SubmissionEditor(
              initialTitle: initialTitle, initialDeadline: initialDeadline),
          onWillPop: () async {
            var focusScopeNode = FocusScope.of(context);
            if (focusScopeNode.focusedChild?.hasFocus == true) {
              focusScopeNode.unfocus();
              await Future.delayed(const Duration(milliseconds: 130));
            }
            return true;
          },
        ));
  }
}

class CreateSubmissionPageArguments {
  final String? initialTitle;
  final DateTime? initialDeadline;

  CreateSubmissionPageArguments({this.initialTitle, this.initialDeadline});
}

