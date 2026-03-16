/// copyWith で nullable フィールドの「未指定」と「null に設定」を区別するラッパー。
///
/// ```dart
/// config.copyWith(); // 変更なし (パラメータ自体が null)
/// config.copyWith(field: Value(null)); // null に設定
/// config.copyWith(field: Value(TimeOfDay(10, 0))); // 値を設定
/// ```
class Value<T> {
  final T value;
  const Value(this.value);
}
