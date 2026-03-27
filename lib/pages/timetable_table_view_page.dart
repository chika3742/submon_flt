import "package:flutter/material.dart";

import "home_tabs/tab_timetable.dart";
import "timetable_edit_page.dart";

class TimetableTableViewPage extends StatelessWidget {
  const TimetableTableViewPage({super.key});

  static const routeName = "/timetable/table-view";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("テーブルビュー時間割表"),
        actions: [
          IconButton(
            splashRadius: 24,
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(context, TimetableEditPage.routeName);
            },
          ),
        ],
      ),
      body: const TabTimetable(),
    );
  }
}
