import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:submon/db/dotime.dart';
import 'package:submon/utils/ui.dart';

class DoTimeEditBottomSheet extends StatefulWidget {
  const DoTimeEditBottomSheet(
      {Key? key, this.initialData, required this.submissionId})
      : super(key: key);

  final DoTime? initialData;
  final int submissionId;

  @override
  State<DoTimeEditBottomSheet> createState() => _DoTimeEditBottomSheetState();
}

class _DoTimeEditBottomSheetState extends State<DoTimeEditBottomSheet> {
  final _acceptableMinute = [5, 10, 15, 20, 30, 45, 60];

  var startAt = DateTime.now();
  var minute = 10;
  final _controller = TextEditingController();

  var startAtChanged = false;

  @override
  void initState() {
    if (widget.initialData != null) {
      startAt = widget.initialData!.startAt;
      minute = widget.initialData!.minute;
      _controller.text = widget.initialData!.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // date select
            InkWell(
              child: Text(
                DateFormat("M/d").format(startAt),
                style:
                    GoogleFonts.exo(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                var result = await showDatePicker(
                  context: context,
                  initialDate: startAt,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (result != null) {
                  setState(() {
                    startAt = DateTime(result.year, result.month, result.day,
                        startAt.hour, startAt.minute);
                    startAtChanged = true;
                  });
                }
              },
            ),
            // time select
            InkWell(
              child: Text(
                DateFormat("H:mm").format(startAt),
                style:
                    GoogleFonts.exo(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                var result = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(startAt),
                );
                if (result != null) {
                  setState(() {
                    startAt = DateTime(startAt.year, startAt.month, startAt.day,
                        result.hour, result.minute);
                    startAtChanged = true;
                  });
                }
              },
            ),
            DropdownButton<int>(
              value: minute,
              items: _acceptableMinute
                  .map((e) => DropdownMenuItem(
                        child: Text("$e分",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  minute = value!;
                });
              },
            )
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            padding: const EdgeInsets.only(right: 8, bottom: 16),
            child: FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                // 現在時刻より前に設定時、エラー表示 (編集時、時刻に変更がない場合を除く)
                if ((widget.initialData == null || startAtChanged) &&
                    startAt.isBefore(DateTime.now())) {
                  showSimpleDialog(context, "エラー", "現在時刻より後の時刻を設定してください。");
                  return;
                }
                Navigator.pop(
                    context,
                    DoTime(
                      id: widget.initialData?.id,
                      submissionId: widget.submissionId,
                      startAt: startAt,
                      minute: minute,
                      content: _controller.text,
                    ));
              },
            ),
          ),
        )
      ],
    );
  }
}