import 'package:flutter/material.dart';

class DoneSubmissionsPage extends StatefulWidget {
  const DoneSubmissionsPage({Key? key}) : super(key: key);

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
      body: Container());
  }
}
