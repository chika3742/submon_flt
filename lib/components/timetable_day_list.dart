import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:submon/pages/timetable_cell_edit_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../db/timetable.dart';

class TimetableDayList extends StatefulWidget {
  const TimetableDayList(
      {Key? key,
      required this.weekday,
      required this.periodCount,
      required this.items})
      : super(key: key);

  final int weekday;
  final List<Timetable> items;
  final int periodCount;

  @override
  State<TimetableDayList> createState() => _TimetableDayListState();
}

class _TimetableDayListState extends State<TimetableDayList> {
  final _columnKey = GlobalKey();

  double _markerPos = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        var currentContext = GlobalObjectKey(getWidgetId(3)).currentContext;
        _markerPos = getWidgetPos(currentContext)!.dy - 16 + 32;
      });
    });
    super.initState();
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
            Visibility(
              visible: DateTime.now().weekday - 1 == widget.weekday,
              child: Positioned(
                top: _markerPos,
                left: 16,
                child: const Icon(Icons.arrow_right, size: 32),
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

    for (var index = 0; index < widget.periodCount; index++) {
      list.add(const SizedBox(height: 8));
      list.add(_buildTimetableCell(
          index,
          widget.items
              .firstWhereOrNull((e) => (e.cellId / 6).floor() == index)));
    }

    return list;
  }

  Widget _buildTimetableCell(int index, Timetable? data) {
    return OpenContainer(
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
                    Row(
                      children: [
                        const Icon(Icons.meeting_room),
                        Text(data.room == "" ? "未登録" : data.room),
                        const SizedBox(width: 16),
                        const Icon(Icons.person),
                        Text(data.teacher == "" ? "未登録" : data.teacher),
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
                      context, widget.weekday, data!.subject);
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
