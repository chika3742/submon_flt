import 'package:collection/collection.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;
import 'package:intl/intl.dart';
import 'package:submon/components/color_picker_dialog.dart';
import 'package:submon/components/tappable_card.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class SubmissionEditor extends StatefulWidget {
  const SubmissionEditor({Key? key, this.submissionId, this.initialTitle, this.initialDeadline})
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
  bool _writeGoogleCalendar = false;
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

    canAccessTasks().then((value) {
      setState(() {
        _googleCalendarEnabled = value;
      });
    });

    SharedPrefs.use((prefs) {
      setState(() {
        _writeGoogleCalendar = prefs.writeGoogleCalendarByDefault;
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
                  Switch(
                    value: _writeGoogleCalendar,
                    onChanged: _googleCalendarEnabled == true
                        ? (value) {
                      setState(() {
                        _writeGoogleCalendar = value;
                      });
                    }
                        : null,
                  ),
                  GestureDetector(
                    child: Opacity(
                      opacity: _googleCalendarEnabled == true ? 1 : 0.6,
                      child: Text(
                        "Google Tasksに提出物を同期",
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
                        _writeGoogleCalendar = !_writeGoogleCalendar;
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

      // google tasks entry

      dynamic result;
      if (widget.submissionId != null) {
        await provider.update(data);
        result = true;
      } else {
        result = (await provider.insert(data)).id;

        SharedPrefs.use((prefs) {
          prefs.incrementSubmissionCreationCount();
        });
      }

      if (_writeGoogleCalendar && _googleCalendarEnabled == true) {
        writeToGoogleTasks(data);
      }
      Navigator.of(context, rootNavigator: true).maybePop<dynamic>(result);
    });
  }

  Future<tasks.Task> makeTaskRequest(Submission data) async {
    var linkData = await FirebaseDynamicLinks.instance
        .buildShortLink(DynamicLinkParameters(
      link:
          Uri.parse("https://app.submon.chikach.net/submission?id=${data.id}"),
      uriPrefix: "https://submon.page.link",
    ));
    return tasks.Task(
      id: data.googleTasksTaskId,
      title: "${data.title} (Submon)",
      notes: "Submon アプリ内で開く: ${linkData.shortUrl}",
      due: data.date!.toUtc().toIso8601String(),
    );
  }

  Future<void> writeToGoogleTasks(Submission data) async {
    var client = await googleSignIn.authenticatedClient();
    if (client == null) {
      showSnackBar(Application.globalKey.currentContext!,
          "Google Tasksへの追加に失敗しました。(認証に失敗しました。)");
      return;
    }

    var tasksApi = tasks.TasksApi(client);

    try {
      var tasklist =
          (await tasksApi.tasklists.list(maxResults: 1)).items?.firstOrNull;
      if (tasklist == null) {
        showSnackBar(Application.globalKey.currentContext!,
            "Google Tasksのタスクリストが存在しません。Tasksアプリでタスクリストを作成してください。");
        return;
      }

      if (data.googleTasksTaskId != null) {
        await tasksApi.tasks.update(
            await makeTaskRequest(data), tasklist.id!, data.googleTasksTaskId!);
      } else {
        var result = await tasksApi.tasks
            .insert(await makeTaskRequest(data), tasklist.id!);

        await SubmissionProvider().use((provider) async {
          await provider.update(data..googleTasksTaskId = result.id);
        });
      }
    } catch (e, st) {
      showSnackBar(
          Application.globalKey.currentContext!, "Google Tasksへの追加に失敗しました。");
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
    }
  }
}
