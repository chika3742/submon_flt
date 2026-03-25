import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../components/timetable/timetable.dart";
import "../../core/pref_key.dart";
import "../../main.dart";
import "../../providers/timetable_providers.dart";
import "../../utils/ui.dart";

class TabTimetable extends ConsumerWidget {
  const TabTimetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(timetableTablesProvider).value ?? [];
    final currentTableId = ref.watchPref(PrefKey.intCurrentTimetableId);

    // テーブルTipsの表示 (初回のみ)
    if (ref.watchPref(PrefKey.isTimetableInsertedOnce) &&
        !ref.watchPref(PrefKey.isTimetableTipsDisplayed)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.updatePref(PrefKey.isTimetableTipsDisplayed, true);
        showMaterialBanner(
          context,
          content: const Text("科目を長押しで、その科目の提出物を作成できます。"),
          actions: [
            TextButton(
              child: const Text("閉じる"),
              onPressed: () {
                hideMaterialBanner(context);
              },
            ),
          ],
        );
      });
    }

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 32),
              child: SizedBox(
                child: DropdownButton<int>(
                  value: currentTableId,
                  enableFeedback: true,
                  items: [
                    const DropdownMenuItem(
                      value: -1,
                      child: Text("メイン"),
                    ),
                    ...tables.map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.title),
                        )),
                  ],
                  onChanged: (value) {
                    ref.updatePref(PrefKey.intCurrentTimetableId, value!);
                  },
                ),
              ),
            ),
            const Timetable(),
          ],
        ),
      ],
    );
  }
}
