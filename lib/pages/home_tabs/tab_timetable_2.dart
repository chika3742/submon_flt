import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/components/timetable/timetable_day_list.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/db/timetable_class_time.dart';
import 'package:submon/db/timetable_table.dart';
import 'package:submon/events.dart';

class TabTimetable2 extends StatefulWidget {
  const TabTimetable2({Key? key}) : super(key: key);

  @override
  State<TabTimetable2> createState() => _TabTimetable2State();
}

class _TabTimetable2State extends State<TabTimetable2> {
  StreamSubscription? _listener;
  late final PageController _controller;
  List<Timetable>? _items;
  List<TimetableTable>? _tables;
  List<TimetableClassTime>? _classTimes;
  SharedPrefs? prefs;

  @override
  void initState() {
    initSharedPrefs();
    initTableList();

    _listener = eventBus.on<TimetableListChanged>().listen((event) {
      initTable();
      initTableList();
    });

    super.initState();
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  void initSharedPrefs() async {
    prefs ??= SharedPrefs(await SharedPreferences.getInstance());

    initPagePos();
  }

  void initPagePos() {
    var page = DateTime.now().weekday - 1;
    if (!prefs!.timetableShowSaturday && page == 5) {
      page = 0;
    }
    if (page == 6) {
      page = 0;
    }
    _controller = PageController(initialPage: page);

    initTable();
  }

  void initTable() async {
    await TimetableProvider().use((provider) async {
      var timetableId = prefs?.currentTimetableId;
      if (timetableId == "main") {
        _items = await provider.getAll(where: "$colTableId is null");
      } else {
        _items = await provider
            .getAll(where: "$colTableId = ?", whereArgs: [timetableId]);
      }

      await TimetableClassTimeProvider().use((provider) async {
        _classTimes = await provider.getAll();
      });

      setState(() {});
    });
  }

  void initTableList() {
    TimetableTableProvider().use((provider) async {
      _tables = await provider.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items == null || prefs == null) return Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: PageView.builder(
            itemCount: prefs!.timetableShowSaturday ? 6 : 5,
            controller: _controller,
            itemBuilder: (context, index) {
              var items = _items!
                  .where((element) => element.cellId % 6 == index)
                  .toList();
              return TimetableDayList(
                weekday: index,
                prefs: prefs!,
                items: items,
                classTimeItems: _classTimes!,
              );
            },
          ),
        ),
        if (_tables != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: prefs!.currentTimetableId,
              decoration: const InputDecoration(
                label: Text("時間割選択"),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: "main",
                  child: Text("メイン"),
                ),
                ..._tables!.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.id.toString(),
                    child: Text(e.title!),
                  );
                }).toList()
              ],
              onChanged: (e) {
                setState(() {
                  prefs!.currentTimetableId = e!;
                });
                initTable();
              },
            ),
          ),
      ],
    );
  }
}
