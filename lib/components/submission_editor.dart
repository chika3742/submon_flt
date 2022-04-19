import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as c;
import 'package:intl/intl.dart';
import 'package:submon/components/color_picker_dialog.dart';
import 'package:submon/components/tappable_card.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

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
  bool _syncWithGoogleCalendar = false;
  bool? _googleCalendarEnabled;

  _SubmissionEditorState() {
    var date = DateTime.now().add(const Duration(days: 1));
    date = date.toLocal();
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
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialDeadline != null) _date = widget.initialDeadline!;

    canAccessCalendar().then((value) {
      setState(() {
        _googleCalendarEnabled = value;
      });
    });
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
                        Text(
                            DateFormat("M月 d日 (E)" + (_addTime ? " HH:mm" : ""),
                                    "ja_JP")
                                .format(_date),
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold))
                      ],
                    ),
                    onTap: showDateTimePickerDialog,
                  ),
                  const SizedBox(width: 16),
                  TappableCard(
                    child: const Icon(Icons.palette),
                    color: _color.withOpacity(0.3),
                    onTap: showColorPickerDialog,
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
                      label: Text("詳細"), border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _syncWithGoogleCalendar,
                    onChanged: _googleCalendarEnabled == true
                        ? (value) {
                            setState(() {
                              _syncWithGoogleCalendar = value!;
                            });
                          }
                        : null,
                  ),
                  GestureDetector(
                    child: Opacity(
                      opacity: _googleCalendarEnabled == true ? 1 : 0.6,
                      child: Text(
                        widget.submissionId == null
                            ? "Google カレンダーに追加する"
                            : "Google カレンダーの予定も更新する",
                        style: TextStyle(
                          color: _googleCalendarEnabled == true
                              ? null
                              : Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.7),
                        ),
                      ),
                    ),
                    onTap: _googleCalendarEnabled == true
                        ? () {
                            setState(() {
                              _syncWithGoogleCalendar =
                                  !_syncWithGoogleCalendar;
                            });
                          }
                        : null,
                  ),
                  const SizedBox(width: 8),
                  if (_googleCalendarEnabled == null)
                    const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(),
                    ),
                ],
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
          _date = DateTime(dateResult.year, dateResult.month, dateResult.day,
              _date.hour, _date.minute);
        });
      }
    }
  }

  void showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ColorPickerDialog(
          initialColor: _color,
        );
      },
    ).then((color) {
      if (color != null) {
        setState(() {
          _color = color;
        });
      }
    });
  }

  void save() {
    SubmissionProvider().use((provider) async {
      var client = await googleSignIn.authenticatedClient();
      var api = client != null ? c.CalendarApi(client).events : null;
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

      // google calendar event entry
      var eventRequest = c.Event(
        summary: "Submon: ${data.title}",
        description: data.detail,
        start: c.EventDateTime(
          date: DateTime(data.date!.year, data.date!.month, data.date!.day),
        ),
        end: c.EventDateTime(
          date: DateTime(data.date!.year, data.date!.month, data.date!.day + 1),
        ),
      );

      dynamic result;
      if (widget.submissionId != null) {
        await provider.update(data);
        result = true;

        // update google calendar event
        if (_syncWithGoogleCalendar && api != null) {
          api.getEventForSubmissionId(widget.submissionId!).then((event) {
            if (event != null) {
              api.patch(eventRequest, "primary", event.id!);
            } else {
              showSnackBar(
                Application.globalKey.currentContext!,
                "Googleカレンダーに登録された予定が見つかりません。作成しますか？",
                action: SnackBarAction(
                    label: "作成する",
                    onPressed: () {
                      api.insert(
                          eventRequest
                            ..extendedProperties = c.EventExtendedProperties(
                              private: {
                                "submission_id": widget.submissionId.toString(),
                              },
                            ),
                          "primary");
                    }),
              );
            }
          });
        }
      } else {
        result = (await provider.insert(data)).id;

        // insert google calendar event
        if (_syncWithGoogleCalendar) {
          api?.insert(
              eventRequest
                ..extendedProperties = c.EventExtendedProperties(
                  private: {
                    "submission_id": result.toString(),
                  },
                ),
              "primary");
        }
      }

      Navigator.of(context, rootNavigator: true).maybePop<dynamic>(result);
    });
  }
}
