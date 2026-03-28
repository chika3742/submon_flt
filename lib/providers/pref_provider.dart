import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../core/pref_key.dart";

part "pref_provider.g.dart";

/// main() で初期化済みの [SharedPreferencesWithCache] を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。
/// 外部からは [prefProvider] を通じてアクセスすること。
@riverpod
SharedPreferencesWithCache sharedPrefsService(Ref ref) {
  throw UnimplementedError(
    "sharedPrefsServiceProvider must be overridden in ProviderScope",
  );
}

abstract interface class PrefAccessor<T> {
  T get();
  void update(T value);
}

@riverpod
class PrefNotifier<T extends Object?> extends _$PrefNotifier<T> implements PrefAccessor<T> {
  @override
  T build(PrefKey<T> key) => get();

  @override
  T get() {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    final value = prefs.get(key.key);
    return (value is T ? value : null) ?? key.defaultValue;
  }

  @override
  void update(T value) {
    final prefs = ref.read(sharedPrefsServiceProvider);
    switch (value) {
      case final String value: prefs.setString(key.key, value);
      case final int value: prefs.setInt(key.key, value);
      case final double value: prefs.setDouble(key.key, value);
      case final bool value: prefs.setBool(key.key, value);
      case final List<String> value: prefs.setStringList(key.key, value);
      case null: prefs.remove(key.key);
      default: throw UnsupportedError("Unsupported type for PrefKey: ${T.runtimeType}");
    }
    state = value;
  }
}
