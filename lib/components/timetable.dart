import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:submon/components/open_modal_animation.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart' as db;
import 'package:submon/events.dart';
import 'package:submon/pages/timetable_edit_page.dart';
import 'package:submon/utils/ui.dart';

import '../pages/timetable_subject_select_page.dart';

class Timetable extends StatefulWidget {
  const Timetable({
    Key? key,
    this.edit = false,
  }) : super(key: key);

  final bool edit;

  @override
  State<Timetable> createState() => TimetableState();
}

class TimetableState extends State<Timetable> {
  int? timetableHour;
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
        timetableHour = prefs.timetableHour;
      });
    });
  }

  void getTable() {
    db.TimetableProvider().use((provider) async {
      List<db.Timetable> list =
          await (provider as db.TimetableProvider).getCurrentTimetable();

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

    if (timetableHour == null) return widgets;
    // 左上の空欄
    widgets.add(Container(
      height: 45,
      width: 30,
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(), bottom: BorderSide())),
    ));

    // 時限番号
    for (var n = 1; n <= timetableHour!; n++) {
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

    if (timetableHour == null) return widgets;

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
      for (var index = 1; index <= timetableHour!; index++) {
        var key = GlobalKey();
        var cell = table[getWholeIndex(youbi, index)];
        columnItems.add(Padding(
          padding: const EdgeInsets.all(3.0),
          child: GestureDetector(
            onLongPress: cell != null && !widget.edit
                ? () {
                    createNewSubmission(context, youbi, cell.subject);
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
        openBuilder: (context, callback) =>
            TimetableSubjectSelectPage(youbi, index),
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
              createSubmission: createNewSubmission);
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
      table[getWholeIndex(weekday, index)] =
          db.Timetable(cellId: getWholeIndex(weekday, index), subject: result);

      SharedPrefs.use((prefs) {
        var history = prefs.timetableHistory;
        if (history.contains(result)) {
          history.remove(result);
        }
        history.insert(0, result);
        if (history.length > 10) {
          history = history.getRange(0, 10).toList();
        }
        prefs.timetableHistory = history;
      });

      db.TimetableProvider().use((provider) async {
        await provider.insert(db.Timetable(
            cellId: getWholeIndex(weekday, index), subject: result));
      });
    }
  }

  void updateUndoList() {
    db.Timetable.undoList.insert(0, Map.from(table));
    db.Timetable.redoList.clear();
    eventBus.fire(UndoRedoUpdatedEvent());
  }

  int getWholeIndex(int youbi, int index) {
    return youbi + (index - 1) * 6;
  }

  void createNewSubmission(BuildContext context, int youbi, String name) {
    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    DateTime deadline;
    if (now.weekday == youbi + 1) {
      deadline = now.add(const Duration(days: 7));
    } else {
      deadline = now;
      while (deadline.weekday != youbi + 1) {
        deadline = deadline.add(const Duration(days: 1));
      }
    }
    Navigator.of(context, rootNavigator: true)
        .pushNamed("/submission/create", arguments: {
      "initialTitle": name,
      "initialDeadline": deadline,
    });
  }
}

class _NoteView extends StatefulWidget {
  const _NoteView(
      {Key? key,
      required this.cell,
      required this.weekday,
      required this.index,
      required this.createSubmission})
      : super(key: key);

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
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    splashRadius: 24,
                    onPressed: () async {
                      await showRoundedBottomSheet(
                        context: context,
                        title:
                            "${widget.cell.subject} (${getWeekdayString(widget.weekday)}曜 ${widget.index}限) メモ編集",
                        child: TextFormFieldBottomSheet(
                          formLabel: "メモ",
                          onDone: (text) {
                            setState(() {
                              widget.cell.note = text;
                            });
                            db.TimetableProvider().use((provider) async {
                              await provider.update(widget.cell);
                            });
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: widget.cell.note.isNotEmpty
                    ? Text(widget.cell.note)
                    : Text("メモはありません",
                        style: Theme.of(context).textTheme.caption),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
