import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/pref_key.dart";
import "../../providers/firestore_providers.dart";
import "../../ui_components/settings_ui.dart";
import "../../utils/ui.dart";

class CustomizeSettingsPage extends ConsumerWidget {
  const CustomizeSettingsPage({super.key});

  static const routeName = "/settings/customize";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(firestoreUserConfigProvider);
    final isLoading = configAsync.isLoading;
    final digestiveNotificationTimeBefore =
        configAsync.value?.digestiveNotificationTimeBefore ?? 5;

    final writeToGoogleTasks =
        ref.watchPref(PrefKey.isWriteToGoogleTasksByDefault);
    final showTimetableMenu = ref.watchPref(PrefKey.showTimetableMenu);
    final showReviewBtn = ref.watchPref(PrefKey.showReviewBtn);

    return SettingsListView(
      categories: [
        SettingsCategory(title: "Digestive", tiles: [
          SettingsTile(
            title: "通知する時間",
            enabled: !isLoading,
            subtitle: getUnsetOrString(
                "$digestiveNotificationTimeBefore 分前", isLoading),
            onTap: () {
              showRoundedBottomSheet(
                context: context,
                title: "通知する時間",
                child: RadioBottomSheet<int>(
                  initialValue: digestiveNotificationTimeBefore,
                  items: [5, 10, 15, 20]
                      .map((e) => RadioBottomSheetItem<int>(
                            value: e,
                            title: "$e 分前",
                          ))
                      .toList(),
                  onSelected: (value) {
                    if (value == null) return;
                    ref
                        .read(firestoreUserConfigProvider.notifier)
                        .setDigestiveNotificationTimeBefore(value);
                  },
                ),
              );
            },
          ),
        ]),
        SettingsCategory(
          title: "デフォルト設定",
          tiles: [
            SwitchSettingsTile(
              title: "Googleカレンダー追加/編集",
              subtitle: "デフォルトで追加/編集がオンになります",
              value: writeToGoogleTasks,
              onChanged: (value) {
                ref.updatePref(PrefKey.isWriteToGoogleTasksByDefault, value);
              },
            ),
          ],
        ),
        SettingsCategory(
          title: "メニューに表示する項目 (再起動後に反映されます)",
          tiles: [
            SwitchSettingsTile(
              title: "時間割表",
              subtitle: "利用しない場合はメニューから削除できます",
              value: showTimetableMenu,
              onChanged: (value) {
                ref.updatePref(PrefKey.showTimetableMenu, value);
              },
            ),
            SwitchSettingsTile(
              title: "レビューを書く",
              subtitle: "既に書いた場合・書くつもりがない場合は「その他」のメニューから削除できます",
              value: showReviewBtn,
              onChanged: (value) {
                ref.updatePref(PrefKey.showReviewBtn, value);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class RadioBottomSheet<T> extends StatefulWidget {
  const RadioBottomSheet(
      {super.key, required this.items, this.initialValue, this.onSelected});

  final List<RadioBottomSheetItem<T>> items;
  final T? initialValue;
  final void Function(T? value)? onSelected;

  @override
  State<RadioBottomSheet<T>> createState() => _RadioBottomSheetState<T>();
}

class _RadioBottomSheetState<T> extends State<RadioBottomSheet<T>> {
  T? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: selected,
      onChanged: (value) {
        setState(() {
          selected = value;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...widget.items
              .map((e) => RadioListTile<T>(
                    value: e.value,
                    title: Text(e.title),
                  )),
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
      ),
    );
  }
}

class RadioBottomSheetItem<T> {
  T value;
  String title;

  RadioBottomSheetItem({required this.value, required this.title});
}
