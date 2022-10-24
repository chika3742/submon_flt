import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/color_picker_dialog.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/main.dart';
import 'package:submon/ui_components/tappable_card.dart';
import 'package:submon/utils/google_tasks.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class SubmissionEditor extends StatefulWidget {
  const SubmissionEditor({Key? key, this.submissionId, this.initialTitle, this.initialDeadline})
      : super(key: key);

  final int? submissionId;
  final String? initialTitle;
  final DateTime? initialDeadline;

  @override
  SubmissionEditorState createState() => SubmissionEditorState();
}

class SubmissionEditorState extends State<SubmissionEditor> {
  final _titleController = TextEditingController();
  String? _titleError;
  final _detailsController = TextEditingController();
  bool _addTime = false;
  bool _writeGoogleTasks = false;
  bool? _googleTasksAvailable;
  Submission _submission = Submission();

  @override
  void initState() {
    super.initState();
    if (widget.submissionId != null) {
      SubmissionProvider().use((provider) async {
        await provider.get(widget.submissionId!).then((data) {
          if (data == null) return;
          setState(() {
            _titleController.text = data.title;
            _detailsController.text = data.details;
            _submission = data;
          });
        });
      });
    }
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialDeadline != null) {
      _submission.due = widget.initialDeadline!;
    }

    canAccessTasks().then((value) {
      setState(() {
        _googleTasksAvailable = value;
      });
    });

    SharedPrefs.use((prefs) {
      setState(() {
        _writeGoogleTasks = prefs.isWriteToGoogleTasksByDefault;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      TappableCard(
                        onTap: showDateTimePickerDialog,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.event_available),
                            const SizedBox(width: 8),
                            Text(
                                DateFormat(
                                        "M月 d日 (E)${_addTime ? " HH:mm" : ""}",
                                        "ja_JP")
                                    .format(_submission.due),
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      TappableCard(
                        color: _submission.uiColor.withOpacity(0.3),
                        onTap: showColorPickerDialog,
                        child: const Icon(Icons.palette),
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
                  TextField(
                    controller: _titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      label: const Text("タイトル"),
                      filled: true,
                      errorText: _titleError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _detailsController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 2,
                    decoration: const InputDecoration(
                        label: Text("詳細"), border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<Repeat>(
                    value: _submission.repeat,
                    items: const [
                      DropdownMenuItem(
                        value: Repeat.none,
                        child: Text("しない"),
                      ),
                      DropdownMenuItem(
                        value: Repeat.weekly,
                        child: Text("毎週"),
                      ),
                      DropdownMenuItem(
                        value: Repeat.monthly,
                        child: Text("毎月"),
                      ),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("繰り返し"),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _submission.repeat = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Switch(
                        value: _writeGoogleTasks,
                        onChanged: _googleTasksAvailable == true
                            ? (value) {
                                setState(() {
                                  _writeGoogleTasks = value;
                                });
                              }
                            : null,
                      ),
                      GestureDetector(
                        onTap: _googleTasksAvailable == true
                            ? () {
                                setState(() {
                                  _writeGoogleTasks = !_writeGoogleTasks;
                                });
                              }
                            : null,
                        child: Opacity(
                          opacity: _googleTasksAvailable == true ? 1 : 0.6,
                          child: Text(
                            "Google Tasksに提出物を同期",
                            style: TextStyle(
                              color: _googleTasksAvailable == true
                                  ? null
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color!
                                      .withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_googleTasksAvailable == null)
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
          initialDate: _submission.due,
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
              initialTime: TimeOfDay.fromDateTime(_submission.due),
            );
          },
        );
        if (timeResult != null) {
          setState(() {
            _submission.due = DateTime(dateResult.year, dateResult.month,
                dateResult.day, timeResult.hour, timeResult.minute);
          });
        }
      } else {
        setState(() {
          _submission.due = DateTime(dateResult.year, dateResult.month,
              dateResult.day, _submission.due.hour, _submission.due.minute);
        });
      }
    }
  }

  void showColorPickerDialog() {
    showDialog<Color>(
      context: context,
      builder: (context) {
        return ColorPickerDialog(
          initialColor: _submission.uiColor,
        );
      },
    ).then((color) {
      if (color != null) {
        setState(() {
          _submission.color = SubmissionColor.of(color.value);
        });
      }
    });
  }

  void save() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        _titleError = "入力してください";
      });
      return;
    }

    _submission
      ..title = _titleController.text
      ..details = _detailsController.text;
    await SubmissionProvider().use((provider) async {
      await provider.writeTransaction(() async {
        _submission.id = await provider.put(_submission);

        if (widget.submissionId == null) {
          eventBus.fire(SubmissionInserted(_submission.id!));
        }
      });

      if (_writeGoogleTasks && _googleTasksAvailable == true) {
        addToGoogleTasks(_submission);
      }
    });

    // If created new
    if (widget.submissionId == null) {
      SharedPrefs.use((prefs) {
        var context = Application.globalKey.currentContext!;

        // submission tips banner
        if (!prefs.isSubmissionTipsDisplayed) {
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text.rich(
                const TextSpan(children: [
                  TextSpan(text: "提出物を完了にするには"),
                  TextSpan(
                      text: "右にスワイプ",
                      style: TextStyle(color: Colors.greenAccent)),
                  TextSpan(text: "、\n提出物を削除するには"),
                  TextSpan(
                      text: "左にスワイプ",
                      style: TextStyle(color: Colors.redAccent)),
                  TextSpan(text: "します。\n\n"),
                  TextSpan(text: "また、提出物を"),
                  TextSpan(
                      text: "長押し", style: TextStyle(color: Colors.redAccent)),
                  TextSpan(text: "で、提出物の共有やその他のメニューが表示されます。"),
                ]),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            actions: [
              TextButton(
                child: const Text("閉じる"),
                onPressed: () {
                  hideMaterialBanner(context);
                },
              ),
            ],
          ));

          prefs.isSubmissionTipsDisplayed = true;
        }

        // google tasks default tips banner
        if (!prefs.isWriteToGoogleTasksTipsDisplayed && _writeGoogleTasks) {
          showMaterialBanner(
            context,
            content: Text.rich(
              const TextSpan(children: [
                TextSpan(
                    text:
                    "今後、「Google Tasksに提出物を同期」をデフォルトにしますか？\n(この設定は「カスタマイズ設定」から変更できます)"),
              ]),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                child: const Text("しない"),
                onPressed: () {
                  hideMaterialBanner(context);
                },
              ),
              TextButton(
                child: const Text("する"),
                onPressed: () {
                  hideMaterialBanner(context);
                  prefs.isWriteToGoogleTasksByDefault = true;
                },
              ),
            ],
          );

          prefs.isWriteToGoogleTasksTipsDisplayed = true;
        }
      });

      FirebaseAnalytics.instance.logEvent(name: "create_submission");
    }

    if (mounted) Navigator.of(context, rootNavigator: true).maybePop(_submission.id);
  }


  Future<void> addToGoogleTasks(Submission data) async {
    var result = await GoogleTasksHelper.addTask(data);

    switch (result) {
      case GoogleApiError.failedToAuthenticate:
        showSnackBar(globalContext!,
            "Google Tasksへの追加に失敗しました。(認証に失敗しました。)");
        break;

      case GoogleApiError.taskListDoesNotExist:
        showSnackBar(globalContext!,
            "Google Tasksのタスクリストが存在しません。Tasksアプリでタスクリストを作成してください。");
        break;

      case GoogleApiError.unknown:
        showSnackBar(globalContext!,
            "Google Tasksへの追加に失敗しました。");
        break;

      case null:
        // Successful
    }
  }

}
