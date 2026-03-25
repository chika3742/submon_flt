import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

import "../isar_db/isar_digestive.dart";
import "../pages/focus_timer_page.dart";
import "../providers/digestive_providers.dart";
import "../utils/ui.dart";
import "digestive_edit_bottom_sheet.dart";


class DigestiveDetailCard extends ConsumerStatefulWidget {
  const DigestiveDetailCard({
    super.key,
    required this.digestive,
  });

  final Digestive digestive;

  @override
  ConsumerState<DigestiveDetailCard> createState() =>
      _DigestiveDetailCardState();
}

class _DigestiveDetailCardState extends ConsumerState<DigestiveDetailCard> {
  @override
  Widget build(BuildContext context) {
    final digestive = widget.digestive;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Card(
        color: digestive.startAt.isBefore(DateTime.now()) &&
                digestive.done == false
            ? Colors.red.withValues(alpha: 0.5).blendedToCardColor(context)
            : null,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, bottom: 16.0),
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
                                        .bodyLarge
                                        ?.color
                                        ?.withValues(alpha: 0.7)
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
                              value: 2,
                              child: ListTile(
                                title:
                                    Text(!digestive.done ? "完了にする" : "未完了にする"),
                                leading: const Icon(Icons.check),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 0,
                              child: ListTile(
                                title: Text("編集"),
                                leading: Icon(Icons.edit),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text("削除"),
                                leading: Icon(Icons.delete),
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              _edit();
                            case 1:
                              _delete();
                            case 2:
                              _markDone(!digestive.done);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.timer),
                        splashRadius: 24,
                        padding: EdgeInsets.zero,
                        onPressed: _openTimerPage,
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
                      color: Colors.black.withValues(alpha: 0.3),
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

  Future<void> _markDone(bool done) async {
    final repo = ref.read(digestiveRepositoryProvider);
    await repo.markDone(widget.digestive, done: done);
    if (!mounted) return;
    showSnackBar(context, done ? "完了しました" : "完了マークを外しました",
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () {
            repo.markDone(widget.digestive, done: !done);
          },
        ));
  }

  Future<void> _edit() async {
    final data = await showRoundedBottomSheet<Digestive>(
      context: context,
      useRootNavigator: true,
      title: "編集",
      child: DigestiveEditBottomSheet(
        submissionId: widget.digestive.submissionId,
        initialData: widget.digestive,
      ),
    );
    if (data != null) {
      final repo = ref.read(digestiveRepositoryProvider);
      await repo.update(data);
      if (!mounted) return;
      showSnackBar(context, "編集しました");
    }
  }

  Future<void> _delete() async {
    final repo = ref.read(digestiveRepositoryProvider);
    final restore = await repo.deleteItem(widget.digestive.id!);
    if (!mounted) return;
    showSnackBar(context, "削除しました",
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () {
            restore();
          },
        ));
  }

  Future<void> _openTimerPage([bool force = false]) async {
    if (widget.digestive.done && !force) {
      showSnackBar(context, "このDigestiveは既に完了しています。",
          action: SnackBarAction(
            label: "それでも続ける",
            onPressed: () {
              _openTimerPage(true);
            },
          ));
    } else {
      await FocusTimerPage.openFocusTimer(context, widget.digestive);
    }
  }
}
