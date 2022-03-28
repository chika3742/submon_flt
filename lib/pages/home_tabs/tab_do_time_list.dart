import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/dotime_detail_card.dart';
import 'package:submon/db/doTime.dart';
import 'package:submon/db/submission.dart';

import '../../components/dotime_edit_bottom_sheet.dart';
import '../../utils/ui.dart';

class TabDoTimeList extends StatefulWidget {
  const TabDoTimeList({Key? key}) : super(key: key);

  @override
  State<TabDoTimeList> createState() => _TabDoTimeListState();
}

class _TabDoTimeListState extends State<TabDoTimeList> {
  List<DoTimeWithSubmission> _doTimeList = [];

  @override
  void initState() {
    DoTimeProvider().use((provider) async {
      var submissionProvider = SubmissionProvider();
      submissionProvider.db = provider.db;
      var doTimeList = await provider.getAll(where: "$colDone = 0");
      _doTimeList = await Future.wait(doTimeList.map((e) async {
        var submission = await submissionProvider.get(e.submissionId);
        return DoTimeWithSubmission.fromObject(e, submission!);
      }).toList());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    var prevSubmissionId = -1;

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
        var diff = e.submission.date!.difference(DateTime.now());
        var remainingString = getRemainingString(diff, false);
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 100,
                child: Text(
                  e.submission.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
              const SizedBox(width: 8),
              Text.rich(TextSpan(
                  text:
                      "${DateFormat("M/d (E)", "ja").format(e.submission.date!)}・あと ",
                  children: [
                    TextSpan(
                        text: remainingString[0],
                        style: TextStyle(
                          color: getRemainingDateColor(context, diff.inHours),
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
      prevSubmissionId = e.submissionId;

      widgets.add(DoTimeDetailCard(
        doTime: e,
        onEdit: () {
          _edit(e);
        },
        onDelete: () {
          _delete(e);
        },
        onTimer: () {
          _timer(e);
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

  void _delete(DoTime item) async {
    await DoTimeProvider().use((provider) async {
      await provider.delete(item.id!);
    });
    var index = _doTimeList.indexWhere((e) => e.id == item.id);
    late DoTimeWithSubmission removed;
    setState(() {
      removed = _doTimeList.removeAt(index);
    });
    showSnackBar(context, "削除しました",
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () {
            DoTimeProvider().use((provider) async {
              await provider.insert(item);
            });
            setState(() {
              _doTimeList.insert(index, removed);
            });
          },
        ));
  }

  void _edit(DoTime item) async {
    var data = await showRoundedBottomSheet<DoTime>(
      context: context,
      useRootNavigator: true,
      title: "編集",
      child: DoTimeEditBottomSheet(
        submissionId: item.submissionId,
        initialData: item,
      ),
    );
    if (data != null) {
      await DoTimeProvider().use((provider) async {
        await provider.insert(data);
      });
      setState(() {
        var index = _doTimeList.indexWhere((e) => e.id == item.id);
        var removed = _doTimeList.removeAt(index);
        _doTimeList.insert(
            index, DoTimeWithSubmission.fromObject(data, removed.submission));
      });
      showSnackBar(context, "編集しました");
    }
  }

  void _timer(DoTime item) async {
    var result = await Navigator.of(context, rootNavigator: true)
        .pushNamed("/focus-timer", arguments: {
      "doTime": item,
    });
    if (result == true) {
      setState(() {
        _doTimeList.remove(item);
      });
    }
  }
}

class DoTimeWithSubmission extends DoTime {
  final Submission submission;

  DoTimeWithSubmission(
      {required int id,
      required int submissionId,
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

  static DoTimeWithSubmission fromObject(DoTime doTime, Submission submission) {
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
