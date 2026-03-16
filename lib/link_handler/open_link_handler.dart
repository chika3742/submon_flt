import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

import "../isar_db/isar_submission.dart";
import "../pages/focus_timer_page.dart";
import "../pages/submission_create_page.dart";
import "../pages/submission_detail_page.dart";
import "../providers/core_providers.dart";
import "../providers/digestive_providers.dart";
import "../providers/submission_providers.dart";
import "../providers/submission_share_link_provider.dart";
import "../utils/ui.dart";

void handleOpenLink(
  BuildContext context,
  WidgetRef ref,
  Uri url, {
  required void Function(String tabName) onSwitchTab,
}) {
  final currentUser = ref.read(firebaseUserProvider).value;
  if (currentUser == null) {
    showSnackBar(context, "ログインする必要があります");
    return;
  }

  switch (url.path.split("/")[1]) {
    case "submission":
      final id = url.queryParameters["id"];
      final uid = url.queryParameters["uid"];

      if (id == null || int.tryParse(id) == null) {
        showSnackBar(context, "不正なパラメーターです。");
        return;
      }
      if (uid != null && uid != currentUser.uid) {
        showSnackBar(context, "このアカウントで作成された提出物ではありません。");
        return;
      }
      _openSubmissionDetailPage(context, int.parse(id));
      break;
    case "submissions":
      final uid = url.queryParameters["uid"];

      if (url.pathSegments.length < 2 ||
          int.tryParse(url.pathSegments[1]) == null) {
        showSnackBar(context, "不正なパラメーターです。");
        return;
      }
      final id = url.pathSegments[1];
      if (uid != null && uid != currentUser.uid) {
        showSnackBar(context, "このアカウントで作成された提出物ではありません。");
        return;
      }
      _openSubmissionDetailPage(context, int.parse(id));
      break;
    case "share":
      if (url.pathSegments.length < 2) {
        showSnackBar(context, "不正なパラメーターです。");
        return;
      }

      showLoadingModal(context);
      ref
          .read(submissionShareLinkProvider(url.pathSegments[1]).future)
          .then((data) {
        if (!context.mounted) return;
        Navigator.pop(context);
        if (data == null) {
          showSnackBar(context, "共有リンクの有効期限が切れているか、間違っています。");
          return;
        }
        _showSubmissionSharingDialog(
          context,
          ref,
          title: data.title,
          due: data.due,
          detail: data.details,
        );
      }).catchError((e) {
        if (context.mounted) {
          Navigator.pop(context);
          showSnackBar(context, "共有リンクの取得に失敗しました。");
        }
        debugPrint("Error fetching submission share link: $e");
      });

      break;
    case "create-submission":
      _openCreateSubmissionPage(context);
      break;
    case "focus-timer":
      _openFocusTimer(context, ref, url);
      break;
    case "tab":
      if (url.pathSegments.length >= 2) {
        onSwitchTab(url.pathSegments[1]);
      }
      break;
  }
}

void _openSubmissionDetailPage(BuildContext context, int id) {
  Navigator.pushNamed(context, SubmissionDetailPage.routeName,
      arguments: SubmissionDetailPageArguments(id));
}

void _showSubmissionSharingDialog(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required DateTime due,
  String? detail,
  int? color,
}) {
  showSimpleDialog(
    context,
    "提出物のシェア",
    "以下の内容で登録します。よろしいですか？\n\n"
        "タイトル: $title\n"
        "期限: ${DateFormat().format(due.toLocal())}\n"
        "${detail != null ? "詳細: $detail" : ""}",
    showCancel: true,
    onOKPressed: () {
      if (!ref.context.mounted) return;
      ref
          .read(submissionRepositoryProvider)
          .create(Submission.from(
            title: title,
            due: due.toLocal(),
            details: detail ?? "",
            color: color ?? Colors.white.toARGB32(),
          ))
          .then((_) {
        if (context.mounted) {
          showSnackBar(context, "作成しました。");
        }
      });
    },
  );
}

void _openCreateSubmissionPage(BuildContext context) {
  Navigator.pushNamed(
    context,
    CreateSubmissionPage.routeName,
    arguments: CreateSubmissionPageArguments(),
  );
}

void _openFocusTimer(BuildContext context, WidgetRef ref, Uri url) {
  final digestiveId = int.parse(url.queryParameters["digestiveId"]!);
  ref.read(digestiveRepositoryProvider).get(digestiveId).then((digestive) {
    if (!context.mounted) return;
    if (digestive != null) {
      FocusTimerPage.openFocusTimer(context, digestive);
    } else {
      showSnackBar(context, "このDigestiveはすでに削除されています");
    }
  });
}
