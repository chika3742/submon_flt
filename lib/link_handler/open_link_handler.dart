import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../events.dart';
import '../isar_db/isar_digestive.dart';
import '../isar_db/isar_submission.dart';
import '../main.dart';
import '../pages/focus_timer_page.dart';
import '../pages/submission_create_page.dart';
import '../pages/submission_detail_page.dart';
import '../utils/ui.dart';

class OpenLinkHandler {
  OpenLinkHandler._();

  static void handle(Uri url) {
    if (FirebaseAuth.instance.currentUser == null) {
      showSnackBar(globalContext!, "ログインする必要があります");
      return;
    }

    switch (url.path.split("/")[1]) {
      case "submission":
        final id = url.queryParameters["id"];
        final uid = url.queryParameters["uid"];

        // Insufficient parameter
        if (id == null || int.tryParse(id) == null) {
          showSnackBar(globalContext!, "不正なパラメーターです。");
          return;
        }
        // UID provided and mismatch
        if (uid != null && uid != FirebaseAuth.instance.currentUser?.uid) {
          showSnackBar(globalContext!, "このアカウントで作成された提出物ではありません。");
          return;
        }
        _openSubmissionDetailPage(int.parse(id));
        break;
      case "submissions":
        final uid = url.queryParameters["uid"];

        // Insufficient parameter
        if (url.pathSegments.length < 2 || int.tryParse(url.pathSegments[1]) == null) {
          showSnackBar(globalContext!, "不正なパラメーターです。");
          return;
        }
        final id = url.pathSegments[1];
        // UID provided and mismatch
        if (uid != null && uid != FirebaseAuth.instance.currentUser?.uid) {
          showSnackBar(globalContext!, "このアカウントで作成された提出物ではありません。");
          return;
        }
        _openSubmissionDetailPage(int.parse(id));
        break;
      case "submission-sharing":
        final title = url.queryParameters["title"];
        final due = DateTime.tryParse(url.queryParameters["date"] ?? "");
        final detail = url.queryParameters["detail"];
        final color = int.tryParse(url.queryParameters["color"] ?? "");

        if (title == null || due == null) {
          showSnackBar(globalContext!, "不正なパラメーターです。");
          return;
        }

        _showSubmissionSharingDialog(
          title: title,
          due: due,
          detail: detail,
          color: color,
        );
        break;
      case "share":
        // v2 sharing link
        if (url.pathSegments.length < 2) {
          showSnackBar(globalContext!, "不正なパラメーターです。");
          return;
        }

        _fetchSubmissionShareLink(url.pathSegments[1]).then((data) {
          if (data == null) {
            return; // Error message already shown in _fetchSubmissionShareLink
          }

          _showSubmissionSharingDialog(
            title: data.title,
            due: data.due,
            detail: data.details,
          );
        }).catchError((e) {
          showSnackBar(globalContext!, "共有リンクの取得に失敗しました。");
          debugPrint("Error fetching submission share link: $e");
        });

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

  static void _openSubmissionDetailPage(int id) {
    Navigator.pushNamed(globalContext!, SubmissionDetailPage.routeName,
        arguments: SubmissionDetailPageArguments(id));
  }

  static Future<({String title, DateTime due, String? details})?> _fetchSubmissionShareLink(String id) async {
    showLoadingModal(globalContext!);
    final getResult = await FirebaseFirestore.instance
        .doc("submissionShares/$id")
        .get();
    Navigator.pop(globalContext!); // Close loading modal
    if (!getResult.exists) {
      showSnackBar(globalContext!, "共有リンクの有効期限が切れているか、間違っています。");
      return null;
    }

    final data = getResult.data()!;
    return (
      title: data["title"] as String,
      due: (data["due"] as Timestamp).toDate(),
      details: data["details"] as String?,
    );
  }

  static void _showSubmissionSharingDialog({required String title, required DateTime due, String? detail, int? color}) {
    showSimpleDialog(
      globalContext!,
      "提出物のシェア",
      "以下の内容で登録します。よろしいですか？\n\n"
          "タイトル: $title\n"
          "期限: ${DateFormat().format(due.toLocal())}\n"
          "${detail != null ? "詳細: $detail" : ""}",
      showCancel: true,
      onOKPressed: () {
        int id = 0;

        SubmissionProvider().use((provider) {
          return provider.writeTransaction(() {
            return provider
                .put(Submission.from(
              title: title,
              due: due.toLocal(),
              details: detail ?? "",
              color: color ?? Colors.white.toARGB32(),
            ))
                .then((id_) {
              id = id_;
            });
          });
        }).then((value) {
          eventBus.fire(SubmissionInserted(id));
          showSnackBar(globalContext!, "作成しました。");
        });
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
