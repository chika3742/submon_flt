import "package:flutter/material.dart";

import "../../isar_db/isar_submission.dart";
import "../../utils/ui.dart";

enum SubmissionContextMenuAction {
  share,
  addDigestive,
  edit,
  makeDone,
  delete,
}

Future<SubmissionContextMenuAction?> showSubmissionListItemBottomSheet({
  required BuildContext context,
  required Submission item,
}) {
  return showRoundedBottomSheet<SubmissionContextMenuAction>(
    context: context,
    useRootNavigator: true,
    child: _SubmissionListItemBottomSheet(item: item),
  );
}

class _SubmissionListItemBottomSheet extends StatelessWidget {
  const _SubmissionListItemBottomSheet({required this.item});

  final Submission item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text("共有"),
          onTap: () =>
              Navigator.pop(context, SubmissionContextMenuAction.share),
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Digestive を追加"),
          onTap: () =>
              Navigator.pop(context, SubmissionContextMenuAction.addDigestive),
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("編集"),
          onTap: () =>
              Navigator.pop(context, SubmissionContextMenuAction.edit),
        ),
        ListTile(
          leading: const Icon(Icons.check),
          title: const Text("完了にする"),
          onTap: () =>
              Navigator.pop(context, SubmissionContextMenuAction.makeDone),
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text("削除"),
          onTap: () =>
              Navigator.pop(context, SubmissionContextMenuAction.delete),
        ),
      ],
    );
  }
}
