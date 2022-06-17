import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/color_picker_dialog.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/ui_components/settings_ui.dart';
import 'package:submon/user_config.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class CustomizeSettingsPage extends StatefulWidget {
  const CustomizeSettingsPage({Key? key}) : super(key: key);

  @override
  CustomizeSettingsPageState createState() => CustomizeSettingsPageState();
}

class CustomizeSettingsPageState extends State<CustomizeSettingsPage> {
  int? _digestiveNotificationTimeBefore;
  bool _loadingDigestiveNotificationTimeBefore = true;
  SharedPrefs? prefs;

  @override
  void initState() {
    FirestoreProvider.config.then((value) {
      setState(() {
        _digestiveNotificationTimeBefore =
            value?.digestiveNotificationTimeBefore ?? 5;
      });
    }).onError<FirebaseException>((error, stackTrace) {
      handleFirebaseError(
          error, stackTrace, context, "Digestive通知時間の取得に失敗しました。");
    }).whenComplete(() {
      setState(() {
        _loadingDigestiveNotificationTimeBefore = false;
      });
    });

    SharedPrefs.use((prefs) {
      setState(() {
        this.prefs = prefs;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsListView(
      categories: [
        SettingsCategory(title: "Digestive", tiles: [
          SettingsTile(
            title: "通知する時間",
            enabled: !_loadingDigestiveNotificationTimeBefore,
            subtitle: getUnsetOrString("$_digestiveNotificationTimeBefore 分前",
                _loadingDigestiveNotificationTimeBefore),
            onTap: _digestiveNotificationTimeBefore != null
                ? () {
                    showRoundedBottomSheet(
                      context: context,
                      title: "通知する時間",
                      child: RadioBottomSheet(
                        initialValue: _digestiveNotificationTimeBefore,
                        items: [5, 10, 15, 20]
                            .map((e) => RadioBottomSheetItem(
                                  value: e,
                                  title: "$e 分前",
                                ))
                            .toList(),
                        onSelected: (value) {
                          setState(() {
                            _digestiveNotificationTimeBefore = value;
                          });
                          FirestoreProvider.setDigestiveNotificationTimeBefore(
                              _digestiveNotificationTimeBefore!);
                        },
                      ),
                    );
                  }
                : null,
          ),
        ]),
        if (prefs != null)
          SettingsCategory(
            title: "デフォルト設定",
            tiles: [
              SwitchSettingsTile(
                title: "Googleカレンダー追加/編集",
                subtitle: "デフォルトで追加/編集がオンになります",
                value: prefs!.isWriteToGoogleTasksByDefault,
                onChanged: (value) {
                  setState(() {
                    prefs!.isWriteToGoogleTasksByDefault = value;
                  });
                },
              ),
            ],
          ),
        if (prefs != null)
          SettingsCategory(title: "メニューに表示する項目 (再起動後に反映されます)", tiles: [
            SwitchSettingsTile(
              title: "時間割表",
              subtitle: "利用しない場合はメニューから削除できます",
              value: prefs!.showTimetableMenu,
              onChanged: (value) {
                setState(() {
                  prefs!.showTimetableMenu = value;
                });
              },
            ),
            SwitchSettingsTile(
              title: "レビューを書く",
              subtitle: "既に書いた場合・書くつもりがない場合は「その他」のメニューから削除できます",
              value: prefs!.showReviewBtn,
              onChanged: (value) {
                setState(() {
                  prefs!.showReviewBtn = value;
                });
              },
            ),
          ]),
        if (prefs != null)
          SettingsCategory(title: "その他", tiles: [
            SettingsTile(
              title: "LMSから作成された提出物のカラー",
              subtitle: "提出物カラーが白設定の場合、ここで設定したカラーが使用されます。",
              onTap: () {
                showDialog<Color>(
                  context: context,
                  builder: (context) {
                    return ColorPickerDialog(
                      initialColor: prefs!.colorSubmissionsAddedFromLms,
                    );
                  }
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      prefs!.colorSubmissionsAddedFromLms = value;
                    });
                    FirestoreProvider.updateUserConfig(UserConfig.pathColorSubmissionAddedFromLms, value.value);
                  }
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
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
              widget.onSelected?.call(selected);
            },
          ),
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
