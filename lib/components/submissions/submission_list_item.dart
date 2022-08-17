import 'dart:async';

import 'package:animations/animations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/submissions/formatted_date_remaining.dart';
import 'package:submon/components/submissions/submission_list_item_bottom_sheet.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/firebase/analytics.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/pages/submission_detail_page.dart';
import 'package:submon/utils/ui.dart';

class SubmissionListItem extends StatefulWidget {
  const SubmissionListItem(this.item,
      {Key? key, this.onDone, this.onDelete, this.prefs})
      : super(key: key);
  final Submission item;
  final void Function(bool animated)? onDone;
  final void Function(bool animated)? onDelete;
  final SharedPrefs? prefs;

  @override
  SubmissionListItemState createState() => SubmissionListItemState();
}

class SubmissionListItemState extends State<SubmissionListItem> {
  var _weekView = true;
  late Submission _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(_item.id),
      secondaryBackground: Container(
        color: Colors.redAccent,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 32),
            child: Icon(Icons.delete),
          ),
        ),
      ),
      background: Container(
        color: Colors.greenAccent,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 32),
            child: Icon(Icons.check),
          ),
        ),
      ),
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onDone?.call(false);
          AnalyticsHelper.logMarkedAsDone(widget.item.done, "swipe");
        } else if (direction == DismissDirection.endToStart) {
          widget.onDelete?.call(false);
        }
      },
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        margin: const EdgeInsets.all(8),
        child: OpenContainer(
          useRootNavigator: true,
          routeSettings: const RouteSettings(name: "/submission/detail"),
          closedColor: Theme.of(context).cardColor,
          closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          closedBuilder: (context, callback) {
            var overdue = widget.item.due.isBefore(DateTime.now());
            return Material(
              color: _item.getColorToDisplay(widget.prefs).withOpacity(0.2),
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRect(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            heightFactor: 1,
                            widthFactor: 1,
                            child: Container(
                              transform: Matrix4.translationValues(-3, -3, 0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(16)),
                                    border: Border.all(
                                        color: Theme.of(context).brightness ==
                                            Brightness.light
                                            ? Colors.black.withOpacity(0.6)
                                            : Colors.white.withOpacity(0.6),
                                        width: 3)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 12),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _weekView = !_weekView;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(4),
                                        child: FormattedDateRemaining(
                                            _item.due
                                                .difference(DateTime.now()),
                                            weekView: _weekView),
                                      ),
                                      if (_item.important)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.star,
                                              color: Colors.orange),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                      text: "${_item.due.month}/",
                                      style: const TextStyle(fontSize: 20)),
                                  TextSpan(
                                      text: "${_item.due.day}",
                                      style: const TextStyle(fontSize: 28)),
                                  TextSpan(
                                      text:
                                          " (${getWeekdayString(_item.due.weekday - 1)})",
                                      style: const TextStyle(fontSize: 20)),
                                  if (_item.due.hour != 23 ||
                                      _item.due.minute != 59)
                                    TextSpan(
                                      text:
                                          " ${DateFormat("HH:mm").format(_item.due)}",
                                      style: const TextStyle(fontSize: 20),
                                    )
                                ],
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontWeight:
                                        overdue ? FontWeight.bold : null,
                                    color: getDueTextColor())),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 8, right: 8),
                            child: Text(
                              _item.title,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(widget.item.done
                              ? Icons.done_outline
                              : Icons.done),
                          splashRadius: 22,
                          onPressed: () {
                            widget.onDone?.call(true);
                          },
                        )
                      ],
                    )
                  ],
                ),
                onTap: () {
                  callback();
                  FirebaseAnalytics.instance
                      .logSelectItem(itemListName: "submission_list");
                },
                onLongPress: () {
                  showRoundedBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    child: SubmissionListItemBottomSheet(
                      item: widget.item,
                      onDone: widget.onDone,
                      onDelete: widget.onDelete,
                    ),
                  );
                },
              ),
            );
          },
          onClosed: (result) {
            SubmissionProvider().use((provider) async {
              await provider.get(_item.id!).then((obj) {
                if (obj != null) {
                  setState(() {
                    _item = obj;
                  });
                } else {
                  Timer(const Duration(milliseconds: 300), () {
                    widget.onDelete?.call(true);
                  });
                }
              });
            });
          },
          openBuilder: (context, cb) => SubmissionDetailPage(widget.item.id!),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Color getDueTextColor() {
    if (widget.item.due.isBefore(DateTime.now())) {
      if (Theme
          .of(context)
          .brightness == Brightness.light) {
        return Colors.redAccent;
      } else {
        return Colors.redAccent.shade200;
      }
    } else {
      return Theme
          .of(context)
          .textTheme
          .headlineMedium!
          .color!;
    }
  }

  void toggleImportant() {
    setState(() {
      _item.important = !_item.important;
    });
    SubmissionProvider().use((provider) {
      return provider.writeTransaction(() async {
        await provider.put(_item);
      });
    });
  }

}
