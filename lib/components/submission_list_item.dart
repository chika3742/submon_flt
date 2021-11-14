import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:submon/local_db/submission.dart';
import 'package:submon/pages/submission_detail_page.dart';
import 'package:submon/utils.dart';

class SubmissionListItem extends StatefulWidget {
  const SubmissionListItem(this.item, {Key? key, this.onDone, this.onDelete, this.onToggleImportant}) : super(key: key);
  final Submission item;
  final Function? onDone;
  final Function? onDelete;
  final Function? onToggleImportant;

  @override
  _SubmissionListItemState createState() => _SubmissionListItemState();
}

class _SubmissionListItemState extends State<SubmissionListItem> {
  var _weekView = true;

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return Dismissible(
      key: UniqueKey(),
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
          widget.onDone?.call();
        } else if (direction == DismissDirection.endToStart) {
          widget.onDelete?.call();
        }
      },
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: OpenContainer(
          useRootNavigator: true,
          closedColor: Theme.of(context).cardColor,
          closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          closedBuilder: (context, callback) {
            var remainingDate = item.date!.difference(DateTime.now()).inDays;
            var weekViewString = getRemainingString(remainingDate).split(" ");
            return Material(
              color: item.color!.withOpacity(0.2),
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
                                            ? Colors.black : Colors.white,
                                        width: 3)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                  child: Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                          text: "${item.date!.month} / ",
                                          style: const TextStyle(fontSize: 20)),
                                      TextSpan(
                                          text: "${item.date!.day}",
                                          style: const TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: " (${getWeekdayString(item.date!.weekday - 1)})",
                                          style: const TextStyle(fontSize: 20)),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _weekView = !_weekView;
                                  });
                                },
                                child: Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                        text:
                                        _weekView ? weekViewString[0] :"$remainingDate",
                                        style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            color: getRemainingDateColor(remainingDate))),
                                    TextSpan(
                                        text: _weekView ? weekViewString[1] : "日", style: const TextStyle(fontSize: 18))
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(Icons.schedule),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            item.important ? Icons.star : Icons.star_border,
                            color: item.important ? Colors.orange : null,
                          ),
                          onPressed: () {
                            widget.onToggleImportant?.call();
                          },
                        )
                      ],
                    )
                  ],
                ),
                onTap: () {
                  callback();
                },
              ),
            );
          },
          openBuilder: (context, cb) => const SubmissionDetailPage(),
          transitionDuration: const Duration(milliseconds: 300),
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}