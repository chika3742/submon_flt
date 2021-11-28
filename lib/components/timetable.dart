import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:submon/local_db/shared_prefs.dart';
import 'package:submon/utils/ui.dart';

import 'timetable_subject_select_page.dart';

class Timetable extends StatefulWidget {
  const Timetable({
    Key? key,
    this.edit = false,
    this.table,
    this.onClose,
  }) : super(key: key);

  final bool edit;
  final Map<int, dynamic>? table;
  final Function(int, dynamic)? onClose;

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  int? timetableHour;

  @override
  void initState() {
    super.initState();
    SharedPrefs.use((prefs) {
      setState(() {
        timetableHour = prefs.timetableHour;
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
              children: _buildRows(context),
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
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(), bottom: BorderSide())),
      padding: const EdgeInsets.all(8),
      child: const Opacity(
          opacity: 0, child: Text("0", style: TextStyle(fontSize: 22))),
    ));
    // 時限番号
    for (var n = 1; n <= timetableHour!; n++) {
      widgets.add(Container(
          padding: const EdgeInsets.all(8),
          height: 50,
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

  List<Widget> _buildRows(BuildContext context) {
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
      var weekday = DateTime.now().weekday;
      for (var index = 1; index <= timetableHour!; index++) {
        var key = GlobalKey();
        var cell = widget.table?[getWholeIndex(youbi, index)];
        columnItems.add(Padding(
          padding: const EdgeInsets.all(3.0),
          child: GestureDetector(
            onTap: !widget.edit
                ? () {
                    if (widget.table != null &&
                        widget.table!
                            .containsKey(getWholeIndex(youbi, index))) {
                      // void showSheet() {
                      //   showRoundedBottomSheet(
                      //       context: context,
                      //       title: "${cell.name} (${getWeekdayString(youbi)}曜$index限) メモ",
                      //       children: [
                      //         Opacity(opacity: cell.memo == "" ? 0.8 : 1, child: Text(cell.memo == "" ? "メモはありません" : cell.memo, style: TextStyle(fontSize: 16))),
                      //         Row(
                      //           children: [
                      //             Spacer(),
                      //             OutlinedButton(
                      //               onPressed: () {
                      //                 createNewSubmission(context, youbi, cell.name);
                      //               },
                      //               child: const Text("この科目から提出物作成"),
                      //             ),
                      //             SizedBox(width: 16),
                      //             FloatingActionButton(
                      //               child: Icon(Icons.edit),
                      //               onPressed: () {
                      //                 var ctrler = TextEditingController(text: cell.memo);
                      //                 showRoundedBottomSheet(
                      //                     context: context,
                      //                     title: "${cell.name} (${getWeekdayString(youbi)}曜$index限) メモ編集",
                      //                     children: [
                      //                       TextFormField(
                      //                         controller: ctrler,
                      //                         decoration: InputDecoration(
                      //                           border: OutlineInputBorder(),
                      //                           labelText: "メモ",
                      //                         ),
                      //                       ),
                      //                       Align(
                      //                         alignment: Alignment.bottomRight,
                      //                         child: Padding(
                      //                           padding: const EdgeInsets.symmetric(vertical: 16.0),
                      //                           child: FloatingActionButton(
                      //                             child: Icon(Icons.check),
                      //                             onPressed: () async {
                      //                               MyHomePageState.timetable![(index - 1) * 6 + youbi]!.memo = ctrler.text;
                      //
                      //                               Navigator.pop(context);
                      //                               Navigator.pop(context);
                      //                               showSheet();
                      //
                      //                               getCollection(Collection.timetable).doc("table").update({
                      //                                 "${(index - 1) * 6 + youbi}.memo": ctrler.text
                      //                               });
                      //                             },
                      //                           ),
                      //                         ),
                      //                       )
                      //                     ]
                      //                 );
                      //               },
                      //             ),
                      //           ],
                      //         )
                      //       ]
                      //   );
                      // }
                      // showSheet();
                    }
                  }
                : null,
            onLongPress: cell != null
                ? () {
                    createNewSubmission(context, youbi, cell.name);
                    Feedback.forLongPress(context);
                  }
                : null,
            child: OpenContainer<dynamic>(
              tappable: widget.edit,
              closedColor: Colors.green,
              onClosed: (result) {
                widget.onClose!(getWholeIndex(youbi, index), result);
              },
              closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              closedBuilder: (_, __) => Material(
                color: weekday == youbi + 1 && !widget.edit
                    ? Colors.orange
                    : Colors.green,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  key: key,
                  padding: const EdgeInsets.all(8.0),
                  height: 44,
                  alignment: Alignment.center,
                  child: Text(
                    widget.table != null &&
                            widget.table!
                                .containsKey(getWholeIndex(youbi, index))
                        ? widget.table![getWholeIndex(youbi, index)].name
                        : "---",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              openBuilder: (context, callback) =>
                  TimetableSubjectSelectPage(index, youbi),
            ),
          ),
        ));
      }

      widgets.add(IntrinsicWidth(
        child: Column(
          children: columnItems,
        ),
      ));
    }
    return widgets;
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
    // TODO: これらの値の受け入れ実装
  }
}
