import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/db/timetable_table.dart';
import 'package:submon/events.dart';

import '../../components/timetable_day_list.dart';

class TabTimetable2 extends StatefulWidget {
  const TabTimetable2({Key? key}) : super(key: key);

  @override
  State<TabTimetable2> createState() => _TabTimetable2State();
}

class _TabTimetable2State extends State<TabTimetable2> {
  StreamSubscription? _listener;
  int periodCount = 6;
  bool showSaturday = true;
  final _controller = PageController(
      initialPage:
          DateTime.now().weekday != 7 ? DateTime.now().weekday - 1 : 0);
  List<Timetable>? _items;
  List<TimetableTable>? _tables;
  int? _currentTableId;

  @override
  void initState() {
    initTable();
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

  void initTable() {
    SharedPrefs.use((prefs) {
      periodCount = prefs.timetableHour;
      showSaturday = prefs.timetableShowSaturday;
      TimetableProvider().use((provider) async {
        var timetableId = prefs.currentTimetableId;
        if (timetableId == "main") {
          _currentTableId = -1;
          _items = await provider.getAll(where: "$colTableId is null");
        } else {
          _currentTableId = int.parse(timetableId);
          _items = await provider
              .getAll(where: "$colTableId = ?", whereArgs: [timetableId]);
        }

        setState(() {});
      });
    });
  }

  void initTableList() {
    TimetableTableProvider().use((provider) async {
      _tables = await provider.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items == null) return Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: PageView.builder(
            itemCount: showSaturday ? 6 : 5,
            controller: _controller,
            itemBuilder: (context, index) {
              var items = _items!
                  .where((element) => element.cellId % 6 == index)
                  .toList();
              return TimetableDayList(
                  weekday: index, periodCount: periodCount, items: items);
            },
          ),
        ),
        if (_tables != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<int>(
              value: _currentTableId,
              decoration: const InputDecoration(
                label: Text("時間割選択"),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: -1,
                  child: Text("メイン"),
                ),
                ..._tables!.map((e) {
                  return DropdownMenuItem<int>(
                    value: e.id,
                    child: Text(e.title!),
                  );
                }).toList()
              ],
              onChanged: (e) {
                setState(() {
                  _currentTableId = e;
                });
                SharedPrefs.use((prefs) {
                  prefs.currentTimetableId = _currentTableId == -1
                      ? "main"
                      : _currentTableId.toString();
                });
                initTable();
              },
            ),
          ),
      ],
    );
  }
}
