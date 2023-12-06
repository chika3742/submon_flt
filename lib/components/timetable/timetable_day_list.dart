import 'dart:async';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/main.dart';
import 'package:submon/pages/timetable_cell_edit_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../../isar_db/isar_timetable.dart';
import '../../isar_db/isar_timetable_class_time.dart';
import '../../sample_data.dart';

class TimetableDayList extends StatefulWidget {
  const TimetableDayList({
    super.key,
    required this.weekday,
    required this.prefs,
    required this.items,
    required this.classTimeItems,
  });

  final int weekday;
  final List<Timetable> items;
  final SharedPrefs prefs;
  final List<TimetableClassTime> classTimeItems;

  @override
  State<TimetableDayList> createState() => _TimetableDayListState();
}

class _TimetableDayListState extends State<TimetableDayList> {
  final _columnKey = GlobalKey();
  Timer? _markerTimer;
  double? _markerPos;

  @override
  void initState() {
    _markerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setMarkerPos();
    });
    setMarkerPos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _markerTimer?.cancel();
  }

  void setMarkerPos() {
    if (!widget.prefs.timetableShowTimeMarker) {
      return;
    }
    Future(() {
      setState(() {
        var currentTime = TimeOfDay.now();
        var currentPeriod = widget.classTimeItems.firstWhereOrNull((element) {
          return currentTime.isInsideRange(element.startTime, element.endTime);
        });

        if (currentPeriod != null) {
          var currentContext =
              GlobalObjectKey(getWidgetId(currentPeriod.period - 1))
                  .currentContext;
          _markerPos = getWidgetPos(currentContext)!.dy -
              16 +
              getWidgetSize(currentContext)!.height *
                  ((currentTime.toMinutes() - currentPeriod.startTime.toMinutes()) /
                      (currentPeriod.endTime.toMinutes() -
                          currentPeriod.startTime.toMinutes()));
        } else {
          var interval = widget.classTimeItems.firstWhereOrNull((e) {
            return e.endTime.toMinutes() < currentTime.toMinutes() &&
                widget.classTimeItems.any((element) =>
                element.period == e.period + 1 &&
                    currentTime.toMinutes() < element.startTime.toMinutes());
          });
          if (interval != null) {
            var currentContext =
                GlobalObjectKey(getWidgetId(interval.period - 1))
                    .currentContext;
            _markerPos = getWidgetPos(currentContext)!.dy -
                16 +
                getWidgetSize(currentContext)!.height +
                4;
          } else {
            _markerPos = null;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isCurrentDay = widget.weekday == DateTime.now().weekday - 1;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            Column(
              key: _columnKey,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Text(getWeekdayString(widget.weekday),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: isCurrentDay ? FontWeight.bold : null,
                        color: isCurrentDay ? Colors.orangeAccent : null,
                      )),
                ),
                const SizedBox(height: 16),
                ..._buildTimetableList(),
                const SizedBox(height: 16),
              ],
            ),
            if (widget.prefs.timetableShowTimeMarker)
              Visibility(
                visible: DateTime.now().weekday - 1 == widget.weekday &&
                    _markerPos != null,
                child: Positioned(
                  top: _markerPos,
                  left: 20,
                  child: const IgnorePointer(
                    child: Icon(Icons.arrow_right, size: 32, color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Offset? getWidgetPos(BuildContext? context) {
    if (context == null) return null;
    var childOffset =
        (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    return (_columnKey.currentContext?.findRenderObject() as RenderBox)
        .globalToLocal(childOffset);
  }

  Size? getWidgetSize(BuildContext? context) {
    if (context == null) return null;
    return (context.findRenderObject() as RenderBox).size;
  }

  List<Widget> _buildTimetableList() {
    var list = <Widget>[];

    if (screenShotMode) {
      list = [
        const SizedBox(height: 8),
        _buildTimetableCell(
          0,
          SampleData.timetable[0],
        ),
        const SizedBox(height: 8),
        _buildTimetableCell(
          1,
          SampleData.timetable[1],
        ),
        const SizedBox(height: 8),
        _buildTimetableCell(
          2,
          SampleData.timetable[2],
        ),
        const SizedBox(height: 8),
        _buildTimetableCell(
          3,
          SampleData.timetable[3],
        ),
        const SizedBox(height: 8),
        _buildTimetableCell(
          4,
          SampleData.timetable[4],
        ),
      ];
    } else {
      for (var index = 0; index < widget.prefs.timetablePeriodCountToDisplay; index++) {
        list.add(const SizedBox(height: 8));
        list.add(_buildTimetableCell(
            index,
            widget.items
                .firstWhereOrNull((e) => (e.cellId / 6).floor() == index)));
      }
    }

    return list;
  }

  Widget _buildTimetableCell(int index, Timetable? data) {
    TimetableClassTime? timeItem;
    if (screenShotMode) {
      var startHour = [9, 10, 11, 13, 14][index];
      timeItem = TimetableClassTime.fromStartEnd(TimeOfDay(hour: startHour, minute: 0), TimeOfDay(hour: startHour, minute: 50));
    } else {
      timeItem = widget.classTimeItems
          .firstWhereOrNull((element) => element.period == index + 1);
    }
    return OpenContainer<dynamic>(
      key: GlobalObjectKey(getWidgetId(index)),
      useRootNavigator: true,
      closedColor: Theme.of(context).cardColor,
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      closedElevation: 4,
      closedBuilder: (context, callback) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("${index + 1}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            if (widget.prefs.timetableShowClassTime)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(timeItem?.startTime.format(context) ?? "--:--"),
                    Transform.rotate(
                      angle: pi / 2,
                      child: const Icon(Icons.arrow_right),
                    ),
                    Text(timeItem?.endTime.format(context) ?? "--:--"),
                  ],
                ),
              ),
            const SizedBox(
                height: 32, child: VerticalDivider(width: 2, thickness: 2)),
            const SizedBox(width: 16),
            if (data != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(data.subject, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 12),
                    const Divider(height: 2, thickness: 2),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.meeting_room),
                            Text(data.room == "" ? "未登録" : data.room),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person),
                            Text(data.teacher == "" ? "未登録" : data.teacher),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            if (data != null)
              IconButton(
                icon: const Icon(Icons.library_add),
                splashRadius: 24,
                onPressed: () {
                  createNewSubmissionForTimetable(
                      context, widget.weekday, data.subject);
                },
              )
          ],
        );
      },
      openBuilder: (context, callback) {
        return TimetableCellEditPage(
          initialData: data,
          weekDay: widget.weekday,
          period: index,
        );
      },
    );
  }

  int getWidgetId(int index) {
    return int.parse("${widget.weekday}$index");
  }
}
