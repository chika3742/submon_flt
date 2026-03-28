import "package:animated_reorderable_list/animated_reorderable_list.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:share_plus/share_plus.dart";

import "../../core/extensions/async_value_ui.dart";
import "../../features/submission/presentation/create_submission_share_link_state_notifier.dart";
import "../../features/submission/use_cases/delete_submission_use_case.dart";
import "../../isar_db/isar_submission.dart";
import "../../providers/firebase_providers.dart";
import "../../providers/submission_providers.dart";
import "../../sample_data.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";
import "submission_list_item.dart";

class SubmissionList extends ConsumerStatefulWidget {
  const SubmissionList({super.key, this.done = false});

  final bool done;

  @override
  ConsumerState<SubmissionList> createState() => _SubmissionListState();
}

class _SubmissionListState extends ConsumerState<SubmissionList> {
  // Stores a stable UniqueKey per item.id. Cleared on every transition so
  // the re-entering item always gets a fresh key, avoiding
  // _MotionBuilderItemGlobalKey conflicts during exit animations.
  final _itemKeys = <int, Key>{};

  @override
  Widget build(BuildContext context) {
    ref.listen(createSubmissionShareLinkStateProvider, (_, next) async {
      next.showLoadingModalDuringLoading(context);
      next.showSnackBarOnError(context, "共有リンクの作成に失敗しました");
      if (next case AsyncData(value: (:final url, :final title))) {
        await SharePlus.instance.share(ShareParams(
          text: "提出物「$title」が共有されました。Submonで開いてみよう！\n"
              "$url",
        ));
        if (context.mounted) showSnackBar(context, "共有リンクの有効期間は7日間です。");
      }
    });

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
            items: items,
            isSameItem: (a, b) => a.id == b.id,
            itemBuilder: (context, index) {
              final item = items[index];
              return SubmissionListItem(
                item,
                key: _itemKeys.putIfAbsent(item.id!, UniqueKey.new),
                onDelete: (_) => _delete(context, item),
                onDone: (_) => _checkDone(context, item),
              );
            },
            enterTransition: [SlideInUp(curve: Curves.easeOutQuint)],
            exitTransition: [SlideInUp(curve: Curves.easeInQuint)],
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),
          ),
      ],
    );
  }

  void _checkDone(BuildContext context, Submission item) {
    final repo = ref.read(submissionRepositoryProvider);
    repo.invertDone(item);

    showSnackBar(context, !widget.done ? "完了にしました" : "完了を外しました",
        action: SnackBarAction(
          label: "元に戻す",
          textColor: Colors.pinkAccent,
          onPressed: () {
            if (!mounted) return;
            // Reset key before re-entry so the new widget gets a fresh
            // UniqueKey, avoiding _MotionBuilderItemGlobalKey conflicts
            // with any still-running exit animation.
            setState(() => _itemKeys.remove(item.id));
            repo.invertDone(item);
          },
        ));
  }

  Future<void> _delete(
    BuildContext context,
    Submission submission,
  ) async {
    try {
      final deleteSubmission = ref.read(deleteSubmissionUseCaseProvider);
      final restore = await deleteSubmission.execute(submission.id!);

      if (!context.mounted) return;
      showSnackBar(context, "削除しました",
          action: SnackBarAction(
            label: "元に戻す",
            textColor: Colors.pinkAccent,
            onPressed: () async {
              if (!mounted) return;
              setState(() => _itemKeys.remove(submission.id));
              await restore();
            },
          ));
    } catch (e, st) {
      ref.read(crashlyticsProvider).recordError(e, st);
      if (context.mounted) showSnackBar(context, "エラーが発生しました");
    }
  }
}
