import 'package:flutter/material.dart';
import 'package:submon/components/submissions/submission_list.dart';

class DoneSubmissionsPage extends StatefulWidget {
  const DoneSubmissionsPage({Key? key}) : super(key: key);

  static const routeName = "/done-submissions";

  @override
  _DoneSubmissionsPageState createState() => _DoneSubmissionsPageState();
}

class _DoneSubmissionsPageState extends State<DoneSubmissionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('完了済みの提出物'),
        ),
        body: const SubmissionList(done: true));
  }
}
