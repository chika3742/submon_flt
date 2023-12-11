import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/timetable/open_modal_animation.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/isar_db/isar_timetable.dart' as db;
import 'package:submon/pages/timetable_cell_edit_page.dart';
import 'package:submon/pages/timetable_edit_page.dart';
import 'package:submon/utils/ui.dart';

import '../../utils/utils.dart';

class Timetable extends StatefulWidget {
  const Timetable({
    super.key,
    this.edit = false,
  });

  final bool edit;

  @override
  State<Timetable> createState() => TimetableState();
}

class TimetableState extends State<Timetable> {
  int? timetablePeriodCountToDisplay;
  late Map<int, db.Timetable> table = {};

  @override
  void initState() {
    super.initState();
    getPref();
    getTable();
  }

  void getPref() {
    SharedPrefs.use((prefs) {
      setState(() {
        timetablePeriodCountToDisplay = prefs.timetablePeriodCountToDisplay;
      });
    });
  }

  void getTable() {
    db.TimetableProvider().use((provider) async {
      List<db.Timetable> list = await provider.getCurrentTable();

      setState(() {
        table = Map.fromIterables(list.map((e) => e.cellId), list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: _buildFirstRow(),
        ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildRows(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFirstRow() {
    var widgets = <Widget>[];

    if (timetablePeriodCountToDisplay == null) return widgets;
    // 左上の空欄
    widgets.add(Container(
      height: 45,
      width: 30,
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(), bottom: BorderSide())),
    ));

    // 時限番号
    for (var n = 1; n <= timetablePeriodCountToDisplay!; n++) {
      widgets.add(Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          width: 30,
          alignment: Alignment.center,
          decoration: const BoxDecoration(border: Border(right: BorderSide())),
          child: Text(
            "$n",
            style: const TextStyle(
                color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
          )));
    }
    return widgets;
  }

  List<Widget> _buildRows() {
    var widgets = <Widget>[];

    if (timetablePeriodCountToDisplay == null) return widgets;

    for (var youbi = 0; youbi <= 5; youbi++) {
      var columnItems = <Widget>[];
      // 曜日テキスト
      columnItems.add(Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
        height: 45,
        // width: constraints.maxWidth,
        // constraints: BoxConstraints(maxWidth: constraints.maxWidth),
        alignment: Alignment.center,
        child: Text(
          getWeekdayString(youbi),
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: youbi == 5 ? Colors.blue : null),
        ),
      ));

      // 時間割
      for (var index = 1; index <= timetablePeriodCountToDisplay!; index++) {
        var key = GlobalKey();
        var cell = table[getWholeIndex(youbi, index)];
        columnItems.add(Padding(
          padding: const EdgeInsets.all(3.0),
          child: GestureDetector(
            onLongPress: cell != null && !widget.edit
                ? () {
              createNewSubmissionForTimetable(
                        context, youbi, cell.subject);
                    Feedback.forLongPress(context);
                  }
                : null,
            child: _buildCellContainer(key, youbi, index, cell),
          ),
        ));
      }

      widgets.add(AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        child: IntrinsicWidth(
          child: Column(
            children: columnItems,
          ),
        ),
      ));
    }
    return widgets;
  }

  Widget _buildCellContainer(
      GlobalKey containerKey, int youbi, int index, db.Timetable? cell) {
    if (widget.edit) {
      return OpenContainer<dynamic>(
        // tappable: widget.edit,
        routeSettings: const RouteSettings(name: "/timetable/edit/select"),
        onClosed: (result) {
          if (result != null) {
            Future.delayed(const Duration(milliseconds: 300)).then((value) {
              onSubjectSelected(result, youbi, index);
            });
          }
        },
        closedColor: Theme.of(context).cardColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        closedBuilder: (_, __) =>
            _buildTimetableCell(containerKey, youbi, index),
        closedElevation: 4,
        openBuilder: (context, callback) => TimetableCellEditPage(
          weekDay: youbi,
          period: index - 1,
          initialData: cell,
        ),
      );
    } else {
      return OpenModalAnimatedContainer(
        context: context,
        tappable: cell != null,
        width: 500,
        height: 200,
        closedBuilder: (context) {
          return _buildTimetableCell(containerKey, youbi, index);
        },
        openBuilder: (context) {
          return _NoteView(
              cell: cell!,
              weekday: youbi,
              index: index,
              createSubmission: createNewSubmissionForTimetable);
        },
      );
    }
  }

  Widget _buildTimetableCell(GlobalKey containerKey, int youbi, int index) {
    var weekday = DateTime.now().weekday;
    var orange = weekday == youbi + 1 && !widget.edit;
    return Material(
      color: orange ? Colors.orange : Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(6),
      elevation: 4,
      child: Container(
        key: containerKey,
        padding: const EdgeInsets.all(8.0),
        height: 44,
        constraints: const BoxConstraints(minWidth: 50),
        alignment: Alignment.center,
        child: Text(
          table.containsKey(getWholeIndex(youbi, index))
              ? table[getWholeIndex(youbi, index)]!.subject
              : "",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: orange ? Colors.white : null,
              ),
        ),
      ),
    );
  }

  void onSubjectSelected(dynamic result, int weekday, int index) {
    updateUndoList();
    if (result == FieldValue.unselect) {
      table.remove(getWholeIndex(weekday, index));
      db.TimetableProvider().use((provider) async {
        await provider.delete(getWholeIndex(weekday, index));
      });
    } else if (result != null) {
      table[getWholeIndex(weekday, index)] = result;

      db.TimetableProvider().use((provider) async {
        provider.writeTransaction(() async {
          await provider
              .putToCurrentTable(table[getWholeIndex(weekday, index)]!);
        });
      });
    }
  }

  void updateUndoList() {
    db.TimetableProvider.undoList.insert(0, Map.from(table));
    db.TimetableProvider.redoList.clear();
    eventBus.fire(UndoRedoUpdatedEvent());
  }

  int getWholeIndex(int youbi, int index) {
    return youbi + (index - 1) * 6;
  }
}

class _NoteView extends StatefulWidget {
  const _NoteView({required this.cell,
      required this.weekday,
      required this.index,
      required this.createSubmission});

  final db.Timetable cell;
  final int weekday;
  final int index;
  final Function(BuildContext context, int youbi, String name) createSubmission;

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<_NoteView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).canvasColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    splashRadius: 24,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.cell.subject,
                          style: const TextStyle(fontSize: 18)),
                      Text(
                          "${getWeekdayString(widget.weekday)}曜日 ${widget.index}時間目",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.meeting_room),
                        Text(widget.cell.room),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        Text(widget.cell.teacher),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: OutlinedButton(
                  child: const Text("この時間割から提出物作成"),
                  onPressed: () {
                    widget.createSubmission(
                        context, widget.weekday, widget.cell.subject);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
