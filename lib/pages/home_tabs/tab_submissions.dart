import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/submission_list.dart';
import 'package:submon/events.dart';
import 'package:submon/pages/submission_create_page.dart';

class TabSubmissions extends StatefulWidget {
  const TabSubmissions({Key? key}) : super(key: key);

  @override
  _TabSubmissionsState createState() => _TabSubmissionsState();
}

class _TabSubmissionsState extends State<TabSubmissions> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SubmissionList(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: OpenContainer<int>(
              useRootNavigator: true,
              closedElevation: 8,
              closedShape: const CircleBorder(),
              closedColor: Theme.of(context).canvasColor,
              closedBuilder: (context, callback) => FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: callback,
              ),
              openBuilder: (context, callback) {
                return const SubmissionCreatePage();
              },
              onClosed: (result) {
                if (result != null) eventBus.fire(SubmissionInserted(result));
              },
            )
          ),
        )
      ],
    );
  }
}
