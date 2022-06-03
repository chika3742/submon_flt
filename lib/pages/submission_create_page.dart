import 'package:flutter/material.dart';
import 'package:submon/components/submissions/submission_editor.dart';

class SubmissionCreatePage extends StatelessWidget {
  const SubmissionCreatePage(
      {Key? key, this.initialTitle, this.initialDeadline})
      : super(key: key);

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

