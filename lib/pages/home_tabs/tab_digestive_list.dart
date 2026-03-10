import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../components/digestive_detail_card.dart";
import "../../components/digestive_edit_bottom_sheet.dart";
import "../../events.dart";
import "../../isar_db/isar_digestive.dart";
import "../../isar_db/isar_submission.dart";
import "../../main.dart";
import "../../sample_data.dart";
import "../../utils/ui.dart";
import "../submission_detail_page.dart";

class TabDigestiveList extends StatefulWidget {
  const TabDigestiveList({super.key});

  @override
  State<TabDigestiveList> createState() => _TabDigestiveListState();
}

class _TabDigestiveListState extends State<TabDigestiveList> {
  StreamSubscription? listener;

  List<DigestiveWithSubmission> _digestiveList = [];

  @override
  void initState() {
    if (screenShotMode) {
      _digestiveList = [
        DigestiveWithSubmission.fromObject(
          SampleData.digestives[0],
          SampleData.submissions[0],
        ),
        DigestiveWithSubmission.fromObject(
          SampleData.digestives[1],
          SampleData.submissions[1],
        ),
        DigestiveWithSubmission.fromObject(
          SampleData.digestives[2],
          SampleData.submissions[1],
        ),
        DigestiveWithSubmission.fromObject(
          SampleData.digestives[3],
          null,
        ),
      ];
    } else {
      fetchDigestives();
    }

    listener = eventBus.on<DigestiveAddButtonPressed>().listen((event) async {
      final result = await showRoundedBottomSheet<Digestive>(
          context: context,
          useRootNavigator: true,
          title: "Digestive単体作成 (提出物なし)",
          child: const DigestiveEditBottomSheet(
            submissionId: null,
          ));

      if (result != null) {
        DigestiveProvider().use((provider) async {
          provider.writeTransaction(() async {
            final id = await provider.put(result);
            setState(() {
              _digestiveList.add(
                  DigestiveWithSubmission.fromObject(result..id = id, null));
            });
          });
        });
        showSnackBar(globalContext!, "作成しました");
      }
    });

    super.initState();
  }

  void fetchDigestives() {
    DigestiveProvider().use((provider) async {
      SubmissionProvider().use((sProvider) async {
        final digestiveList = await provider.getUndoneDigestives();
        _digestiveList = await Future.wait(digestiveList.map((e) async {
          final submission = e.submissionId != null
              ? await sProvider.get(e.submissionId!)
              : null;
          return DigestiveWithSubmission.fromObject(e, submission);
        }).toList());
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    int? prevSubmissionId;

    for (var i in _digestiveList.asMap().keys) {
      final e = _digestiveList[i];
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
        final diff = e.submission?.due.difference(DateTime.now());
        final remainingString =
            diff != null ? getRemainingString(diff, false) : null;
        if (e.submission != null) {
          widgets.add(Material(
            child: InkWell(
              onTap: () async {
                await Navigator.of(context, rootNavigator: true).pushNamed(
                    SubmissionDetailPage.routeName,
                    arguments:
                        SubmissionDetailPageArguments(e.submission!.id!));
                fetchDigestives();
              },
              child: Padding(
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
                                color: getRemainingDateColor(
                                    context, diff!.inHours),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                            text: remainingString[1],
                          ),
                        ])),
                  ],
                ),
              ),
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
          const Center(child: Text("Digestiveがありません")),
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
