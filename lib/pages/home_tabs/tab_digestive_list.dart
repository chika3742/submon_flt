import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

import "../../components/digestive_detail_card.dart";
import "../../isar_db/isar_digestive.dart";
import "../../isar_db/isar_submission.dart";
import "../../main.dart";
import "../../providers/digestive_providers.dart";
import "../../sample_data.dart";
import "../../utils/ui.dart";
import "../submission_detail_page.dart";

class TabDigestiveList extends ConsumerWidget {
  const TabDigestiveList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digestiveList = screenShotMode
        ? [
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
          ]
        : switch (ref.watch(undoneDigestivesWithSubmissionProvider)) {
            AsyncData(:final value) => value,
            _ => <DigestiveWithSubmission>[],
          };

    final widgets = <Widget>[];
    int? prevSubmissionId;

    for (var i in digestiveList.asMap().keys) {
      final e = digestiveList[i];
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
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                    SubmissionDetailPage.routeName,
                    arguments:
                        SubmissionDetailPageArguments(e.submission!.id!));
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
      ));
    }
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: widgets,
          ),
        ),
        if (digestiveList.isEmpty)
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
