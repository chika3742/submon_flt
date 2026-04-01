import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

import "../../core/pref_key.dart";
import "../../features/google_tasks/repositories/tasks_auth_notifier.dart";
import "../../features/submission/presentation/submission_save_state_notifier.dart";
import "../../isar_db/isar_submission.dart";
import "../../providers/firebase_providers.dart";
import "../../providers/submission_providers.dart";
import "../../ui_components/tappable_card.dart";
import "../color_picker_dialog.dart";

class SubmissionEditor extends ConsumerStatefulWidget {
  const SubmissionEditor(
      {super.key, this.submissionId, this.initialTitle, this.initialDeadline});

  final int? submissionId;
  final String? initialTitle;
  final DateTime? initialDeadline;

  @override
  ConsumerState<SubmissionEditor> createState() => SubmissionEditorState();
}

class SubmissionEditorState extends ConsumerState<SubmissionEditor> {
  final _titleController = TextEditingController();
  String? _titleError;
  final _detailsController = TextEditingController();
  bool _addTime = false;
  bool _writeGoogleTasks = false;
  Submission _submission = Submission();

  @override
  void initState() {
    super.initState();
    if (widget.submissionId != null) {
      final repo = ref.read(submissionRepositoryProvider);
      repo.get(widget.submissionId!).then((data) {
        if (data == null || !mounted) return;
        setState(() {
          _titleController.text = data.title;
          _detailsController.text = data.details;
          _submission = data;
          _writeGoogleTasks = data.googleTasksTaskId != null;
        });
      });
    }
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialDeadline != null) {
      _submission.due = widget.initialDeadline!;
    }

    _writeGoogleTasks = ref.readPref(PrefKey.isWriteToGoogleTasksByDefault);
  }

  @override
  Widget build(BuildContext context) {
    final authClientSnapshot = ref.watch(tasksAuthProvider);
    final googleTasksAvailabilityLoading = authClientSnapshot is AsyncLoading;
    final googleTasksAvailable = authClientSnapshot.value != null
        && (widget.submissionId == null
        || _submission.googleTasksTaskId == null);

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
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      TappableCard(
                        color: _submission.getColor().withValues(alpha: 0.3),
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
                            if (!_addTime) {
                              _submission.due = _submission.due
                                  .copyWith(hour: 23, minute: 59, second: 59);
                            }
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
                    initialValue: _submission.repeat,
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
                        onChanged: googleTasksAvailable ? (value) {
                          setState(() {
                            _writeGoogleTasks = value;
                          });
                        } : null,
                      ),
                      GestureDetector(
                        onTap: googleTasksAvailable ? () {
                          setState(() {
                            _writeGoogleTasks = !_writeGoogleTasks;
                          });
                        } : null,
                        child: Opacity(
                          opacity: switch (googleTasksAvailable) {
                            true => 1.0,
                            false => 0.7,
                          },
                          child: Text(
                            "Google Tasksに提出物を同期",
                            style: TextStyle(
                              color: switch (googleTasksAvailable) {
                                true => null,
                                false => Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withValues(alpha: 0.7),
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (googleTasksAvailabilityLoading)
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
        ),
      ],
    );
  }

  Future<void> showDateTimePickerDialog() async {
    final dateResult = await showDialog(
      context: context,
      builder: (context) {
        return DatePickerDialog(
          initialDate: _submission.due,
          firstDate: DateTime(2020),
          lastDate: DateTime(2099),
        );
      },
    );
    if (!mounted) return;
    if (dateResult != null) {
      if (_addTime) {
        final timeResult = await showDialog(
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
    showDialog<Color?>(
      context: context,
      builder: (context) {
        return ColorPickerDialog(
          initialColor: _submission.getColor(),
        );
      },
    ).then((color) {
      if (color != null) {
        setState(() {
          _submission.color = color.toARGB32();
        });
      }
    });
  }

  Future<void> save() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        _titleError = "入力してください";
      });
      return;
    }

    _submission
      ..title = _titleController.text
      ..details = _detailsController.text;

    final isNew = widget.submissionId == null;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final bodyLargeStyle = Theme.of(context).textTheme.bodyLarge;

    if (isNew) {
      // submission tips banner (sync, before pop)
      if (!ref.readPref(PrefKey.isSubmissionTipsDisplayed)) {
        scaffoldMessenger.showMaterialBanner(MaterialBanner(
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
              style: bodyLargeStyle,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("閉じる"),
              onPressed: () => scaffoldMessenger.hideCurrentMaterialBanner(),
            ),
          ],
        ));
        ref.updatePref(PrefKey.isSubmissionTipsDisplayed, true);
      }

      // Google Tasks default tips banner (sync, before pop)
      if (!ref.readPref(PrefKey.isWriteToGoogleTasksTipsDisplayed) &&
          _writeGoogleTasks) {
        scaffoldMessenger.showMaterialBanner(MaterialBanner(
          content: Text.rich(
            const TextSpan(children: [
              TextSpan(
                  text:
                      "今後、「Google Tasksに提出物を同期」をデフォルトにしますか？\n(この設定は「カスタマイズ設定」から変更できます)"),
            ]),
            style: bodyLargeStyle,
          ),
          actions: [
            TextButton(
              child: const Text("しない"),
              onPressed: () => scaffoldMessenger.hideCurrentMaterialBanner(),
            ),
            TextButton(
              child: const Text("する"),
              onPressed: () {
                scaffoldMessenger.hideCurrentMaterialBanner();
                ref.updatePref(PrefKey.isWriteToGoogleTasksByDefault, true);
              },
            ),
          ],
        ));
        ref.updatePref(PrefKey.isWriteToGoogleTasksTipsDisplayed, true);
      }

      ref.read(analyticsProvider).logEvent(name: "create_submission");
    }

    // Pop before save completes
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).maybePop();
    }

    // Fire-and-forget save
    ref.read(submissionSaveStateProvider.notifier).save(
          _submission,
          writeGoogleTasks: _writeGoogleTasks,
        );
  }
}
