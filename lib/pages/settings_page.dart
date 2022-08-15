import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(this.title, this.body, {Key? key}) : super(key: key);

  final Widget? body;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: body);
  }
}

class CategoryListTile extends StatelessWidget {
  const CategoryListTile(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 4),
      child: Text(title, style: const TextStyle(color: Colors.pinkAccent)));
  }
}

