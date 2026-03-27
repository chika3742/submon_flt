import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:isar_community/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../auth/apple_sign_in.dart";
import "../core/pref_key.dart";
import "../isar_db/isar_digestive.dart";
import "../isar_db/isar_memorization_card_group.dart";
import "../isar_db/isar_submission.dart";
import "../isar_db/isar_timetable.dart";
import "../isar_db/isar_timetable_class_time.dart";
import "../isar_db/isar_timetable_table.dart";
import "../src/pigeons.g.dart";

part "core_providers.g.dart";

const schemaVersion = 7;

@riverpod
Future<Isar> isar(Ref ref) async {
  final dir = await getApplicationSupportDirectory();
  final instance = await Isar.open(
    [
      SubmissionSchema,
      DigestiveSchema,
      TimetableSchema,
      TimetableClassTimeSchema,
      TimetableTableSchema,
      MemorizationCardGroupSchema,
    ],
    directory: dir.path,
  );
  ref.onDispose(() => instance.close());
  return instance;
}

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

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn.instance;

@Riverpod(keepAlive: true)
FirebaseCrashlytics crashlytics(Ref ref) => FirebaseCrashlytics.instance;

@Riverpod(keepAlive: true)
FirebaseAnalytics analytics(Ref ref) => FirebaseAnalytics.instance;

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@riverpod
bool isAdEnabled(Ref ref) {
  return ref.watch(firebaseUserProvider).value?.email !=
      dotenv.get("ADMIN_EMAIL");
}

@Riverpod(keepAlive: true)
AppleSignInAndroid appleSignInAndroid(Ref ref) => AppleSignInAndroid(
  ref.watch(browserApiProvider),
  ref.watch(crashlyticsProvider),
);

@Riverpod(keepAlive: true)
MessagingApi messagingApi(Ref ref) => MessagingApi();

@Riverpod(keepAlive: true)
GeneralApi generalApi(Ref ref) => GeneralApi();

@Riverpod(keepAlive: true)
BrowserApi browserApi(Ref ref) => BrowserApi();

@Riverpod(keepAlive: true)
Stream<User?> firebaseUser(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
}
