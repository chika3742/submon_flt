import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/digestive_detail_card.dart';
import 'package:submon/events.dart';
import 'package:submon/isar_db/isar_digestive.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/main.dart';

import '../../components/digestive_edit_bottom_sheet.dart';
import '../../utils/ui.dart';

class TabDigestiveList extends StatefulWidget {
  const TabDigestiveList({Key? key}) : super(key: key);

  @override
  State<TabDigestiveList> createState() => _TabDigestiveListState();
}

class _TabDigestiveListState extends State<TabDigestiveList> {
  StreamSubscription? listener;

  List<DigestiveWithSubmission> _digestiveList = [];

  @override
  void initState() {
    DigestiveProvider().use((provider) async {
      SubmissionProvider().use((sProvider) async {
        var digestiveList = await provider.getUndoneDigestives();
        _digestiveList = await Future.wait(digestiveList.map((e) async {
          var submission = e.submissionId != null
              ? await sProvider.get(e.submissionId!)
              : null;
          return DigestiveWithSubmission.fromObject(e, submission);
        }).toList());
        setState(() {});
      });
    });

    listener = eventBus.on<DigestiveAddButtonPressed>().listen((event) async {
      var result = await showRoundedBottomSheet<Digestive>(
          context: context,
          useRootNavigator: true,
          title: "Digestive単体作成 (提出物なし)",
          child: const DigestiveEditBottomSheet(
            submissionId: null,
          ));

      if (result != null) {
        DigestiveProvider().use((provider) async {
          provider.writeTransaction(() async {
            var data = await provider.put(result);
            setState(() {
              _digestiveList
                  .add(DigestiveWithSubmission.fromObject(data, null));
            });
          });
        });
        showSnackBar(globalContext!, "作成しました");
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

    for (var i in _digestiveList.asMap().keys) {
      var e = _digestiveList[i];
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
        var diff = e.submission?.due.difference(DateTime.now());
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
                        "${DateFormat("M/d (E)", "ja").format(e.submission!.due)}・あと ",
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

      widgets.add(DigestiveDetailCard(
        digestive: e,
        parentList: _digestiveList,
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
        if (_digestiveList.isEmpty)
          const Center(child: Text('Digestiveがありません')),
      ],
    );
  }
}

class DigestiveWithSubmission extends Digestive {
  final Submission? submission;
  final Digestive digestive;

  DigestiveWithSubmission.fromObject(this.digestive, this.submission) {
    id = digestive.id!;
    submissionId = digestive.submissionId;
    startAt = digestive.startAt;
    minute = digestive.minute;
    content = digestive.content;
    done = digestive.done;
  }
}
