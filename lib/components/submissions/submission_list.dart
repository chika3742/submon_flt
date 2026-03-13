import "dart:async";

import "package:animated_reorderable_list/animated_reorderable_list.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../events.dart";
import "../../isar_db/isar_submission.dart";
import "../../main.dart";
import "../../providers/submission_providers.dart";
import "../../sample_data.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";
import "submission_list_item.dart";

class SubmissionList extends ConsumerStatefulWidget {
  const SubmissionList({super.key, this.done = false});

  final bool done;

  @override
  ConsumerState<SubmissionList> createState() => SubmissionListState();
}

class SubmissionListState extends ConsumerState<SubmissionList> {
  StreamSubscription? _bottomNavSub;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bottomNavSub = eventBus.on<BottomNavDoubleClickEvent>().listen((event) {
      if (event.index == 0) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint);
      }
    });
  }

  @override
  void dispose() {
    _bottomNavSub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncItems = widget.done
        ? ref.watch(doneSubmissionsProvider)
        : ref.watch(undoneSubmissionsProvider);

    final items = screenShotMode
        ? SampleData.submissions
        : switch (asyncItems) {
            AsyncData(:final value) => value,
            _ => null,
          };

    return Stack(
      children: [
        if (items != null)
          AnimatedOpacity(
            opacity: items.isNotEmpty ? 0 : 0.7,
            duration: const Duration(milliseconds: 200),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("提出物がありません", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        if (items != null)
          AnimatedListView(
            controller: _scrollController,
            items: items,
            isSameItem: (a, b) => a.id == b.id,
            itemBuilder: (context, index) {
              final item = items[index];
              return SubmissionListItem(
                item,
                key: ValueKey(item.id),
                onDelete: (_) => _delete(item),
                onDone: (_) => _checkDone(item),
              );
            },
            enterTransition: [SlideInUp()],
            exitTransition: [SlideInUp()],
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),
          ),
      ],
    );
  }

  void _checkDone(Submission item) {
    final repo = ref.read(submissionRepositoryProvider);
    repo.invertDone(item);

    showSnackBar(context, !widget.done ? "完了にしました" : "完了を外しました",
        action: SnackBarAction(
          label: "元に戻す",
          textColor: Colors.pinkAccent,
          onPressed: () {
            repo.invertDone(item);
          },
        ));
  }

  Future<void> _delete(Submission submission) async {
    try {
      final repo = ref.read(submissionRepositoryProvider);
      final restore = await repo.deleteItem(submission.id!);

      if (!mounted) return;
      showSnackBar(context, "削除しました",
          action: SnackBarAction(
            label: "元に戻す",
            textColor: Colors.pinkAccent,
            onPressed: () async {
              await restore();
            },
          ));
    } catch (e, st) {
      recordErrorToCrashlytics(e, st);
      if (mounted) showSnackBar(context, "エラーが発生しました");
    }
  }
}
