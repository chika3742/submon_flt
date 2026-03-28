import "package:collection/collection.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../browser.dart";
import "../../components/dropdown_time_picker_bottom_sheet.dart";
import "../../core/pref_key.dart";
import "../../features/auth/use_cases/sign_out_use_case.dart";
import "../../isar_db/isar_timetable_class_time.dart";
import "../../isar_db/isar_timetable_table.dart";
import "../../providers/firebase_providers.dart";
import "../../providers/firestore_providers.dart";
import "../../providers/timetable_providers.dart";
import "../../src/pigeons.g.dart";
import "../../ui_components/settings_ui.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";
import "customize.dart";

class TimetableSettingsPage extends ConsumerStatefulWidget {
  const TimetableSettingsPage({super.key});

  static const routeName = "/settings/functions/timetable";

  @override
  ConsumerState<TimetableSettingsPage> createState() =>
      _TimetableSettingsPageState();
}

class _TimetableSettingsPageState extends ConsumerState<TimetableSettingsPage> {
  int? _timetableNotificationId;
  TimeOfDay? _timetableNotificationTime;
  bool _loadingTimetableNotification = true;

  @override
  void initState() {
    super.initState();
    // TODO: hooksを使ってbuild関数内で完結できるようにする
    _initTimetableNotification();
  }

  Future<void> _initTimetableNotification() async {
    try {
      final config = await ref.read(firestoreUserConfigProvider.future);
      if (!mounted) return;
      setState(() {
        _timetableNotificationId = config?.timetableNotificationId;
        _timetableNotificationTime = config?.timetableNotificationTime;
      });
    } on FirebaseException catch (e, stackTrace) {
      ref.read(crashlyticsProvider).recordError(e, stackTrace);
      if (!context.mounted) return;
      switch (e.code) {
        case "permission-denied":
          showFirestoreReadFailedDialog(
            context,
            "時間割通知設定の取得に失敗しました。",
            onSignOut: () async {
              await ref.read(signOutUseCaseProvider).execute();
            },
            onShowAnnouncements: () {
              Browser.openAnnouncements();
              SystemChannels.platform.invokeMethod("SystemNavigator.pop");
            },
          );
        default:
          showSnackBar(context, "時間割通知設定の取得に失敗しました。(${e.code})",
              duration: const Duration(seconds: 20));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingTimetableNotification = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final periodCount = ref.watchPref(PrefKey.timetablePeriodCountToDisplay);
    final tablesAsync = ref.watch(timetableTablesProvider);
    final classTimesAsync = ref.watch(classTimesProvider);

    final tables = [
      TimetableTable.from(id: -1, title: "メイン"),
      ...tablesAsync.value ?? [],
    ];
    final classTimes = classTimesAsync.value ?? [];

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
                            enabled: e.id != _timetableNotificationId,
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
                            ref
                                .read(firestoreUserConfigProvider.notifier)
                                .setTimetableNotificationId(
                                    _timetableNotificationId!)
                                .onError((error, stackTrace) {
                              if (!context.mounted) return;
                              showSnackBar(context, "エラーが発生しました。");
                            }).whenComplete(() {
                              setState(() {
                                _loadingTimetableNotification = false;
                              });
                            });
                            break;
                          case _PopupMenuAction.copy:
                            _copyTimetable(e);
                            break;
                          case _PopupMenuAction.edit:
                            _changeTimetableName(e);
                            break;
                          case _PopupMenuAction.delete:
                            _deleteTimetable(e);
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
                    final tableRepo =
                        ref.read(timetableTableRepositoryProvider);
                    await tableRepo
                        .create(TimetableTable.from(title: text));
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    showSnackBar(context, "時間割表を追加しました");
                  },
                ),
              );
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
                final requestPermissionResult =
                    await MessagingApi().requestNotificationPermission();
                if (!context.mounted) return;
                if (requestPermissionResult?.value !=
                    NotificationPermissionState.granted) {
                  showSnackBar(
                      context, "通知の表示が許可されていません。本体設定から許可してください。");
                } else {

                  final result = await showRoundedBottomSheet<TimeOfDay>(
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
                      await ref
                          .read(firestoreUserConfigProvider.notifier)
                          .setTimetableNotificationTime(
                              _timetableNotificationTime);
                    } catch (e) {
                      if (!context.mounted) return;
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
                "${tables.firstWhereOrNull((e) => e.id == _timetableNotificationId)?.title ?? "未選択"} (上の一覧から選択してください)",
            leading: const Icon(Icons.table_chart_outlined),
          ),
        ]),
        SettingsCategory(title: "表示する情報", tiles: [
          SettingsTile(
              title: "表示する時限数",
              subtitle: "$periodCount 時限目",
              onTap: () {
                showRoundedBottomSheet(
                  context: context,
                  title: "表示する時限数",
                  child: RadioBottomSheet<int>(
                    initialValue: periodCount,
                    items: [4, 5, 6, 7, 8].map((e) {
                      return RadioBottomSheetItem<int>(
                        value: e,
                        title: "$e 時限目",
                      );
                    }).toList(),
                    onSelected: (value) {
                      if (value == null) return;
                      ref.updatePref(PrefKey.timetablePeriodCountToDisplay, value);
                      ref
                          .read(firestoreUserConfigProvider.notifier)
                          .setTimetablePeriodCountToDisplay(value);
                    },
                  ),
                );
              }),
          SwitchSettingsTile(
            title: "土曜日を表示",
            value: ref.watchPref(PrefKey.timetableShowSaturday),
            onChanged: (value) {
              ref.updatePref(PrefKey.timetableShowSaturday, value);
              ref
                  .read(firestoreUserConfigProvider.notifier)
                  .setTimetableShowSaturday(value);
            },
          ),
          SwitchSettingsTile(
            title: "始業・終業時刻を表示",
            value: ref.watchPref(PrefKey.timetableShowClassTime),
            onChanged: (value) {
              ref.updatePref(PrefKey.timetableShowClassTime, value);
            },
          ),
          SwitchSettingsTile(
            title: "現在時刻マーカーを表示",
            subtitle: "現在時刻に合わせて動くマーカーを表示します。",
            value: ref.watchPref(PrefKey.timetableShowTimeMarker),
            onChanged: (value) {
              ref.updatePref(PrefKey.timetableShowTimeMarker, value);
            },
          ),
        ]),
        SettingsCategory(
          title: "各時限の始業・終業時刻",
          tiles: [1, 2, 3, 4, 5, 6, 7, 8].map((e) {
            final item =
                classTimes.firstWhereOrNull((element) => element.period == e);
            return SettingsTile(
              title: "$e 時間目",
              subtitle: item != null
                  ? "${item.startTime.format(context)} ~ ${item.endTime.format(context)}"
                  : "未設定",
              onTap: () async {
                final start = await showTimePicker(
                  context: context,
                  initialTime:
                      item?.startTime ?? const TimeOfDay(hour: 0, minute: 0),
                  helpText: "始業時刻を設定 (1/2)",
                );

                if (!context.mounted || start == null) return;

                final end = await showTimePicker(
                  context: context,
                  initialTime: item?.endTime ?? start,
                  helpText: "終業時刻を設定 (2/2)",
                );

                if (!context.mounted || end == null) return;

                if (start.toMinutes() >= end.toMinutes()) {
                  showSnackBar(context, "終業時刻が始業時刻よりも前か同じになっています");
                  return;
                }

                if (classTimes.any((element) {
                  final a = element.startTime.toMinutes();
                  final b = element.endTime.toMinutes();
                  final x = start.toMinutes();
                  final y = end.toMinutes();
                  return element.period != e &&
                      ((x <= b && a <= y) ||
                          ((element.period < e && x < b) ||
                              (element.period > e && y > a)));
                })) {
                  showSnackBar(context, "他の設定時刻との関係が正しくありません");
                  return;
                }

                final classTimeRepo =
                    ref.read(timetableClassTimeRepositoryProvider);
                final obj = TimetableClassTime.from(
                    period: e, start: start, end: end);
                await classTimeRepo.update(obj);
              },
              trailing: item != null
                  ? IconButton(
                      splashRadius: 24,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        final classTimeRepo =
                            ref.read(timetableClassTimeRepositoryProvider);
                        classTimeRepo.remove(item.period);
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
        ref
            .read(firestoreUserConfigProvider.notifier)
            .setTimetableNotificationTime(_timetableNotificationTime);
      },
    );
  }

  Future<void> _copyTimetable(TimetableTable table) async {
    final tableRepo = ref.read(timetableTableRepositoryProvider);
    final timetableRepo = ref.read(timetableRepositoryProvider);

    final newTable = TimetableTable.from(
      title: "${table.title} - コピー",
    );
    final newId = await tableRepo.create(newTable);

    final cells = await timetableRepo.getByTableId(table.id!);
    for (final cell in cells) {
      await timetableRepo.create(
        cell
          ..id = null
          ..tableId = newId,
      );
    }

    if (!mounted) return;
    showSnackBar(context, "コピーしました");
  }

  Future<void> _changeTimetableName(TimetableTable table) async {
    await showRoundedBottomSheet(
      context: context,
      title: "時間割表名の編集",
      child: TextFormFieldBottomSheet(
        formLabel: "時間割表名",
        initialText: table.title,
        onDone: (text) {
          final tableRepo = ref.read(timetableTableRepositoryProvider);
          try {
            tableRepo.update(TimetableTable.from(id: table.id, title: text));
            Navigator.pop(context);
            showSnackBar(context, "時間割表名を変更しました");
          } catch (e, st) {
            showSnackBar(context, "エラーが発生しました。");
            ref.read(crashlyticsProvider).recordError(e, st);
          }
        },
      ),
    );
  }

  Future<void> _deleteTimetable(TimetableTable table) async {
    showSimpleDialog(
        context, "確認", "${table.title}\n\n時間割表を削除しますか？\n※一度削除すると元に戻せません",
        showCancel: true, onOKPressed: () {
      final tableRepo = ref.read(timetableTableRepositoryProvider);
      final timetableRepo = ref.read(timetableRepositoryProvider);
      tableRepo.remove(table.id!);
      timetableRepo.clearTableLocalOnly(table.id!);

      final currentTableId =
          ref.readPref(PrefKey.intCurrentTimetableId);
      if (currentTableId == table.id) {
        ref.updatePref(PrefKey.intCurrentTimetableId, -1);
      }

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
