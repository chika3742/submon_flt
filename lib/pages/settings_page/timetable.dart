import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/db/timetable_table.dart';
import 'package:submon/utils/ui.dart';

class TimetableSettingsPage extends StatefulWidget {
  const TimetableSettingsPage({Key? key}) : super(key: key);

  @override
  _TimetableSettingsPageState createState() => _TimetableSettingsPageState();
}

class _TimetableSettingsPageState extends State<TimetableSettingsPage> {
  int? hours;
  List<TimetableTable> tables = [];

  @override
  void initState() {
    super.initState();
    SharedPrefs.use((prefs) {
      setState(() {
        hours = prefs.timetableHour;
      });
    });
    getTables();
  }

  void getTables() {
    TimetableTableProvider().use((provider) async {
      tables = await provider.getAll();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsListView(
      categories: [
        SettingsCategory(title: "マルチ時間割表", tiles: [
          SettingsTile(
            title: "メイン",
            leading: const Icon(Icons.table_chart),
          ),
          ...tables.map((e) => SettingsTile(
              title: e.title,
              leading: const Icon(Icons.table_chart),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await showRoundedBottomSheet(
                          context: context,
                          title: "時間割表名の編集",
                          child: CreateTableBottomSheet(
                              id: e.id, initialText: e.title));
                      getTables();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showSimpleDialog(context, "確認",
                          "${e.title}\n\n時間割表を削除しますか？\n※一度削除すると元に戻せません",
                          showCancel: true, onOKPressed: () {
                        TimetableTableProvider().use((provider) async {
                          await provider.delete(e.id!);
                          var pref = await SharedPreferences.getInstance();
                          var sp = SharedPrefs(pref);
                          if (sp.currentTimetableId == e.id.toString()) {
                            sp.currentTimetableId = "main";
                          }
                          getTables();
                        });

                        TimetableProvider().use((provider) async {
                          provider.db.execute(
                              "delete from ${provider.tableName()} where id = ?",
                              [e.id]);
                        });
                      });
                    },
                  ),
                ],
              ))),
          SettingsTile(
            title: "追加",
            leading: const Icon(Icons.add),
            onTap: () async {
              await showRoundedBottomSheet(
                context: context,
                title: "時間割表作成",
                child: const CreateTableBottomSheet(),
              );
              getTables();
            },
          ),
        ]),
        SettingsCategory(title: "時間割通知", tiles: [
          SettingsTile(
            subtitle: "毎朝、当日の時間割を通知します。(時間割が入っている曜日のみ)",
          ),
          SettingsTile(
              title: "通知時刻",
              subtitle: "12:55",
              leading: const Icon(Icons.schedule),
              trailing: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {},
              )),
        ]),
        if (hours != null)
          SettingsCategory(title: "表示する時限数", tiles: [
            RadioSettingsTile(
                title: "5 時間目",
                value: 5,
                groupValue: hours!,
                onChanged: (value) {
                  updateHours(value as int);
                }),
            RadioSettingsTile(
                title: "6 時間目",
                value: 6,
                groupValue: hours!,
                onChanged: (value) {
                  updateHours(value as int);
                }),
            RadioSettingsTile(
                title: "7 時間目",
                value: 7,
                groupValue: hours!,
                onChanged: (value) {
                  updateHours(value as int);
                }),
            RadioSettingsTile(
                title: "8 時間目",
                value: 8,
                groupValue: hours!,
                onChanged: (value) {
                  updateHours(value as int);
                }),
          ]),
      ],
    );
  }

  void updateHours(int value) {
    SharedPrefs.use((prefs) {
      prefs.timetableHour = value;
    });
    setState(() {
      hours = value;
    });
  }
}

class CreateTableBottomSheet extends StatefulWidget {
  const CreateTableBottomSheet({Key? key, this.id, this.initialText})
      : super(key: key);

  final int? id;
  final String? initialText;

  @override
  _CreateTableBottomSheetState createState() => _CreateTableBottomSheetState();
}

class _CreateTableBottomSheetState extends State<CreateTableBottomSheet> {
  final _controller = TextEditingController();
  String? _fieldError;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) _controller.text = widget.initialText!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: const Text('時間割表名'),
            errorText: _fieldError,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.check),
              splashRadius: 24,
              onPressed: () {
                if (_controller.text.isEmpty) {
                  setState(() {
                    _fieldError = "入力してください";
                  });
                } else {
                  setState(() {
                    _fieldError = null;
                  });
                  TimetableTableProvider().use((provider) async {
                    await provider.insert(
                        TimetableTable(id: widget.id, title: _controller.text));
                    Navigator.pop(context);
                  });
                }
              },
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
      ],
    );
  }
}
