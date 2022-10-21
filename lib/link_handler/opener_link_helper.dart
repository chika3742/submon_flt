import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../events.dart';
import '../isar_db/isar_digestive.dart';
import '../isar_db/isar_submission.dart';
import '../main.dart';
import '../pages/focus_timer_page.dart';
import '../pages/submission_create_page.dart';
import '../pages/submission_detail_page.dart';
import '../utils/ui.dart';

class OpenerLinkHelper {
  OpenerLinkHelper._();

  static void handle(Uri url) {
    if (FirebaseAuth.instance.currentUser == null) {
      showSnackBar(globalContext!, "ログインする必要があります");
      return;
    }

    switch (url.path.split("/")[1]) {
      case "submission":
        _openSubmissionDetailPage(url);
        break;
      case "submission-sharing":
        _showSubmissionSharingDialog(url);
        break;
      case "create-submission":
        _openCreateSubmissionPage();
        break;
      case "focus-timer":
        _openFocusTimer(url);
        break;
      case "tab":
        _setDefaultTab(url);
        break;
    }
  }

  static void _openSubmissionDetailPage(Uri url) {
    var id = url.queryParameters["id"];
    var uid = url.queryParameters["uid"];

    // Insufficient parameter
    if (id == null) {
      showSnackBar(globalContext!, "パラメーターが不足しています。");
      return;
    }
    // UID provided and mismatch
    if (uid != null && uid != FirebaseAuth.instance.currentUser?.uid) {
      showSnackBar(globalContext!, "このアカウントで作成された提出物ではありません。");
      return;
    }
    // ID is not integer
    if (int.tryParse(id) == null) {
      showSnackBar(globalContext!, "idが整数ではありません");
      return;
    }

    Navigator.pushNamed(globalContext!, SubmissionDetailPage.routeName,
        arguments: SubmissionDetailPageArguments(int.parse(id)));
  }

  static void _showSubmissionSharingDialog(Uri url) {
    var title = url.queryParameters["title"];
    var date = url.queryParameters["date"];
    var detail = url.queryParameters["detail"] ?? "";
    var color = url.queryParameters["color"];

    if (title == null || date == null || color == null) {
      showSnackBar(globalContext!, "パラメーターが不足しています。");
      return;
    }

    showSimpleDialog(
      globalContext!,
      "提出物のシェア",
      "以下の内容で登録します。よろしいですか？\n\n"
          "タイトル: $title\n"
          "期限: ${DateTime.parse(date).toLocal().toString()}\n"
          "詳細: $detail",
      showCancel: true,
      onOKPressed: () async {
        await SubmissionProvider().use((provider) async {
          provider.writeTransaction(() async {
            var id = await provider.put(Submission.from(
              title: title,
              due: DateTime.parse(date).toLocal(),
              details: detail,
              color: Color(int.parse(color)),
            ));
            eventBus.fire(SubmissionInserted(id));
          });
        });
        showSnackBar(globalContext!, "作成しました。");
      },
    );
  }

  static void _openCreateSubmissionPage() {
    Navigator.pushNamed(globalContext!, CreateSubmissionPage.routeName,
            arguments: CreateSubmissionPageArguments())
        .then((insertedId) {
      if (insertedId != null) {
        eventBus.fire(SubmissionInserted(insertedId as int));
      }
    });
  }

  static void _openFocusTimer(Uri url) {
    DigestiveProvider().use((provider) async {
      var digestive =
          await provider.get(int.parse(url.queryParameters["digestiveId"]!));
      if (digestive != null) {
        FocusTimerPage.openFocusTimer(globalContext!, digestive);
      } else {
        showSnackBar(globalContext!, "このDigestiveはすでに削除されています");
      }
    });
  }

  static void _setDefaultTab(Uri url) {
    eventBus.fire(SwitchBottomNav(url.path.split("/")[2]));
  }
}
