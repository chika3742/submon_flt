import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/dotime_detail_card.dart';
import 'package:submon/db/doTime.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/events.dart';

import '../../components/dotime_edit_bottom_sheet.dart';
import '../../utils/ui.dart';

class TabDoTimeList extends StatefulWidget {
  const TabDoTimeList({Key? key}) : super(key: key);

  @override
  State<TabDoTimeList> createState() => _TabDoTimeListState();
}

class _TabDoTimeListState extends State<TabDoTimeList> {
  StreamSubscription? listener;

  List<DoTimeWithSubmission> _doTimeList = [];

  @override
  void initState() {
    DoTimeProvider().use((provider) async {
      var submissionProvider = SubmissionProvider();
      submissionProvider.db = provider.db;
      var doTimeList = await provider.getAll(where: "$colDone = 0");
      _doTimeList = await Future.wait(doTimeList.map((e) async {
        var submission = e.submissionId != null
            ? await submissionProvider.get(e.submissionId!)
            : null;
        return DoTimeWithSubmission.fromObject(e, submission);
      }).toList());
      setState(() {});
    });

    listener = eventBus.on<DoTimeAddButtonPressed>().listen((event) async {
      var result = await showRoundedBottomSheet<DoTime>(
          context: context,
          useRootNavigator: true,
          title: "DoTime単体作成 (提出物なし)",
          child: const DoTimeEditBottomSheet(
            submissionId: null,
          ));

      if (result != null) {
        DoTimeProvider().use((provider) async {
          var data = await provider.insert(result);
          setState(() {
            _doTimeList.add(DoTimeWithSubmission.fromObject(data, null));
          });
        });
        showSnackBar(context, "作成しました");
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    int? prevSubmissionId;

    for (var i in _doTimeList.asMap().keys) {
      var e = _doTimeList[i];
      if (e.submissionId != prevSubmissionId) {
        widgets.add(i != 0
            ? const Divider(
                thickness: 2,
                indent: 16,
                endIndent: 16,
              )
            : const SizedBox(
                height: 8,
              ));
        var diff = e.submission?.date?.difference(DateTime.now());
        var remainingString =
            diff != null ? getRemainingString(diff, false) : null;
        if (e.submission != null) {
          widgets.add(Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 100,
                  child: Text(
                    e.submission!.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
                const SizedBox(width: 8),
                Text.rich(TextSpan(
                    text:
                        "${DateFormat("M/d (E)", "ja").format(e.submission!.date!)}・あと ",
                    children: [
                      TextSpan(
                          text: remainingString![0],
                          style: TextStyle(
                            color:
                                getRemainingDateColor(context, diff!.inHours),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                        text: remainingString[1],
                      ),
                    ])),
              ],
            ),
          ));
        }
      }
      prevSubmissionId = e.submissionId;

      widgets.add(DoTimeDetailCard(
        doTime: e,
        parentList: _doTimeList,
        onChanged: () {
          setState(() {});
        },
      ));
    }
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: widgets,
          ),
        ),
        if (_doTimeList.isEmpty) const Center(child: Text('DoTimeがありません')),
      ],
    );
  }
}

class DoTimeWithSubmission extends DoTime {
  final Submission? submission;

  DoTimeWithSubmission(
      {required int id,
      required int? submissionId,
      required DateTime startAt,
      required int minute,
      required String content,
      required bool done,
      required this.submission})
      : super(
          id: id,
    submissionId: submissionId,
    startAt: startAt,
    minute: minute,
    content: content,
    done: done,
  );

  static DoTimeWithSubmission fromObject(
      DoTime doTime, Submission? submission) {
    return DoTimeWithSubmission(
      id: doTime.id!,
      submissionId: doTime.submissionId,
      startAt: doTime.startAt,
      minute: doTime.minute,
      content: doTime.content,
      done: doTime.done,
      submission: submission,
    );
  }

  DoTime toDoTime() {
    return DoTime(
        submissionId: submissionId,
        startAt: startAt,
        minute: minute,
        content: content,
        done: done);
  }
}
