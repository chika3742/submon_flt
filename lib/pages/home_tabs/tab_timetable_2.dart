import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../components/timetable/timetable_day_list.dart";
import "../../core/pref_key.dart";
import "../../providers/core_providers.dart";
import "../../providers/timetable_providers.dart";

class TabTimetable2 extends ConsumerStatefulWidget {
  const TabTimetable2({super.key});

  @override
  ConsumerState<TabTimetable2> createState() => _TabTimetable2State();
}

class _TabTimetable2State extends ConsumerState<TabTimetable2> {
  late final PageController _controller;
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    _initPageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initPageController() {
    final showSaturday =
        ref.readPref(PrefKey.timetableShowSaturday);
    var page = DateTime.now().weekday - 1;
    if (!showSaturday && page == 5) {
      page = 0;
    }
    if (page == 6) {
      page = 0;
    }
    _controller = PageController(initialPage: page);
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return Container();

    final showSaturday = ref.watchPref(PrefKey.timetableShowSaturday);
    final tableId = ref.watchPref(PrefKey.intCurrentTimetableId);
    final cellsAsync = ref.watch(timetableCellsProvider(tableId));
    final classTimesAsync = ref.watch(classTimesProvider);
    final tablesAsync = ref.watch(timetableTablesProvider);

    final items = cellsAsync.value;
    final classTimes = classTimesAsync.value;
    final tables = tablesAsync.value;

    if (items == null || classTimes == null) return Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: PageView.builder(
            itemCount: showSaturday ? 6 : 5,
            controller: _controller,
            itemBuilder: (context, index) {
              final dayItems = items
                  .where((element) => element.cellId % 6 == index)
                  .toList();
              return TimetableDayList(
                weekday: index,
                showTimeMarker: ref.watchPref(PrefKey.timetableShowTimeMarker),
                showClassTime: ref.watchPref(PrefKey.timetableShowClassTime),
                periodCount: ref.watchPref(PrefKey.timetablePeriodCountToDisplay),
                items: dayItems,
                classTimeItems: classTimes,
              );
            },
          ),
        ),
        if (tables != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<int>(
              initialValue: tableId,
              decoration: const InputDecoration(
                label: Text("時間割選択"),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: -1,
                  child: Text("メイン"),
                ),
                ...tables.map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.title),
                  );
                }),
              ],
              onChanged: (e) {
                ref.updatePref(PrefKey.intCurrentTimetableId, e!);
              },
            ),
          ),
      ],
    );
  }
}
