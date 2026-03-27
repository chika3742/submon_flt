import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../core/pref_key.dart";
import "../isar_db/isar_timetable.dart";
import "../providers/timetable_providers.dart";
import "../utils/ui.dart";
import "../utils/utils.dart";
import "timetable_edit_page.dart";

class TimetableCellEditPage extends ConsumerStatefulWidget {
  const TimetableCellEditPage({
    super.key,
    required this.initialData,
    required this.weekDay,
    required this.period,
    this.pushUndo = false,
  });

  final Timetable? initialData;
  final int weekDay;
  final int period;
  final bool pushUndo;

  @override
  ConsumerState<TimetableCellEditPage> createState() =>
      _TimetableCellEditPageState();
}

class _TimetableCellEditPageState extends ConsumerState<TimetableCellEditPage> {
  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();
  final _teacherController = TextEditingController();
  final _noteController = TextEditingController();

  String? _subjectError;

  @override
  void initState() {
    _subjectController.text = widget.initialData?.subject ?? "";
    _roomController.text = widget.initialData?.room ?? "";
    _teacherController.text = widget.initialData?.teacher ?? "";
    _noteController.text = widget.initialData?.note ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tableId = ref.watchPref(PrefKey.intCurrentTimetableId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${getWeekdayString(widget.weekDay)}曜日 ${widget.period + 1}時間目 編集"),
        actions: [
          if (widget.initialData != null)
            IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.delete),
              onPressed: () async {
                if (widget.pushUndo) {
                  await ref
                      .read(timetableEditUseCaseProvider(tableId))
                      .pushUndoSnapshot();
                }
                final repo = ref.read(timetableRepositoryProvider);
                await repo.deleteCell(
                  tableId,
                  getTimetableCellId(widget.period, widget.weekDay),
                );
                if (!context.mounted) return;
                Navigator.pop(context, FieldValue.unselect);
              },
            ),
          IconButton(
            splashRadius: 24,
            icon: const Icon(Icons.check),
            onPressed: () => save(tableId),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  filled: true,
                  label: const Text("教科名"),
                  errorText: _subjectError,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Icon(Icons.meeting_room),
                  const SizedBox(width: 8),
                  Flexible(
                    child: TextFormField(
                      controller: _roomController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("教室"),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Flexible(
                    child: TextFormField(
                      controller: _teacherController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("先生"),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _noteController,
                minLines: 2,
                maxLines: 8,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("メモ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> save(int tableId) async {
    if (_subjectController.text.isEmpty) {
      setState(() {
        _subjectError = "入力してください";
      });
      return;
    }

    setState(() {
      _subjectError = null;
    });

    if (widget.pushUndo) {
      await ref
          .read(timetableEditUseCaseProvider(tableId))
          .pushUndoSnapshot();
    }

    final data = Timetable()
      ..id = widget.initialData?.id
      ..tableId = tableId
      ..cellId = getTimetableCellId(widget.period, widget.weekDay)
      ..subject = _subjectController.text
      ..room = _roomController.text
      ..teacher = _teacherController.text
      ..note = _noteController.text;

    final repo = ref.read(timetableRepositoryProvider);
    if (widget.initialData == null) {
      await repo.create(data);
    } else {
      await repo.update(data);
    }

    if (!mounted) return;
    Navigator.pop(context, data);
  }
}
