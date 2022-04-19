import 'package:flutter/material.dart';
import 'package:submon/events.dart';
import 'package:submon/pages/home_tabs/tab_timetable.dart';

class TimetableTableViewPage extends StatefulWidget {
  const TimetableTableViewPage({Key? key}) : super(key: key);

  @override
  State<TimetableTableViewPage> createState() => _TimetableTableViewPageState();
}

class _TimetableTableViewPageState extends State<TimetableTableViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('テーブルビュー時間割表'),
        actions: [
          IconButton(
            splashRadius: 24,
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(context, "/timetable/edit");
              eventBus.fire(TimetableListChanged());
            },
          )
        ],
      ),
      body: const TabTimetable(),
    );
  }
}
