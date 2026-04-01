import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/pref_key.dart";
import "../../isar_db/isar_timetable.dart" as db;
import "../../pages/timetable_cell_edit_page.dart";
import "../../providers/timetable_providers.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";
import "open_modal_animation.dart";

class Timetable extends ConsumerWidget {
  const Timetable({
    super.key,
    this.edit = false,
  });

  final bool edit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodCount = ref.watchPref(PrefKey.timetablePeriodCountToDisplay);
    final table = ref.watch(currentTimetableProvider);

    return Row(
      children: [
        Column(
          children: _buildPeriodHeader(periodCount),
        ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildWeekdayColumns(
                context,
                ref,
                periodCount,
                table,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPeriodHeader(int periodCount) {
    return [
      Container(
        height: 45,
        width: 30,
        decoration: const BoxDecoration(
            border: Border(right: BorderSide(), bottom: BorderSide())),
      ),
      for (var n = 1; n <= periodCount; n++)
        Container(
            padding: const EdgeInsets.all(8),
            height: 50,
            width: 30,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(border: Border(right: BorderSide())),
            child: Text(
              "$n",
              style: const TextStyle(
                  color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
            )),
    ];
  }

  List<Widget> _buildWeekdayColumns(
    BuildContext context,
    WidgetRef ref,
    int periodCount,
    Map<int, db.Timetable> table,
  ) {
    return [
      for (var youbi = 0; youbi <= 5; youbi++)
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          child: IntrinsicWidth(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide())),
                  height: 45,
                  alignment: Alignment.center,
                  child: Text(
                    getWeekdayString(youbi),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: youbi == 5 ? Colors.blue : null),
                  ),
                ),
                for (var index = 1; index <= periodCount; index++)
                  Builder(builder: (context) {
                    final cellId = _getWholeIndex(youbi, index);
                    final cell = table[cellId];
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onLongPress: cell != null && !edit
                            ? () {
                                createNewSubmissionForTimetable(
                                    context, youbi, cell.subject);
                                Feedback.forLongPress(context);
                              }
                            : null,
                        child: _buildCellContainer(
                            context, ref, youbi, index, cell),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
    ];
  }

  Widget _buildCellContainer(
    BuildContext context,
    WidgetRef ref,
    int youbi,
    int index,
    db.Timetable? cell,
  ) {
    if (edit) {
      return OpenContainer<dynamic>(
        routeSettings: const RouteSettings(name: "/timetable/edit/select"),
        closedColor: Theme.of(context).colorScheme.onInverseSurface,
        openColor: Theme.of(context).colorScheme.surface,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        closedBuilder: (_, _) =>
            _buildTimetableCell(context, ref, youbi, index),
        closedElevation: 4,
        openBuilder: (context, callback) => TimetableCellEditPage(
          weekDay: youbi,
          period: index - 1,
          initialData: cell,
          pushUndo: true,
        ),
      );
    } else {
      return OpenModalAnimatedContainer(
        context: context,
        tappable: cell != null,
        width: 500,
        height: 200,
        closedBuilder: (context) {
          return _buildTimetableCell(context, ref, youbi, index);
        },
        openBuilder: (context) {
          return _NoteView(
              cell: cell!,
              weekday: youbi,
              index: index,
              createSubmission: createNewSubmissionForTimetable);
        },
      );
    }
  }

  Widget _buildTimetableCell(
    BuildContext context,
    WidgetRef ref,
    int youbi,
    int index,
  ) {
    final table = ref.watch(currentTimetableProvider);
    final weekday = DateTime.now().weekday;
    final orange = weekday == youbi + 1 && !edit;
    final cellId = _getWholeIndex(youbi, index);
    return Material(
      color: orange
          ? Colors.orange
          : Theme.of(context).colorScheme.onInverseSurface,
      borderRadius: BorderRadius.circular(6),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 44,
        constraints: const BoxConstraints(minWidth: 50),
        alignment: Alignment.center,
        child: Text(
          table.containsKey(cellId) ? table[cellId]!.subject : "",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: orange ? Colors.white : null,
              ),
        ),
      ),
    );
  }

  int _getWholeIndex(int youbi, int index) {
    return youbi + (index - 1) * 6;
  }
}

class _NoteView extends StatelessWidget {
  const _NoteView({required this.cell,
      required this.weekday,
      required this.index,
      required this.createSubmission});

  final db.Timetable cell;
  final int weekday;
  final int index;
  final Function(BuildContext context, int youbi, String name) createSubmission;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).canvasColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    splashRadius: 24,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cell.subject,
                          style: const TextStyle(fontSize: 18)),
                      Text(
                          "${getWeekdayString(weekday)}曜日 $index時間目",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.meeting_room),
                        Text(cell.room),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        Text(cell.teacher),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: OutlinedButton(
                  child: const Text("この時間割から提出物作成"),
                  onPressed: () {
                    createSubmission(
                        context, weekday, cell.subject);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
