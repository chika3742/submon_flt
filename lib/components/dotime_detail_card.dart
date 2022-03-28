import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/utils/ui.dart';

import '../db/doTime.dart';

class DoTimeDetailCard extends StatefulWidget {
  const DoTimeDetailCard(
      {Key? key,
      required this.doTime,
      this.onDelete,
      this.onEdit,
      this.onTimer})
      : super(key: key);

  final DoTime doTime;
  final void Function()? onDelete;
  final void Function()? onEdit;
  final void Function()? onTimer;

  @override
  _DoTimeDetailCardState createState() => _DoTimeDetailCardState();
}

class _DoTimeDetailCardState extends State<DoTimeDetailCard> {
  @override
  Widget build(BuildContext context) {
    var doTime = widget.doTime;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Card(
        color: doTime.startAt.isBefore(DateTime.now())
            ? Colors.red.withOpacity(0.5).blendedToCardColor(context)
            : null,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              if (doTime.done)
                const Align(
                  alignment: Alignment.center,
                  child:
                      Opacity(opacity: 0.7, child: Icon(Icons.check, size: 96)),
                ),
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
                                      text: doTime.startAt.month.toString(),
                                      style: const TextStyle(fontSize: 20)),
                                  const TextSpan(
                                      text: "月 ",
                                      style: TextStyle(fontSize: 16)),
                                  TextSpan(
                                      text: doTime.startAt.day.toString(),
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
                                          .format(doTime.startAt),
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
                                  text: doTime.minute.toString(),
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
                        Text(doTime.content,
                            style: TextStyle(
                                fontSize: 20,
                                decoration: doTime.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: doTime.done
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
                          return const [
                            PopupMenuItem(
                              child: ListTile(
                                title: Text("編集"),
                                leading: Icon(Icons.edit),
                              ),
                              value: 0,
                            ),
                            PopupMenuItem(
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
                              widget.onEdit?.call();
                              break;
                            case 1:
                              widget.onDelete?.call();
                              break;
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.timer),
                        splashRadius: 24,
                        padding: EdgeInsets.zero,
                        onPressed: widget.onTimer,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
