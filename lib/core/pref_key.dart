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

  /// 最後に起動したビルド番号。バージョンアップ検出に使用。
  lastVersionCode<int>("lastVersionCode", 0),

  /// Firestore 最終更新タイムスタンプ (マイクロ秒)。ローカルとサーバーの差分比較に使用。
  firestoreLastChanged<int>("firestoreLastChanged", 0),

  /// Firebase Analytics の有効/無効。
  isAnalyticsEnabled<bool>("isAnalyticsEnabled", true),

  /// 提出物作成後のスワイプ操作 Tips バナー表示済みフラグ。
  isSubmissionTipsDisplayed<bool>("isSubmissionTipsDisplayed", false),

  /// Google Tasks 同期デフォルト設定 Tips バナー表示済みフラグ。
  isWriteToGoogleTasksTipsDisplayed<bool>(
    "isWriteToGoogleTasksTipsDisplayed",
    false,
  ),

  /// Google Tasks 同期をデフォルトで有効にするかどうか。
  isWriteToGoogleTasksByDefault<bool>("isWriteToGoogleTasksByDefault", false),

  /// ボトムナビに時間割タブを表示するかどうか。
  showTimetableMenu<bool>("showTimetableMenu", true),

  /// 「レビューを書く」ボタンを表示するかどうか。
  showReviewBtn<bool>("showReviewBtn", true),

  /// メールリンク認証用に一時保存するメールアドレス。
  emailForUrlLogin<String?>("emailForUrlSignIn", null),
  ;

  final String key;
  final T defaultValue;

  const PrefKey(this.key, this.defaultValue);
}

extension RefPrefExtension on Ref {
  /// {@template watchPref}
  /// 指定したプリファレンスキーに対応する値を監視します。
  /// {@endtemplate}
  T watchPref<T extends Object?>(PrefKey<T> key) => watch(prefProvider(key));

  /// {@template readPref}
  /// 指定したプリファレンスキーに対応する値を読み取ります。Widgetのビルドスタック外からの読み取りを想定しています。可能な限り [watchPref] を使用してください。
  /// {@endtemplate}
  T readPref<T extends Object?>(PrefKey<T> key) => read(prefProvider(key));

  /// {@template updatePref}
  /// 指定したプリファレンスキーに対応する値を更新します。
  /// {@endtemplate}
  void updatePref<T extends Object?>(PrefKey<T> key, T value) =>
      read(prefProvider(key).notifier).update(value);
}

extension WidgetRefPrefExtension on WidgetRef {
  /// {@macro watchPref}
  T watchPref<T extends Object?>(PrefKey<T> key) => watch(prefProvider(key));

  /// {@macro readPref}
  T readPref<T extends Object?>(PrefKey<T> key) => read(prefProvider(key));

  /// {@macro updatePref}
  void updatePref<T extends Object?>(PrefKey<T> key, T value) =>
      read(prefProvider(key).notifier).update(value);
}
