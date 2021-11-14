import 'package:flutter/material.dart';
import 'package:submon/pages/settings_page.dart';

class SettingFunctions extends StatefulWidget {
  const SettingFunctions({Key? key}) : super(key: key);

  @override
  _SettingFunctionsState createState() => _SettingFunctionsState();
}

class _SettingFunctionsState extends State<SettingFunctions> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CategoryListTile("アカウント"),
        ListTile(
          title: const Text("ログイン / 新規登録"),
          onTap: () {

          },
        )
      ],
    );
  }
}
