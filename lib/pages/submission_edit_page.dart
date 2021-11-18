import 'package:flutter/material.dart';
import 'package:submon/components/submission_editor.dart';

class SubmissionEditPage extends StatelessWidget {
  const SubmissionEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('編集'),
        ),
        body: WillPopScope(
          child: SubmissionEditor(submissionId: (ModalRoute.of(context)!.settings.arguments as dynamic)["submissionId"]),
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
