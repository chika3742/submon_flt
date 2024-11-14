import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "../../components/submission_list.dart";
import "../../drift_db/db.dart";
import "../../i18n/strings.g.dart";
import "../../types/enums.dart";

class SubmissionListScreen extends HookWidget {
  const SubmissionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      Submission(
        id: "1",
        title: "Test",
        details: "Test",
        due: DateTime.now().add(Duration(days: 15)),
        dueDateOnly: true,
        done: false,
        important: false,
        repeat: RepeatType.none,
        color: Color(0xFFFFFFFF),
        googleTasksTaskId: null,
        repeatSubmissionCreated: null,
      ),
      Submission(
        id: "2",
        title: "Test",
        details: "Test",
        due: DateTime.now().add(Duration(days: 2)),
        dueDateOnly: true,
        done: false,
        important: false,
        repeat: RepeatType.none,
        color: Color(0xFFFFFFFF),
        googleTasksTaskId: null,
        repeatSubmissionCreated: null,
      ),
      Submission(
        id: "2",
        title: "Test",
        details: "Test",
        due: DateTime.now().add(Duration(days: -1)),
        dueDateOnly: true,
        done: false,
        important: true,
        repeat: RepeatType.none,
        color: Color(0xFFFFFFFF),
        googleTasksTaskId: null,
        repeatSubmissionCreated: null,
      ),
    ];

    final listKey = useMemoized(() => GlobalKey<AnimatedListState>());

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.pages.submissions),
      ),
      body: SubmissionList(
        items: items,
        listKey: listKey,
      ),
    );
  }
}
