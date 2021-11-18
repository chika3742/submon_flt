import 'package:animations/animations.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/submission_list.dart';
import 'package:submon/events.dart';
import 'package:submon/pages/submission_create_page.dart';

class TabSubmissions extends StatefulWidget {
  const TabSubmissions(this.eventBus, {Key? key}) : super(key: key);

  final EventBus eventBus;

  @override
  _TabSubmissionsState createState() => _TabSubmissionsState();
}

class _TabSubmissionsState extends State<TabSubmissions> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SubmissionList(widget.eventBus),
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
                if (result != null) widget.eventBus.fire(SubmissionInserted(result));
              },
            )
          ),
        )
      ],
    );
  }
}
