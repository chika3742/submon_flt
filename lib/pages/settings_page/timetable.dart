import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/db/timetable_table.dart';
import 'package:submon/utils/ui.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import '../../db/firestore_provider.dart';
import '../../method_channel/messaging.dart';
import '../../utils/utils.dart';

class TimetableSettingsPage extends StatefulWidget {
  const TimetableSettingsPage({Key? key}) : super(key: key);

  @override
  _TimetableSettingsPageState createState() => _TimetableSettingsPageState();
}

class _TimetableSettingsPageState extends State<TimetableSettingsPage> {
  int? hours;
  List<TimetableTable> tables = [];
  TimetableNotification? _timetableNotification;
  bool _loadingTimetableNotification = true;

  @override
  void initState() {
    super.initState();
    SharedPrefs.use((prefs) {
      setState(() {
        hours = prefs.timetableHour;
      });
    });
    getTables();

    FirestoreProvider.config.then((value) {
      setState(() {
        _timetableNotification = value!.timetableNotification;
      });
    }).onError<FirebaseException>((error, stackTrace) {
      handleFirebaseError(error, stackTrace, context, "時間割通知設定の取得に失敗しました。");
    }).whenComplete(() {
      setState(() {
        _loadingTimetableNotification = false;
      });
    });
  }

  void getTables() {
    TimetableTableProvider().use((provider) async {
      tables = [TimetableTable(title: "メイン"), ...await provider.getAll()];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsListView(
      categories: [
        SettingsCategory(title: "マルチ時間割表", tiles: [
          ...tables.map((e) => SettingsTile(
            title: e.title,
                leading: const Icon(Icons.table_chart),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (e.id == _timetableNotification?.id)
                      const Icon(Icons.notifications),
                    PopupMenuButton<_PopupMenuAction>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: e.id != _timetableNotification?.id,
                          child: ListTile(
                            enabled: e.id != _timetableNotification?.id,
                            title: const Text("この時間割を通知"),
                            leading: const Icon(Icons.notifications),
                          ),
                          value: _PopupMenuAction.setNotification,
                        ),
                        const PopupMenuItem(
                          child: ListTile(
                            title: Text("コピー"),
                            leading: Icon(Icons.content_copy),
                          ),
                          value: _PopupMenuAction.copy,
                        ),
                        if (e.id != null)
                          const PopupMenuItem(
                            child: ListTile(
                              title: Text("編集"),
                              leading: Icon(Icons.edit),
                            ),
                            value: _PopupMenuAction.edit,
                          ),
                        if (e.id != null)
                          const PopupMenuItem(
                            child: ListTile(
                              title: Text("削除"),
                              leading: Icon(Icons.delete),
                            ),
                            value: _PopupMenuAction.delete,
                          ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case _PopupMenuAction.setNotification:
                            setState(() {
                              _timetableNotification!.id = e.id;
                              _loadingTimetableNotification = true;
                            });
                            FirestoreProvider.setTimetableNotification(
                                    _timetableNotification!)
                                .whenComplete(() {
                              setState(() {
                                _loadingTimetableNotification = false;
                              });
                            });
                            break;
                          case _PopupMenuAction.copy:
                            copyTimetable(e);
                            break;
                          case _PopupMenuAction.edit:
                            changeTimetableName(e);
                            break;
                          case _PopupMenuAction.delete:
                            deleteTimetable(e);
                            break;
                        }
                      },
                    ),
                  ],
                ),
              )),
          SettingsTile(
            title: "追加",
            leading: const Icon(Icons.add),
            onTap: () async {
              await showRoundedBottomSheet(
                context: context,
                title: "時間割表作成",
                child: TextFormFieldBottomSheet(
                  formLabel: "時間割表名",
                  onDone: (text) async {
                    await TimetableTableProvider().use((provider) async {
                      await provider.insert(TimetableTable(title: text));
                      Navigator.pop(context);
                    });
                    showSnackBar(context, "時間割表を追加しました");
                  },
                ),
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
              subtitle: _timetableNotification?.time?.format(context) ?? "未設定",
              leading: const Icon(Icons.schedule),
              trailing: _loadingTimetableNotification
                  ? const CircularProgressIndicator()
                  : _timetableNotification?.time != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _timetableNotification?.time = null;
                            });
                            FirestoreProvider.setTimetableNotification(
                                _timetableNotification!);
                          },
                        )
                      : null,
              onTap: () async {
                var requestPermissionResult =
                    await MessagingPlugin.requestNotificationPermission();
                if (requestPermissionResult ==
                    NotificationPermissionState.denied) {
                  showSnackBar(context, "通知の表示が許可されていません。本体設定から許可してください。");
                } else {
                  var result = await showCustomTimePicker(
                    context: context,
                    initialTime: _timetableNotification?.time ??
                        const TimeOfDay(hour: 0, minute: 0),
                    selectableTimePredicate: (time) {
                      return time != null && time.minute % 5 == 0;
                    },
                    onFailValidation: (context) {
                      showSimpleDialog(context, "エラー", "5分おきに設定可能です");
                    },
                  );
                  if (result != null) {
                    setState(() {
                      _loadingTimetableNotification = true;
                    });
                    try {
                      setState(() {
                        _timetableNotification?.time = result;
                      });
                      await FirestoreProvider.setTimetableNotification(
                          _timetableNotification!);
                    } catch (e) {
                      showSnackBar(context, "設定に失敗しました");
                    }
                    setState(() {
                      _loadingTimetableNotification = false;
                    });
                  }
                }
              }),
          SettingsTile(
            title: "通知する時間割表",
            subtitle:
                "${tables.firstWhereOrNull((e) => e.id == _timetableNotification?.id)?.title} (上の一覧から選択してください)",
            leading: const Icon(Icons.table_chart_outlined),
          ),
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

  void copyTimetable(TimetableTable table) async {
    await TimetableTableProvider().use((provider) async {
      var newTable = await provider.insert(TimetableTable(
        title: "${table.title ?? "メイン"} - コピー",
      ));

      await TimetableProvider().use((provider) async {
        (provider as TimetableProvider).currentTableId = newTable.id.toString();
        var cells = table.id != null
            ? await provider
            .getAll(where: "$colTableId = ?", whereArgs: [table.id])
            : await provider.getAll(where: "$colTableId is null");
        for (var cell in cells) {
          await provider.insert(
            cell
              ..id = null
              ..tableId = newTable.id,
          );
        }
      });

      getTables();
    });

    showSnackBar(context, "コピーしました");
  }

  void changeTimetableName(TimetableTable table) async {
    await showRoundedBottomSheet(
      context: context,
      title: "時間割表名の編集",
      child: TextFormFieldBottomSheet(
        formLabel: "時間割表名",
        initialText: table.title,
        onDone: (text) {
          TimetableTableProvider().use((provider) async {
            await provider.insert(TimetableTable(id: table.id, title: text));
            Navigator.pop(context);
          });
          showSnackBar(context, "時間割表名を変更しました");
        },
      ),
    );
    getTables();
  }

  void deleteTimetable(TimetableTable table) async {
    showSimpleDialog(
        context, "確認", "${table.title}\n\n時間割表を削除しますか？\n※一度削除すると元に戻せません",
        showCancel: true, onOKPressed: () {
      TimetableTableProvider().use((provider) async {
        await provider.delete(table.id!);
        var pref = await SharedPreferences.getInstance();
        var sp = SharedPrefs(pref);
        if (sp.currentTimetableId == table.id.toString()) {
          sp.currentTimetableId = "main";
        }
        getTables();
      });

      TimetableProvider().use((provider) async {
        await provider.db.execute(
            "delete from ${provider.tableName()} where $colTableId = ?",
            [table.id]);
      });

      showSnackBar(context, "削除しました");
    });
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

enum _PopupMenuAction {
  setNotification,
  copy,
  edit,
  delete,
}
