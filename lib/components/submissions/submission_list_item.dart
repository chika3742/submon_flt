import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

import "../../features/submission/presentation/create_submission_share_link_state_notifier.dart";
import "../../isar_db/isar_digestive.dart";
import "../../isar_db/isar_submission.dart";
import "../../pages/submission_detail_page.dart";
import "../../pages/submission_edit_page.dart";
import "../../providers/digestive_providers.dart";
import "../../providers/firebase_providers.dart";
import "../../utils/analytics.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";
import "../digestive_edit_bottom_sheet.dart";
import "formatted_date_remaining.dart";
import "submission_list_item_bottom_sheet.dart";

class SubmissionListItem extends ConsumerStatefulWidget {
  const SubmissionListItem(
    this.item, {
    super.key,
    this.onDone,
    this.onDelete,
  });
  final Submission item;
  final void Function(bool animated)? onDone;
  final void Function(bool animated)? onDelete;

  @override
  SubmissionListItemState createState() => SubmissionListItemState();
}

class SubmissionListItemState extends ConsumerState<SubmissionListItem> {
  var _weekView = true;
  var _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) {
      return const SizedBox.shrink();
    }

    final item = widget.item;
    return Dismissible(
      key: ObjectKey(item.id),
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
        setState(() {
          _dismissed = true;
        });
        if (direction == DismissDirection.startToEnd) {
          widget.onDone?.call(false);
          logMarkedAsDone(ref.read(analyticsProvider), done: item.done, method: "swipe");
        } else if (direction == DismissDirection.endToStart) {
          widget.onDelete?.call(false);
        }
      },
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        margin: const EdgeInsets.all(8),
        child: OpenContainer<SubmissionDetailPagePopAction>(
          useRootNavigator: true,
          routeSettings: const RouteSettings(name: "/submission/detail"),
          closedColor: Theme.of(context).colorScheme.surface,
          openColor: Theme.of(context).colorScheme.surface,
          closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          closedBuilder: (context, callback) {
            final overdue = item.due.isBefore(DateTime.now());
            return Material(
              color: item.getColor().withValues(alpha: 0.2),
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
                                            ? Colors.black.withValues(alpha: 0.6)
                                            : Colors.white.withValues(alpha: 0.6),
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
                                            item.due
                                                .difference(DateTime.now()),
                                            weekView: _weekView),
                                      ),
                                      if (item.important)
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
                                      text: "${item.due.month}/",
                                      style: const TextStyle(fontSize: 20)),
                                  TextSpan(
                                      text: "${item.due.day}",
                                      style: const TextStyle(fontSize: 28)),
                                  TextSpan(
                                      text:
                                          " (${getWeekdayString(item.due.weekday - 1)})",
                                      style: const TextStyle(fontSize: 20)),
                                  if (item.due.hour != 23 ||
                                      item.due.minute != 59)
                                    TextSpan(
                                      text:
                                          " ${DateFormat("HH:mm").format(item.due)}",
                                      style: const TextStyle(fontSize: 20),
                                    )
                                ],
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontWeight:
                                        overdue ? FontWeight.bold : null,
                                    color: _getDueTextColor())),
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
                              item.title,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(item.done
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
                  ref.read(analyticsProvider)
                      .logEvent(name: "select_item", parameters: {
                    "item_list_name": "submission_list",
                  });
                },
                onLongPress: () async {
                  final action = await showSubmissionListItemBottomSheet(
                    context: context,
                    item: item,
                  );
                  if (action == null) return;
                  await _handleContextMenuAction(action, item);
                },
              ),
            );
          },
          onClosed: (result) async {
            if (!screenShotMode &&
                result == SubmissionDetailPagePopAction.delete) {
              await Future.delayed(const Duration(milliseconds: 300));
              widget.onDelete?.call(true);
            }
          },
          openBuilder: (context, cb) => SubmissionDetailPage(item.id!),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Color _getDueTextColor() {
    if (widget.item.due.isBefore(DateTime.now())) {
      if (Theme.of(context).brightness == Brightness.light) {
        return Colors.redAccent;
      } else {
        return Colors.redAccent.shade200;
      }
    } else {
      return Theme.of(context).textTheme.headlineMedium!.color!;
    }
  }

  Future<void> _handleContextMenuAction(
    SubmissionContextMenuAction action,
    Submission item,
  ) async {
    if (!mounted) return;

    switch (action) {
      case SubmissionContextMenuAction.share:
        ref.read(analyticsProvider).logShare(
          contentType: "submission",
          itemId: item.id.toString(),
          method: "longPressMenu",
        );
        ref.read(createSubmissionShareLinkStateProvider.notifier).execute(item);

      case SubmissionContextMenuAction.addDigestive:
        final data = await showRoundedBottomSheet<Digestive>(
          context: context,
          useRootNavigator: true,
          title: "Digestive 新規作成",
          child: DigestiveEditBottomSheet(submissionId: item.id),
        );
        if (!mounted || data == null) return;
        final repo = ref.read(digestiveRepositoryProvider);
        await repo.create(data);
        if (!mounted) return;
        showSnackBar(context, "作成しました");

      case SubmissionContextMenuAction.edit:
        Navigator.of(context, rootNavigator: true).pushNamed(
          SubmissionEditPage.routeName,
          arguments: SubmissionEditPageArguments(item.id!),
        );

      case SubmissionContextMenuAction.makeDone:
        widget.onDone?.call(true);
        logMarkedAsDone(
          ref.read(analyticsProvider),
          done: item.done,
          method: "longPressMenu",
        );

      case SubmissionContextMenuAction.delete:
        widget.onDelete?.call(true);
    }
  }
}
