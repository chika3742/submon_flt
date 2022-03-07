import 'package:flutter/material.dart';
import 'package:submon/db/dotime.dart';

class FocusTimerPage extends StatefulWidget {
  FocusTimerPage({Key? key, required Map<String, dynamic> arguments})
      : doTime = arguments["doTime"],
        super(key: key);

  final DoTime doTime;

  @override
  State<FocusTimerPage> createState() => _FocusTimerPageState();
}

class _FocusTimerPageState extends State<FocusTimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('集中タイマー'),
      ),
      body: Container(),
    );
  }
}
