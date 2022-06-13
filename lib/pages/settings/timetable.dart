import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/components/dropdown_time_picker_bottom_sheet.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/isar_db/isar_timetable.dart';
import 'package:submon/isar_db/isar_timetable_class_time.dart';
import 'package:submon/isar_db/isar_timetable_table.dart';
import 'package:submon/main.dart';
import 'package:submon/pages/settings/customize.dart';
import 'package:submon/ui_components/settings_ui.dart';
import 'package:submon/utils/ui.dart';

import '../../db/firestore_provider.dart';
import '../../method_channel/messaging.dart';
import '../../user_config.dart';
import '../../utils/utils.dart';

class TimetableSettingsPage extends StatefulWidget {
  const TimetableSettingsPage({Key? key}) : super(key: key);

  @override
  TimetableSettingsPageState createState() => TimetableSettingsPageState();
}

class TimetableSettingsPageState extends State<TimetableSettingsPage> {
  // int? hours;
  // bool? showSaturday;
  SharedPrefs? prefs;
  List<TimetableTable> tables = [];
  List<TimetableClassTime> classTimes = [];
  int? _timetableNotificationId;
  TimeOfDay? _timetableNotificationTime;
  bool _loadingTimetableNotification = true;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        prefs = SharedPrefs(value);
      });
    });

    getTables();

    TimetableClassTimeProvider().use((provider) async {
      classTimes = await provider.getAll();
      setState(() {});
    });

    FirestoreProvider.config.then((value) {
      setState(() {
        _timetableNotificationId = value!.timetableNotificationId;
        _timetableNotificationTime = value.timetableNotificationTime;
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
      tables = [
        TimetableTable.from(id: -1, title: "メイン"),
        ...await provider.getAll()
      ];
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
                    if (e.id == _timetableNotificationId)
                      const Icon(Icons.notifications),
                    PopupMenuButton<_PopupMenuAction>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: e.id != _timetableNotificationId,
                          value: _PopupMenuAction.setNotification,
                          child: ListTile(
                            enabled:
                                e.id != _timetableNotificationId,
                            title: const Text("この時間割を通知"),
                            leading: const Icon(Icons.notifications),
                          ),
                        ),
                        const PopupMenuItem(
                          value: _PopupMenuAction.copy,
                          child: ListTile(
                            title: Text("コピー"),
                            leading: Icon(Icons.content_copy),
                          ),
                        ),
                        if (e.id != -1)
                          const PopupMenuItem(
                            value: _PopupMenuAction.edit,
                            child: ListTile(
                              title: Text("編集"),
                              leading: Icon(Icons.edit),
                            ),
                          ),
                        if (e.id != -1)
                          const PopupMenuItem(
                            value: _PopupMenuAction.delete,
                            child: ListTile(
                              title: Text("削除"),
                              leading: Icon(Icons.delete),
                            ),
                          ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case _PopupMenuAction.setNotification:
                            setState(() {
                              _timetableNotificationId = e.id;
                              _loadingTimetableNotification = true;
                            });
                            FirestoreProvider.setTimetableNotificationId(
                                    _timetableNotificationId!)
                                .onError((error, stackTrace) {
                              showSnackBar(context, "エラーが発生しました。");
                            }).whenComplete(() {
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
                      await provider.writeTransaction(() async {
                        await provider.put(TimetableTable.from(title: text));
                      });
                    });
                    Navigator.pop(globalContext!);
                    showSnackBar(globalContext!, "時間割表を追加しました");
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
                  _timetableNotificationTime?.format(context),
                  _loadingTimetableNotification),
              enabled: !_loadingTimetableNotification,
              leading: const Icon(Icons.schedule),
              trailing: _buildReminderNotificationTimeTrailingIcon(),
              onTap: () async {
                var requestPermissionResult =
                    await MessagingPlugin.requestNotificationPermission();
                if (requestPermissionResult ==
                    NotificationPermissionState.denied) {
                  showSnackBar(
                      globalContext!, "通知の表示が許可されていません。本体設定から許可してください。");
                } else {
                  var result = await showRoundedBottomSheet<TimeOfDay>(
                    context: context,
                    title: "時間割通知の時刻を設定",
                    child: DropdownTimePickerBottomSheet(
                      initialTime: _timetableNotificationTime,
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _loadingTimetableNotification = true;
                    });
                    try {
                      setState(() {
                        _timetableNotificationTime = result;
                      });
                      await FirestoreProvider.setTimetableNotificationTime(
                          _timetableNotificationTime);
                    } catch (e) {
                      showSnackBar(globalContext!, "設定に失敗しました");
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
                "${tables.firstWhereOrNull((e) => e.id == _timetableNotificationId)?.title ?? "未選択"} (上の一覧から選択してください)",
            leading: const Icon(Icons.table_chart_outlined),
          ),
        ]),
        if (prefs != null)
          SettingsCategory(title: "表示する情報", tiles: [
            SettingsTile(
                title: "表示する時限数",
                subtitle: "${prefs!.timetablePeriodCountToDisplay} 時限目",
                onTap: () {
                  showRoundedBottomSheet(
                    context: context,
                    title: "表示する時限数",
                    child: RadioBottomSheet(
                      initialValue: prefs!.timetablePeriodCountToDisplay,
                      items: [4, 5, 6, 7, 8].map((e) {
                        return RadioBottomSheetItem(
                          value: e,
                          title: "$e 時限目",
                        );
                      }).toList(),
                      onSelected: (value) {
                        prefs?.timetablePeriodCountToDisplay = value;
                        FirestoreProvider.updateUserConfig(UserConfig.pathTimetablePeriodCountToDisplay, value);
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
                FirestoreProvider.updateUserConfig(UserConfig.pathTimetableShowSaturday, value);
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
                classTimes.firstWhereOrNull((element) => element.period == e);
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
                  showSnackBar(globalContext!, "終業時刻が始業時刻よりも前か同じになっています");
                  return;
                }

                if (classTimes.any((element) {
                  var a = element.start.toMinutes();
                  var b = element.end.toMinutes();
                  var x = start.toMinutes();
                  var y = end.toMinutes();
                  return element.period != e &&
                      ((x <= b && a <= y) ||
                          ((element.period < e && x < b) ||
                              (element.period > e && y > a)));
                })) {
                  showSnackBar(globalContext!, "他の設定時刻との関係が正しくありません");
                  return;
                }

                await TimetableClassTimeProvider().use((provider) async {
                  var obj = TimetableClassTime.from(
                      period: e, start: start, end: end);
                  await provider.writeTransaction(() async {
                    await provider.put(obj);
                  });
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
                        TimetableClassTimeProvider().use((provider) async {
                          provider.writeTransaction(() async {
                            await provider.delete(e);
                          });
                        });
                        setState(() {
                          classTimes
                              .removeWhere((element) => element.period == e);
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

  Widget? _buildReminderNotificationTimeTrailingIcon() {
    if (_loadingTimetableNotification) {
      return const CircularProgressIndicator();
    }
    if (_timetableNotificationTime == null) {
      return null;
    }
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        setState(() {
          _timetableNotificationTime = null;
        });
        FirestoreProvider.setTimetableNotificationTime(
            _timetableNotificationTime);
      },
    );
  }

  void copyTimetable(TimetableTable table) async {
    await TimetableTableProvider().use((provider) async {
      late TimetableTable newTable;
      await provider.writeTransaction(() async {
        newTable = TimetableTable.from(
          title: "${table.title} - コピー",
        );
        var id = await provider.put(newTable);
        newTable.id = id;
      });

      await TimetableProvider().use((provider) async {
        provider.currentTableId = newTable.id!;
        var cells = await provider.getTableByTableId(table.id!);
        provider.writeTransaction(() async {
          for (var cell in cells) {
            await provider.put(
              cell
                ..id = null
                ..tableId = newTable.id!,
            );
          }
        });
      });

      getTables();
    });

    showSnackBar(globalContext!, "コピーしました");
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
            try {
              await provider.writeTransaction(() async {
                await provider
                    .put(TimetableTable.from(id: table.id, title: text));
              });
              Navigator.pop(globalContext!);
              showSnackBar(globalContext!, "時間割表名を変更しました");
            } catch (e, st) {
              showSnackBar(globalContext!, "エラーが発生しました。");
              recordErrorToCrashlytics(e, st);
            }
          });
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
        await provider.writeTransaction(() async {
          await provider.delete(table.id!);
        });
        var pref = await SharedPreferences.getInstance();
        var sp = SharedPrefs(pref);
        if (sp.intCurrentTimetableId == table.id) {
          sp.intCurrentTimetableId = -1;
        }
        getTables();
      });

      TimetableProvider().use((provider) async {
        provider.writeTransaction(() async {
          await provider.deleteAllInTableLocalOnly(table.id!);
        });
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
