import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class CustomizeSettingsPage extends StatefulWidget {
  const CustomizeSettingsPage({Key? key}) : super(key: key);

  @override
  _CustomizeSettingsPageState createState() => _CustomizeSettingsPageState();
}

class _CustomizeSettingsPageState extends State<CustomizeSettingsPage> {
  int? _doTimeNotificationTimeBefore;
  bool? _timetableInMenu;
  bool? _memorizeCardInMenu;

  @override
  void initState() {
    FirestoreProvider.config.then((value) {
      setState(() {
        _doTimeNotificationTimeBefore =
            value?.doTimeNotificationTimeBefore ?? 5;
      });
    }).onError<FirebaseException>((error, stackTrace) {
      handleFirebaseError(error, stackTrace, context, "DoTime通知時間の取得に失敗しました。");
    });

    SharedPrefs.use((prefs) {
      setState(() {
        _timetableInMenu = prefs.showTimetableMenu;
        _memorizeCardInMenu = prefs.showMemorizeMenu;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsListView(
      categories: [
        SettingsCategory(title: "DoTime", tiles: [
          SettingsTile(
            title: "通知する時間",
            subtitle: _doTimeNotificationTimeBefore == null
                ? "Loading..."
                : "$_doTimeNotificationTimeBefore 分前",
            onTap: _doTimeNotificationTimeBefore != null
                ? () {
                    showRoundedBottomSheet(
                      context: context,
                      title: "通知する時間",
                      child: RadioBottomSheet(
                        initialValue: _doTimeNotificationTimeBefore,
                        items: [5, 10, 15, 20]
                            .map((e) => RadioBottomSheetItem(
                                  value: e,
                                  title: "$e 分前",
                                ))
                            .toList(),
                        onSelected: (value) {
                          setState(() {
                            _doTimeNotificationTimeBefore = value;
                          });
                          FirestoreProvider.setDoTimeNotificationTimeBefore(
                              _doTimeNotificationTimeBefore!);
                        },
                      ),
                    );
                  }
                : null,
          ),
        ]),
        SettingsCategory(title: "メニューに表示する項目 (再起動後に反映されます)", tiles: [
          if (_timetableInMenu != null)
            SwitchSettingsTile(
              title: "時間割表",
              subtitle: "利用しない場合はメニューから削除できます",
              value: _timetableInMenu!,
              onChanged: (value) {
                SharedPrefs.use((prefs) {
                  prefs.showTimetableMenu = value;
                });
                setState(() {
                  _timetableInMenu = value;
                });
              },
            ),
          if (_timetableInMenu != null)
            SwitchSettingsTile(
              title: "暗記カード",
              subtitle: "利用しない場合はメニューから削除できます",
              value: _memorizeCardInMenu!,
              onChanged: (value) {
                SharedPrefs.use((prefs) {
                  prefs.showMemorizeMenu = value;
                });
                setState(() {
                  _memorizeCardInMenu = value;
                });
              },
            ),
        ]),
      ],
    );
  }
}

class RadioBottomSheet extends StatefulWidget {
  const RadioBottomSheet(
      {Key? key, required this.items, this.initialValue, this.onSelected})
      : super(key: key);

  final List<RadioBottomSheetItem> items;
  final dynamic initialValue;
  final void Function(dynamic value)? onSelected;

  @override
  State<RadioBottomSheet> createState() => _RadioBottomSheetState();
}

class _RadioBottomSheetState extends State<RadioBottomSheet> {
  dynamic selected;

  @override
  void initState() {
    selected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...widget.items
            .map((e) => RadioListTile<dynamic>(
                  value: e.value,
                  groupValue: selected,
                  title: Text(e.title),
                  onChanged: (value) {
                    setState(() {
                      selected = value;
                    });
                  },
                ))
            .toList(),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            Navigator.pop(context);
            widget.onSelected?.call(selected);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class RadioBottomSheetItem {
  dynamic value;
  String title;

  RadioBottomSheetItem({required this.value, required this.title});
}
