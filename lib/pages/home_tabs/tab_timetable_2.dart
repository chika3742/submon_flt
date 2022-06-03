import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/components/timetable/timetable_day_list.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';

import '../../isar_db/isar_timetable.dart';
import '../../isar_db/isar_timetable_class_time.dart';
import '../../isar_db/isar_timetable_table.dart';

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

    _listener = eventBus.on<TimetableListChanged>().listen((event) {
      initTable();
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
      _items = await provider.getCurrentTable();
    });
    await TimetableClassTimeProvider().use((provider) async {
      _classTimes = await provider.getAll();
    });
    await TimetableTableProvider().use((provider) async {
      _tables = await provider.getAll();
    });

    var sharedPrefs = SharedPrefs(await SharedPreferences.getInstance());
    if (!_tables!.any((element) => element.id == sharedPrefs.intCurrentTimetableId)) {
      sharedPrefs.intCurrentTimetableId = -1;
    }

    setState(() {});
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
            child: DropdownButtonFormField<int>(
              value: prefs!.intCurrentTimetableId,
              decoration: const InputDecoration(
                label: Text("時間割選択"),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: -1,
                  child: Text("メイン"),
                ),
                ..._tables!.map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.title),
                  );
                }).toList()
              ],
              onChanged: (e) {
                setState(() {
                  prefs!.intCurrentTimetableId = e!;
                });
                initTable();
              },
            ),
          ),
      ],
    );
  }
}
