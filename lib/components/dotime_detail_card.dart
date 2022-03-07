import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:submon/utils/ui.dart';

import '../db/dotime.dart';

class DoTimeDetailCard extends StatefulWidget {
  const DoTimeDetailCard(
      {Key? key,
      required this.submissionId,
      required this.doTime,
      this.onDelete,
      this.onEdit,
      this.onTimer})
      : super(key: key);

  final int submissionId;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Card(
        color: widget.doTime.startAt.isBefore(DateTime.now())
            ? Colors.red.withOpacity(0.5).blendedToCardColor(context)
            : null,
        child: Stack(
          children: [
            IntrinsicHeight(
              child: Row(
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
                                      text: widget.doTime.startAt.month
                                          .toString(),
                                      style: const TextStyle(fontSize: 20)),
                                  const TextSpan(
                                      text: "月 ",
                                      style: TextStyle(fontSize: 16)),
                                  TextSpan(
                                      text:
                                          widget.doTime.startAt.day.toString(),
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
                                          .format(widget.doTime.startAt),
                                      style: const TextStyle(fontSize: 20)),
                                  const TextSpan(
                                      text: "〜",
                                      style: TextStyle(fontSize: 16)),
                                ],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                            const SizedBox(width: 16),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: widget.doTime.minute.toString(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700)),
                              const TextSpan(
                                  text: "分",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ])),
                          ],
                        ),
                        const Spacer(),
                        Text(widget.doTime.content,
                            style: const TextStyle(fontSize: 20)),
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
                                title: const Text("編集"),
                                leading: const Icon(Icons.edit),
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onEdit?.call();
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: const ListTile(
                                title: Text("削除"),
                                leading: Icon(Icons.delete),
                              ),
                              onTap: widget.onDelete,
                            ),
                          ];
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
            ),
          ],
        ),
      ),
    );
  }
}
