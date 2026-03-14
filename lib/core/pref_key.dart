import "package:flutter_riverpod/flutter_riverpod.dart";

import "../providers/core_providers.dart";

enum PrefKey<T extends Object?> {
  /// 現在選択中の時間割テーブル ID。-1 はメインテーブルを示す。
  intCurrentTimetableId<int>("intCurrentTimetableId", -1),

  /// 時間割グリッドで土曜日カラムを表示するかどうか。
  timetableShowSaturday<bool>("timetableShowSaturday", true),

  /// 各時限の始業・終業時刻を表示するかどうか。
  timetableShowClassTime<bool>("timetableShowClassTime", true),

  /// 現在時刻に合わせて動くマーカーを表示するかどうか。
  timetableShowTimeMarker<bool>("timetableShowTimeMarker", true),

  /// 表示する時限数 (4〜8)。
  timetablePeriodCountToDisplay<int>("timetablePeriodCountToDisplay", 6),

  /// 時間割セルが 1 回以上挿入されたことを示すフラグ。Tips バナー表示判定に使う。
  isTimetableInsertedOnce<bool>("isTimetableInsertedOnce", false),

  /// 「科目を長押しで提出物を作成できます」Tips バナーが既に表示済みかどうか。
  isTimetableTipsDisplayed<bool>("isTimetableTipsDisplayed", false),
  ;

  final String key;
  final T defaultValue;

  const PrefKey(this.key, this.defaultValue);
}

extension RefPrefExtension on Ref {
  T watchPref<T extends Object?>(PrefKey<T> key) => watch(prefProvider(key));
  void updatePref<T extends Object?>(PrefKey<T> key, T value) =>
      read(prefProvider(key).notifier).update(value);
}

extension WidgetRefPrefExtension on WidgetRef {
  T watchPref<T extends Object?>(PrefKey<T> key) => watch(prefProvider(key));
  void updatePref<T extends Object?>(PrefKey<T> key, T value) =>
      read(prefProvider(key).notifier).update(value);
}
