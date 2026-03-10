import "package:flutter/material.dart";
import "../components/submissions/submission_list.dart";

class DoneSubmissionsPage extends StatefulWidget {
  const DoneSubmissionsPage({super.key});

  static const routeName = "/done-submissions";

  @override
  DoneSubmissionsPageState createState() => DoneSubmissionsPageState();
}

class DoneSubmissionsPageState extends State<DoneSubmissionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("完了済みの提出物"),
        ),
        body: const SubmissionList(done: true));
  }
}
