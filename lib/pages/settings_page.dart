import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage(this.title, {Key? key, this.page}) : super(key: key);

  final Widget? page;
  final String title;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(title),
        ),
        body: page
    );
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

