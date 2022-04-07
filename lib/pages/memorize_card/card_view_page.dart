import 'package:flutter/material.dart';

class CardViewPage extends StatefulWidget {
  CardViewPage({Key? key, required dynamic arguments})
      : folderId = arguments["folderId"],
        super(key: key);

  final int folderId;

  @override
  State<CardViewPage> createState() => _CardViewPageState();
}

class _CardViewPageState extends State<CardViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カードビュー'),
      ),
      body: Container(),
    );
  }
}
