import 'package:flutter/material.dart';

class MigrationPage extends StatefulWidget {
  const MigrationPage({Key? key}) : super(key: key);

  @override
  State<MigrationPage> createState() => _MigrationPageState();
}

class _MigrationPageState extends State<MigrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント移行'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('これで最後です。「アカウント移行を完了する」をタップするとアカウント移行を開始します。\n\n'
                '移行されるデータは以下のとおりです。\n\n'
                '・提出物(完了済みも含む)\n'
                '・Digestive\n'
                '・時間割表\n'
                '・暗記カード\n\n'
                '以下のデータは移行されません。\n'
                '・提出物の写真\n'
                '・各種設定 (リマインダー通知等はすべて設定し直す必要があります。)'),
            const SizedBox(height: 64),
            ElevatedButton(
              child: const Text('アカウント移行を完了する'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
