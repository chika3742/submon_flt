import "package:animations/animations.dart";
import "package:flutter/material.dart";

import "../drift_db/db.dart";
import "../pages/submissions/submission_details.dart";
import "submission_item.dart";

class SubmissionList extends StatelessWidget {
  const SubmissionList({super.key, required this.items, required this.listKey});

  final List<Submission> items;
  final GlobalKey<AnimatedListState> listKey;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return AnimatedList(
      key: listKey,
      initialItemCount: items.length,
      itemBuilder: (context, index, animation) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: OpenContainer(
            useRootNavigator: true,
            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            closedColor: surfaceColor,
            middleColor: surfaceColor,
            openColor: surfaceColor,
            closedBuilder: (context, action) {
              return SubmissionItem(items[index], action: action);
            },
            openBuilder: (context, action) {
              return SubmissionDetailsPage();
            },
          ),
        );
      },
    );
  }
}
