import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submon/components/timetable.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart' as db;
import 'package:submon/db/timetable_table.dart';
import 'package:submon/events.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';

class TabTimetable extends StatefulWidget {
  const TabTimetable({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TabTimetableState();
}

class TabTimetableState extends State<TabTimetable> {
  var loading = false;
  List<TimetableTable> tables = [];
  SharedPrefs? prefs;

  Map<int, db.Timetable>? table;
  var bannerKey = GlobalKey();
  var tableKey = GlobalKey<TimetableState>();
  StreamSubscription? listener;

  @override
  void initState() {
    super.initState();
    getTableList();

    SharedPrefs.use((prefs) {
      setState(() {
        this.prefs = prefs;
      });

      if (prefs.isTimetableInsertedOnce && !prefs.isTimetableTipsDisplayed) {
        var context = Application.globalKey.currentContext!;
        showMaterialBanner(
          context,
          content: const Text("科目を長押しで、その科目の提出物を作成できます。"),
          actions: [
            TextButton(
              child: const Text("閉じる"),
              onPressed: () {
                hideMaterialBanner(context);
              },
            )
          ],
        );

        prefs.isTimetableTipsDisplayed = true;
      }
    });

    listener = eventBus.on<TimetableListChanged>().listen((event) {
      tableKey.currentState?.getTable();
    });
  }

  void getTableList() {
    TimetableTableProvider().use((provider) async {
      tables = await provider.getAll();
      if (prefs != null &&
          !tables.any((element) =>
              element.id.toString() == prefs!.currentTimetableId)) {
        prefs!.currentTimetableId = "main";
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      return Container();
    } else {
      return Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 32),
                child: SizedBox(
                  child: DropdownButton<String>(
                    value: prefs!.currentTimetableId,
                    enableFeedback: true,
                    items: [
                      const DropdownMenuItem(
                        value: "main",
                        child: Text('メイン'),
                      ),
                      ...tables.map((e) => DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(e.title!),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        prefs!.currentTimetableId = value!;
                      });
                      tableKey.currentState?.getTable();
                    },
                  ),
                ),
              ),
              Timetable(
                key: tableKey,
              ),
            ],
          ),
        ],
      );
    }
  }

  void updateUI() {
    setState(() {});
  }
}
