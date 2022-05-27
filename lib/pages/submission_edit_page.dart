import 'package:flutter/material.dart';
import 'package:submon/components/submissions/submission_editor.dart';

class SubmissionEditPage extends StatelessWidget {
  const SubmissionEditPage(this.id, {Key? key}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('編集'),
        ),
        body: WillPopScope(
          child: SubmissionEditor(submissionId: id),
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
