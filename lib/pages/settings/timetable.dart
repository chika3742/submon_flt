import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable.dart';
import 'package:submon/db/timetable_class_time.dart';
import 'package:submon/db/timetable_table.dart';
import 'package:submon/pages/settings/customize.dart';
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
  // int? hours;
  // bool? showSaturday;
  SharedPrefs? prefs;
  List<TimetableTable> tables = [];
  List<TimetableClassTime> classTimes = [];
  TimetableNotification? _timetableNotification;
  bool _loadingTimetableNotification = true;

  @override
  void initState() {
    super.initState();
    // SharedPrefs.use((prefs) {
    //   setState(() {
    //     hours = prefs.timetableHour;
    //     showSaturday = prefs.timetableShowSaturday;
    //   });
    // });

    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = SharedPrefs(value);
      });
    });

    getTables();

    TimetableClassTimeProvider(context).use((provider) async {
      classTimes = await provider.getAll();
    });

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

  @override
  void dispose() {
    super.dispose();
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
              subtitle: getUnsetOrString(
                  _timetableNotification?.time?.format(context),
                  _loadingTimetableNotification),
              enabled: !_loadingTimetableNotification,
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
                "${tables.firstWhereOrNull((e) => e.id == _timetableNotification?.id)?.title ?? "未選択"} (上の一覧から選択してください)",
            leading: const Icon(Icons.table_chart_outlined),
          ),
        ]),
        if (prefs != null)
          SettingsCategory(title: "表示する情報", tiles: [
            SettingsTile(
                title: "表示する時限数",
                subtitle: "${prefs!.timetableHour} 時限目",
                onTap: () {
                  showRoundedBottomSheet(
                    context: context,
                    title: "表示する時限数",
                    child: RadioBottomSheet(
                      initialValue: prefs!.timetableHour,
                      items: [4, 5, 6, 7, 8].map((e) {
                        return RadioBottomSheetItem(
                          value: e,
                          title: "$e 時限目",
                        );
                      }).toList(),
                      onSelected: (value) {
                        prefs?.timetableHour = value;
                        setState(() {});
                      },
                    ),
                  );
                }),
            SwitchSettingsTile(
              title: "土曜日を表示",
              value: prefs!.timetableShowSaturday,
              onChanged: (value) {
                prefs?.timetableShowSaturday = value;
                setState(() {});
              },
            ),
            SwitchSettingsTile(
              title: "始業・終業時刻を表示",
              value: prefs!.timetableShowClassTime,
              onChanged: (value) {
                prefs?.timetableShowClassTime = value;
                setState(() {});
              },
            ),
            SwitchSettingsTile(
              title: "現在時刻マーカーを表示",
              subtitle: "現在時刻に合わせて動くマーカーを表示します。",
              value: prefs!.timetableShowTimeMarker,
              onChanged: (value) {
                prefs?.timetableShowTimeMarker = value;
                setState(() {});
              },
            ),
          ]),
        SettingsCategory(
          title: "各時限の始業・終業時刻",
          tiles: [1, 2, 3, 4, 5, 6, 7, 8].map((e) {
            var item =
                classTimes.firstWhereOrNull((element) => element.id == e);
            return SettingsTile(
              title: "$e 時間目",
              subtitle: item != null
                  ? "${item.start.format(context)} ~ ${item.end.format(context)}"
                  : "未設定",
              onTap: () async {
                var start = await showTimePicker(
                  context: context,
                  initialTime:
                      item?.start ?? const TimeOfDay(hour: 0, minute: 0),
                  helpText: "始業時刻を設定 (1/2)",
                );

                if (start == null) return;

                var end = await showTimePicker(
                  context: context,
                  initialTime: item?.end ?? start,
                  helpText: "終業時刻を設定 (2/2)",
                );

                if (end == null) return;

                if (start.toMinutes() >= end.toMinutes()) {
                  showSnackBar(context, "終業時刻が始業時刻よりも前か同じになっています");
                  return;
                }

                if (classTimes.any((element) {
                  var a = element.start.toMinutes();
                  var b = element.end.toMinutes();
                  var x = start.toMinutes();
                  var y = end.toMinutes();
                  return element.id != e &&
                      ((x <= b && a <= y) ||
                          ((element.id < e && x < b) ||
                              (element.id > e && y > a)));
                })) {
                  showSnackBar(context, "他の設定時刻との関係が正しくありません");
                  return;
                }

                await TimetableClassTimeProvider(context).use((provider) async {
                  var obj = TimetableClassTime(id: e, start: start, end: end);
                  await provider.insert(obj);
                  classTimes.remove(item);
                  classTimes.add(obj);
                  setState(() {});
                });
              },
              trailing: item != null
                  ? IconButton(
                      splashRadius: 24,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        TimetableClassTimeProvider(context)
                            .use((provider) async {
                          await provider.delete(e);
                        });
                        setState(() {
                          classTimes.removeWhere((element) => element.id == e);
                        });
                      },
                    )
                  : null,
            );
          }).toList(),
        ),
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
}

enum _PopupMenuAction {
  setNotification,
  copy,
  edit,
  delete,
}
