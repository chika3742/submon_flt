import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:share_plus/share_plus.dart";

import "../../isar_db/isar_digestive.dart";
import "../../isar_db/isar_submission.dart";
import "../../main.dart";
import "../../pages/submission_edit_page.dart";
import "../../providers/core_providers.dart";
import "../../providers/digestive_providers.dart";
import "../../providers/functions_service.dart";
import "../../providers/submission_providers.dart";
import "../../utils/analytics.dart";
import "../../utils/ui.dart";
import "../digestive_edit_bottom_sheet.dart";

class SubmissionListItemBottomSheet extends ConsumerWidget {
  const SubmissionListItemBottomSheet({super.key,
      required this.item,
      required this.onDone,
      required this.onDelete});

  final Submission item;
  final Function(bool animated)? onDone;
  final Function(bool animated)? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text("共有"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.share, ref);
            ref.read(analyticsProvider).logShare(
              contentType: "submission",
              itemId: item.id.toString(),
              method: "longPressMenu",
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Digestive を追加"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.addDigestive, ref);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("編集"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.edit, ref);
          },
        ),
        ListTile(
          leading: const Icon(Icons.check),
          title: const Text("完了にする"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.makeDone, ref);
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text("削除"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.delete, ref);
          },
        ),
      ],
    );
  }

  Future<void> _handleContextMenuAction(
      _ContextMenuAction action, WidgetRef ref) async {
    Navigator.of(globalContext!, rootNavigator: true).pop();

    switch (action) {
      case _ContextMenuAction.share:
        showLoadingModal(globalContext!);

        try {
          final repo = ref.read(submissionRepositoryProvider);
          final submission = await repo.get(item.id!);
          if (submission == null) {
            showSnackBar(globalContext!, "提出物が見つかりません。");
            return;
          }

          final link = await ref.read(functionsServiceProvider).createShareLink(
            FunctionsService.submissionToShareLinkData(submission),
          );
          await SharePlus.instance.share(ShareParams(
            text: "提出物「${submission.title}」が共有されました。Submonで開いてみよう！\n"
                "$link"
          ));
          showSnackBar(globalContext!, "共有リンクの有効期間は7日間です。");
        } catch (error, stackTrace) {
          showSnackBar(globalContext!, "エラーが発生しました。");
          ref.read(crashlyticsProvider).recordError(error, stackTrace);
        } finally {
          Navigator.of(globalContext!, rootNavigator: true).pop();
        }
        break;

      case _ContextMenuAction.addDigestive:
        final data = await showRoundedBottomSheet<Digestive>(
          context: globalContext!,
          useRootNavigator: true,
          title: "Digestive 新規作成",
          child: DigestiveEditBottomSheet(submissionId: item.id),
        );
        if (data != null) {
          final repo = ref.read(digestiveRepositoryProvider);
          await repo.create(data);
          showSnackBar(globalContext!, "作成しました");
        }
        break;
      case _ContextMenuAction.edit:
        Navigator.of(globalContext!, rootNavigator: true).pushNamed(
            SubmissionEditPage.routeName,
            arguments: SubmissionEditPageArguments(item.id!));
        break;
      case _ContextMenuAction.makeDone:
        onDone?.call(true);
        logMarkedAsDone(ref.read(analyticsProvider), done: item.done, method: "longPressMenu");
        break;
      case _ContextMenuAction.delete:
        onDelete?.call(true);
        break;
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
