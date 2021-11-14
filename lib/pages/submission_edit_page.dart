import 'package:flutter/material.dart';

class SubmissionEditPage extends StatefulWidget {
  const SubmissionEditPage({Key? key}) : super(key: key);

  @override
  _SubmissionEditPageState createState() => _SubmissionEditPageState();
}

class _SubmissionEditPageState extends State<SubmissionEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("編集"),),
      body: Container(),
    );
  }
}
