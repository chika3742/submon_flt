import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/local_db/submission.dart';

class SubmissionEditor extends StatefulWidget {
  const SubmissionEditor(
      {Key? key, this.submissionId, this.initialTitle, this.initialDeadline})
      : super(key: key);

  final int? submissionId;
  final String? initialTitle;
  final DateTime? initialDeadline;

  @override
  _SubmissionEditorState createState() => _SubmissionEditorState();
}

class _SubmissionEditorState extends State<SubmissionEditor> {
  final _titleController = TextEditingController();
  String? _titleError;
  final _detailController = TextEditingController();
  late DateTime _date;
  Color _color = Colors.white;
  bool _addTime = false;

  _SubmissionEditorState() {
    var date = DateTime.now().add(const Duration(days: 1));
    date.toLocal();
    _date = DateTime(date.year, date.month, date.day, 23, 59);
  }

  @override
  void initState() {
    super.initState();
    if (widget.submissionId != null) {
      SubmissionProvider().use((provider) {
        provider.get(widget.submissionId!).then((data) {
          setState(() {
            _titleController.text = data!.title;
            _detailController.text = data.detail;
            _date = data.date!;
            _color = data.color;
          });
        });
      });
    }
    if (widget.initialTitle != null)
      _titleController.text = widget.initialTitle!;
    if (widget.initialDeadline != null) _date = widget.initialDeadline!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  TappableCard(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.event_available),
                        const SizedBox(width: 8),
                        Text(DateFormat("MM月 dd日 (E)" + (_addTime ? " HH:mm" : ""), "ja_JP").format(_date), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                      ],
                    ),
                    onTap: showDateTimePickerDialog,
                  ),
                  const SizedBox(width: 16),
                  TappableCard(
                    child: const Icon(Icons.palette),
                    onTap: () {

                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _addTime,
                    onChanged: (value) {
                      setState(() {
                        _addTime = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    child: const Text("時刻を追加する"),
                    onTap: () {
                      setState(() {
                        _addTime = !_addTime;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    label: const Text("タイトル"),
                    filled: true,
                    errorText: _titleError,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _detailController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 2,
                  decoration: const InputDecoration(
                    label: Text("詳細"),
                    border: OutlineInputBorder()
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              label: const Text("保存"),
              icon: const Icon(Icons.save),
              onPressed: save,
            ),
          ),
        )
      ],
    );
  }

  void showDateTimePickerDialog() async {
    var dateResult = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          initialDate: _date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2099),
        );
      },
    );
    if (dateResult != null) {
      if (_addTime) {
        var timeResult = await showDialog(
          context: context,
          builder: (context) {
            return TimePickerDialog(
              initialTime: TimeOfDay.fromDateTime(_date),
            );
          },
        );
        if (timeResult != null) {
          setState(() {
            _date = DateTime(dateResult.year, dateResult.month, dateResult.day, timeResult.hour, timeResult.minute);
          });
        }
      } else {
        setState(() {
          _date = DateTime(dateResult.year, dateResult.month, dateResult.day, _date.hour, _date.minute);
        });
      }
    }
  }

  void save() {
    SubmissionProvider().use((provider) async {
      Submission data;
      if (widget.submissionId != null) {
        data = (await provider.get(widget.submissionId!))!;
      } else {
        data = Submission();
      }
      data.title = _titleController.text;
      data.detail = _detailController.text;
      data.date = _date;
      data.color = _color;

      dynamic result;
      if (widget.submissionId != null) {
        await provider.update(data);
        result = true;
      } else {
        result = (await provider.insert(data)).id;
      }

      // TODO: サーバー送信処理

      Navigator.of(context, rootNavigator: true).maybePop<dynamic>(result);
    });

  }
}

class TappableCard extends StatelessWidget {
  const TappableCard({Key? key, this.child, this.onTap, this.color}) : super(key: key);

  final _cardBorderRadius = 8.0;
  final Widget? child;
  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardBorderRadius)),
      color: color,
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
