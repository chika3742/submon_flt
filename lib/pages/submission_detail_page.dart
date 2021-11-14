import 'package:flutter/material.dart';

class SubmissionDetailPage extends StatefulWidget {
  const SubmissionDetailPage({Key? key}) : super(key: key);

  @override
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("詳細"),),
      body: Container(),
    );
  }
}
