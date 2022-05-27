import 'package:animations/animations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:submon/components/submissions/formatted_date_remaining.dart';
import 'package:submon/db/digestive.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/pages/submission_detail_page.dart';
import 'package:submon/utils/dynamic_links.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../digestive_edit_bottom_sheet.dart';

class SubmissionListItem extends StatefulWidget {
  const SubmissionListItem(this.item, {Key? key, this.onDone, this.onDelete})
      : super(key: key);
  final Submission item;
  final Function? onDone;
  final Function? onDelete;

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
          widget.onDone?.call();
          _logMarkedAsDone("swipe");
        } else if (direction == DismissDirection.endToStart) {
          widget.onDelete?.call();
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
            return Material(
              color: _item.color.withOpacity(0.2),
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
                                  child: Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                          text: "${_item.date!.month} / ",
                                          style: const TextStyle(fontSize: 20)),
                                      TextSpan(
                                          text: "${_item.date!.day}",
                                          style: const TextStyle(fontSize: 34)),
                                      TextSpan(
                                          text:
                                              " (${getWeekdayString(_item.date!.weekday - 1)})",
                                          style: const TextStyle(fontSize: 20)),
                                      if (_item.date!.hour != 23 ||
                                          _item.date!.minute != 59)
                                        TextSpan(
                                          text:
                                              " ${DateFormat("HH:mm").format(_item.date!)}",
                                          style: const TextStyle(fontSize: 20),
                                        )
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 4),
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
                                    _item.date!.difference(DateTime.now()),
                                    weekView: _weekView),
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
                          icon: Icon(
                            _item.important ? Icons.star : Icons.star_border,
                            color: _item.important ? Colors.orange : null,
                          ),
                          splashRadius: 22,
                          onPressed: () {
                            toggleImportant();
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
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text("共有"),
                          onTap: () {
                            handleContextMenuAction(_ContextMenuAction.share);
                            FirebaseAnalytics.instance.logShare(
                              contentType: "submission",
                              itemId: widget.item.id.toString(),
                              method: "longPressMenu",
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text("Digestive を追加"),
                          onTap: () {
                            handleContextMenuAction(
                                _ContextMenuAction.addDigestive);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text("編集"),
                          onTap: () {
                            handleContextMenuAction(_ContextMenuAction.edit);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.check),
                          title: const Text("完了にする"),
                          onTap: () {
                            handleContextMenuAction(
                                _ContextMenuAction.makeDone);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text("削除"),
                          onTap: () {
                            handleContextMenuAction(_ContextMenuAction.delete);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          onClosed: (result) {
            SubmissionProvider().use((provider) {
              provider.get(_item.id!).then((value) {
                setState(() {
                  _item = value!;
                });
              });
            });
          },
          openBuilder: (context, cb) => SubmissionDetailPage(widget.item.id!),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  void toggleImportant() {
    setState(() {
      _item.important = !_item.important;
    });
    SubmissionProvider().use((provider) {
      provider.update(_item);
    });
  }

  Future<void> handleContextMenuAction(_ContextMenuAction action) async {
    Navigator.of(context, rootNavigator: true).pop(context);

    switch (action) {
      case _ContextMenuAction.share:
        showLoadingModal(context);

        buildShortDynamicLink("/submission-sharing"
                "?title=${Uri.encodeComponent(widget.item.title)}"
                "&date=${widget.item.date!.toUtc().toIso8601String()}"
                "${widget.item.detail != "" ? "&detail=${Uri.encodeComponent(widget.item.detail)}" : ""}"
                "&color=${widget.item.color.value}")
            .then((link) {
          Share.share(link.shortUrl.toString());
        }).onError((error, stackTrace) {
          showSnackBar(context, "エラーが発生しました。");
          recordErrorToCrashlytics(error, stackTrace);
        }).whenComplete(() {
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pop(context);
          }
        });
        break;

      case _ContextMenuAction.addDigestive:
        var data = await showRoundedBottomSheet<Digestive>(
          context: context,
          useRootNavigator: true,
          title: "Digestive 新規作成",
          child: DigestiveEditBottomSheet(submissionId: widget.item.id),
        );
        if (data != null) {
          DigestiveProvider().use((provider) async {
            await provider.insert(data);
          });
          showSnackBar(context, "作成しました");
        }
        break;
      case _ContextMenuAction.edit:
        Navigator.of(context, rootNavigator: true)
            .pushNamed("/submission/edit", arguments: {
          "submissionId": widget.item.id,
        });
        break;
      case _ContextMenuAction.makeDone:
        widget.onDone?.call();
        _logMarkedAsDone("longPressMenu");
        break;
      case _ContextMenuAction.delete:
        widget.onDelete?.call();
        break;
    }
  }

  void _logMarkedAsDone(String method) {
    if (!widget.item.done) {
      FirebaseAnalytics.instance
          .logEvent(name: "marked_submission_as_done", parameters: {
        "method": method,
      });
    } else {
      FirebaseAnalytics.instance
          .logEvent(name: "unmarked_submission_as_done", parameters: {
        "method": method,
      });
    }
  }
}

enum _ContextMenuAction {
  share,
  addDigestive,
  edit,
  makeDone,
  delete,
}
