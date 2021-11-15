import 'package:flutter/material.dart';
import 'package:submon/components/submission_editor.dart';

class SubmissionCreatePage extends StatelessWidget {
  const SubmissionCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('新規作成'),
        ),
        body: WillPopScope(
          child: const SubmissionEditor(),
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

