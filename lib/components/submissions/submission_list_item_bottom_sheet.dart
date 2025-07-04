import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:submon/firebase/analytics.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/main.dart';

import '../../isar_db/isar_digestive.dart';
import '../../pages/submission_edit_page.dart';
import '../../utils/app_links.dart';
import '../../utils/ui.dart';
import '../../utils/utils.dart';
import '../digestive_edit_bottom_sheet.dart';

class SubmissionListItemBottomSheet extends StatelessWidget {
  const SubmissionListItemBottomSheet({super.key,
      required this.item,
      required this.onDone,
      required this.onDelete});

  final Submission item;
  final Function(bool animated)? onDone;
  final Function(bool animated)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text("共有"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.share);
            FirebaseAnalytics.instance.logShare(
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
            _handleContextMenuAction(_ContextMenuAction.addDigestive);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("編集"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.edit);
          },
        ),
        ListTile(
          leading: const Icon(Icons.check),
          title: const Text("完了にする"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.makeDone);
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text("削除"),
          onTap: () {
            _handleContextMenuAction(_ContextMenuAction.delete);
          },
        ),
      ],
    );
  }

  Future<void> _handleContextMenuAction(_ContextMenuAction action) async {
    Navigator.of(globalContext!, rootNavigator: true).pop();

    switch (action) {
      case _ContextMenuAction.share:
        showLoadingModal(globalContext!);

        try {
          Submission? s_;
          await SubmissionProvider().use((provider) async {
            s_ = await provider.get(item.id!);
          });
          if (s_ == null) {
            showSnackBar(globalContext!, "提出物が見つかりません。");
            return;
          }
          final submission = s_ ?? (throw Exception("This should not happen"));

          var link = await createSubmissionShareLink({
            "title": submission.title,
            "due": submission.due.toUtc().toIso8601String(),
            if (submission.details.isNotEmpty) "details": submission.details,
          });
          await Share.share(link, subject: submission.title);
          showSnackBar(globalContext!, "共有リンクの有効期間は7日間です。");
        } catch (error, stackTrace) {
          showSnackBar(globalContext!, "エラーが発生しました。");
          recordErrorToCrashlytics(error, stackTrace);
        } finally {
          Navigator.of(globalContext!, rootNavigator: true).pop();
        }
        break;

      case _ContextMenuAction.addDigestive:
        var data = await showRoundedBottomSheet<Digestive>(
          context: globalContext!,
          useRootNavigator: true,
          title: "Digestive 新規作成",
          child: DigestiveEditBottomSheet(submissionId: item.id),
        );
        if (data != null) {
          await DigestiveProvider().use((provider) async {
            await provider.writeTransaction(() async {
              await provider.put(data);
            });
          });
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
        AnalyticsHelper.logMarkedAsDone(item.done, "longPressMenu");
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
