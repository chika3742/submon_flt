import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/pages/home_tabs/tab_digestive_list.dart';
import 'package:submon/utils/ui.dart';

import '../db/digestive.dart';
import 'digestive_edit_bottom_sheet.dart';

class DigestiveDetailCard extends StatefulWidget {
  const DigestiveDetailCard({
    Key? key,
    required this.digestive,
    required this.parentList,
    this.onChanged,
  }) : super(key: key);

  final Digestive digestive;
  final List<Digestive> parentList;
  final void Function()? onChanged;

  @override
  _DigestiveDetailCardState createState() => _DigestiveDetailCardState();
}

class _DigestiveDetailCardState extends State<DigestiveDetailCard> {
  @override
  Widget build(BuildContext context) {
    var digestive = widget.digestive;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Card(
        color: digestive.startAt.isBefore(DateTime.now()) &&
                digestive.done == false
            ? Colors.red.withOpacity(0.5).blendedToCardColor(context)
            : null,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                      text: digestive.startAt.month.toString(),
                                      style: const TextStyle(fontSize: 20)),
                                  const TextSpan(
                                      text: "月 ",
                                      style: TextStyle(fontSize: 16)),
                                  TextSpan(
                                      text: digestive.startAt.day.toString(),
                                      style: const TextStyle(fontSize: 20)),
                                  const TextSpan(
                                      text: "日",
                                      style: TextStyle(fontSize: 16)),
                                ],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                            const SizedBox(width: 8),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                      text: DateFormat("H:mm")
                                          .format(digestive.startAt),
                                      style: const TextStyle(fontSize: 20)),
                                  const TextSpan(
                                      text: "から",
                                      style: TextStyle(fontSize: 16)),
                                ],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                            const SizedBox(width: 16),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: digestive.minute.toString(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              const TextSpan(
                                  text: "分間",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ])),
                          ],
                        ),
                        const Spacer(),
                        Text(digestive.content,
                            style: TextStyle(
                                fontSize: 20,
                                decoration: digestive.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: digestive.done
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color
                                        ?.withOpacity(0.7)
                                    : null)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      PopupMenuButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 24,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: ListTile(
                                title:
                                    Text(!digestive.done ? "完了にする" : "未完了にする"),
                                leading: const Icon(Icons.check),
                              ),
                              value: 2,
                            ),
                            const PopupMenuItem(
                              child: ListTile(
                                title: Text("編集"),
                                leading: Icon(Icons.edit),
                              ),
                              value: 0,
                            ),
                            const PopupMenuItem(
                              child: ListTile(
                                title: Text("削除"),
                                leading: Icon(Icons.delete),
                              ),
                              value: 1,
                            ),
                          ];
                        },
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              edit();
                              break;
                            case 1:
                              delete();
                              break;
                            case 2:
                              done();
                              break;
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.timer),
                        splashRadius: 24,
                        padding: EdgeInsets.zero,
                        onPressed: openTimerPage,
                      ),
                    ],
                  ),
                ],
              ),
              if (digestive.done)
                IgnorePointer(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void done() async {
    var isDone = widget.digestive.done;
    await DigestiveProvider().use((provider) async {
      await provider.insert(widget.digestive..done = !isDone);
    });
    setState(() {});
    if (!isDone) {
      FirestoreProvider.removeDigestiveNotification(widget.digestive.id);
    } else {
      FirestoreProvider.addDigestiveNotification(widget.digestive.id);
    }
    showSnackBar(context, !isDone ? "完了しました" : "完了マークを外しました",
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () {
            DigestiveProvider().use((provider) async {
              await provider.insert(widget.digestive..done = isDone);
              setState(() {});
            });
          },
        ));
  }

  void edit() async {
    var data = await showRoundedBottomSheet<Digestive>(
      context: context,
      useRootNavigator: true,
      title: "編集",
      child: DigestiveEditBottomSheet(
        submissionId: widget.digestive.submissionId,
        initialData: widget.digestive,
      ),
    );
    if (data != null) {
      await DigestiveProvider().use((provider) async {
        await provider.insert(data);
      });

      var index = widget.parentList
          .indexWhere((element) => element.id == widget.digestive.id);
      if (widget.parentList is List<DigestiveWithSubmission>) {
        widget.parentList[index] = DigestiveWithSubmission.fromObject(data,
            (widget.parentList[index] as DigestiveWithSubmission).submission);
      } else {
        widget.parentList[index] = data;
      }

      widget.onChanged?.call();
      showSnackBar(context, "編集しました");
    }
  }

  void delete() async {
    await DigestiveProvider().use((provider) async {
      await provider.delete(widget.digestive.id!);
    });
    var removedIndex = widget.parentList.indexOf(widget.digestive);
    var removed = widget.parentList.removeAt(removedIndex);
    widget.onChanged?.call();

    showSnackBar(context, "削除しました",
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () {
            DigestiveProvider().use((provider) async {
              await provider.insert(widget.digestive);
            });

            if (removedIndex > widget.parentList.length) {
              removedIndex = widget.parentList.length;
            }
            widget.parentList.insert(removedIndex, removed);
            widget.onChanged?.call();
          },
        ));
  }

  void openTimerPage() async {
    var result = await Navigator.of(context, rootNavigator: true)
        .pushNamed("/focus-timer", arguments: {
      "digestive": widget.digestive,
    });
    if (result == true) {
      done();
    }
  }
}
