import 'package:flutter/material.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../events.dart';

class TimetableCellEditPage extends StatefulWidget {
  const TimetableCellEditPage(
      {Key? key,
      required this.initialData,
      required this.weekDay,
      required this.period})
      : super(key: key);

  final Timetable? initialData;
  final int weekDay;
  final int period;

  @override
  State<TimetableCellEditPage> createState() => _TimetableCellEditPageState();
}

class _TimetableCellEditPageState extends State<TimetableCellEditPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${getWeekdayString(widget.weekDay)}曜日 ${widget.period + 1}時間目 編集'),
        actions: [
          if (widget.initialData != null)
            IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await TimetableProvider().use((provider) async {
                  await provider.delete(
                      getTimetableCellId(widget.period, widget.weekDay));
                });
                Navigator.pop(context);
                eventBus.fire(TimetableListChanged());
              },
            ),
          IconButton(
            splashRadius: 24,
            icon: const Icon(Icons.check),
            onPressed: save,
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
                  label: const Text('教科名'),
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
                        label: Text('教室'),
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
                        label: Text('先生'),
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
                  label: Text('メモ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save() async {
    if (_subjectController.text.isEmpty) {
      setState(() {
        _subjectError = "入力してください";
      });
      return;
    }

    setState(() {
      _subjectError = null;
    });

    var data = widget.initialData ??
        Timetable(
            cellId: getTimetableCellId(widget.period, widget.weekDay),
            subject: "");
    data.subject = _subjectController.text;
    data.room = _roomController.text;
    data.teacher = _teacherController.text;
    data.note = _noteController.text;
    await TimetableProvider().use((provider) async {
      await provider.insert(data);
    });

    Navigator.pop(context);

    eventBus.fire(TimetableListChanged());
  }
}
