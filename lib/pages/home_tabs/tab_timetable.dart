import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:submon/components/timetable.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart' as db;
import 'package:submon/db/timetable_table.dart';

class TabTimetable extends StatefulWidget {
  const TabTimetable({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TabTimetableState();
}

class TabTimetableState extends State<TabTimetable> {
  var loading = false;
  int? timetableCount;
  bool? timetableBanner1Flag;
  List<TimetableTable> tables = [];
  String tableId = "main";

  Map<int, db.Timetable>? table;
  var bannerKey = GlobalKey();
  var tableKey = GlobalKey<TimetableState>();

  @override
  void initState() {
    super.initState();
    getTimetableCount();
    getPref();
  }

  void getTimetableCount() {
    db.TimetableProvider().use((provider) async {
      var count = Sqflite.firstIntValue(await provider.db
          .rawQuery('SELECT COUNT(*) FROM ${provider.tableName()}'));
      setState(() {
        timetableCount = count;
      });
    });
  }

  void getPref() {
    SharedPrefs.use((prefs) {
      setState(() {
        timetableBanner1Flag = prefs.timetableBanner1Flag;
        tableId = prefs.currentTimetableId;
      });
    });
    TimetableTableProvider().use((provider) async {
      tables = await provider.getAll();
      if (!tables.any((element) => element.id.toString() == tableId))
        tableId = "main";
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    if (timetableBanner1Flag == null) {
      return Container();
    } else {
      return Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
                child: SizedBox(
                  height: timetableBanner1Flag == false &&
                          timetableCount != null &&
                          timetableCount! >= 1
                      ? (bannerKey.currentContext?.findRenderObject()
                              as RenderBox?)
                          ?.size
                          .height
                      : 0,
                  child: MaterialBanner(
                    key: bannerKey,
                    content: const Text("科目を長押しして提出物を作成することもできます"),
                    forceActionsBelow: true,
                    actions: [
                      TextButton(
                          child: const Text("閉じる"),
                          onPressed: () {
                            SharedPrefs.use((prefs) {
                              prefs.timetableBanner1Flag = true;
                              setState(() {
                                timetableBanner1Flag = true;
                              });
                            });
                          })
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 32),
                child: SizedBox(
                  child: DropdownButton<String>(
                    value: tableId,
                    enableFeedback: true,
                    items: [
                      const DropdownMenuItem(
                        value: "main",
                        child: Text('メイン'),
                      ),
                      ...tables.map((e) => DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(e.title),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tableId = value!;
                      });
                      SharedPrefs.use((prefs) {
                        prefs.currentTimetableId = value!;
                        tableKey.currentState?.getTable();
                      });
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
