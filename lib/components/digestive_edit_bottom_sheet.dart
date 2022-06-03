import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/isar_db/isar_digestive.dart';

class DigestiveEditBottomSheet extends StatefulWidget {
  const DigestiveEditBottomSheet(
      {Key? key, this.initialData, required this.submissionId})
      : super(key: key);

  final Digestive? initialData;
  final int? submissionId;

  @override
  State<DigestiveEditBottomSheet> createState() =>
      _DigestiveEditBottomSheetState();
}

class _DigestiveEditBottomSheetState extends State<DigestiveEditBottomSheet> {
  final _acceptableMinute = [5, 10, 15, 20, 30, 45, 60];
  final _acceptableMinutesAfter = [10, 15, 20, 30, 45, 60];

  var _selection = DigestiveSelection.minutesAfter;
  var startAt = DateTime.now();
  var _minute = 10;
  var _minutesAfter = 10;
  final _controller = TextEditingController();

  var startAtChanged = false;

  @override
  void initState() {
    if (widget.initialData != null) {
      startAt = widget.initialData!.startAt;
      _minute = widget.initialData!.minute;
      _controller.text = widget.initialData!.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("「いつから」「何分間」やりますか？"),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<DigestiveSelection>(
                      value: DigestiveSelection.minutesAfter,
                      groupValue: _selection,
                      onChanged: onRadioSelected,
                    ),
                    GestureDetector(
                      child: const Text("n分後指定"),
                      onTap: () {
                        onRadioSelected(DigestiveSelection.minutesAfter);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<DigestiveSelection>(
                      value: DigestiveSelection.dateTime,
                      groupValue: _selection,
                      onChanged: onRadioSelected,
                    ),
                    GestureDetector(
                      child: const Text("日時指定"),
                      onTap: () {
                        onRadioSelected(DigestiveSelection.dateTime);
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (_selection == DigestiveSelection.dateTime)
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat("M/d").format(startAt),
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        splashRadius: 24,
                        onPressed: () async {
                          var result = await showDatePicker(
                            context: context,
                            initialDate: startAt.isBefore(DateTime.now())
                                ? DateTime.now()
                                : startAt,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (result != null) {
                            setState(() {
                              startAt = DateTime(result.year, result.month,
                                  result.day, startAt.hour, startAt.minute);
                              startAtChanged = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat("H:mm").format(startAt),
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.schedule),
                        splashRadius: 24,
                        onPressed: () async {
                          var result = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(startAt),
                          );
                          if (result != null) {
                            setState(() {
                              startAt = DateTime(startAt.year, startAt.month,
                                  startAt.day, result.hour, result.minute);
                              startAtChanged = true;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ],
              )
            else
              DropdownButton<int>(
                value: _minutesAfter,
                items: _acceptableMinutesAfter
                    .map((e) => DropdownMenuItem(
                  value: e,
                          child: Text("$e分後",
                              style: const TextStyle(fontSize: 20)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _minutesAfter = value!;
                  });
                },
              ),
            const Text("から"),
            DropdownButton<int>(
              value: _minute,
              items: _acceptableMinute
                  .map((e) => DropdownMenuItem(
                value: e,
                        child:
                            Text("$e分間", style: const TextStyle(fontSize: 20)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _minute = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if ((widget.initialData == null || startAtChanged) &&
            startAt.isBefore(DateTime.now()) &&
            _selection == DigestiveSelection.dateTime)
          const Text('現在時刻より後の時刻を選択してください',
              style: TextStyle(color: Colors.redAccent)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("内容(どこまで進めるか)"),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16),
            child: FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                // 現在時刻より前に設定時、エラー表示 (編集時、時刻に変更がない場合を除く)
                if ((widget.initialData == null || startAtChanged) &&
                    startAt.isBefore(DateTime.now()) &&
                    _selection == DigestiveSelection.dateTime) {
                  return;
                }
                if (_selection == DigestiveSelection.minutesAfter) {
                  startAt =
                      DateTime.now().add(Duration(minutes: _minutesAfter));
                }
                Navigator.pop(
                  context,
                  Digestive()
                    ..id = widget.initialData?.id
                    ..submissionId = widget.submissionId
                    ..startAt = startAt
                    ..minute = _minute
                    ..content = _controller.text
                    ..done = false,
                );
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ],
    );
  }

  void onRadioSelected(DigestiveSelection? selection) {
    setState(() {
      _selection = selection!;
    });
  }
}

enum DigestiveSelection {
  dateTime,
  minutesAfter,
}
