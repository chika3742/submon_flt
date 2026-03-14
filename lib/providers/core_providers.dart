import "package:cloud_firestore/cloud_firestore.dart";
import "package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:googleapis/tasks/v1.dart";
import "package:googleapis_auth/googleapis_auth.dart";
import "package:isar_community/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../core/pref_key.dart";
import "../isar_db/isar_digestive.dart";
import "../isar_db/isar_memorization_card_group.dart";
import "../isar_db/isar_submission.dart";
import "../isar_db/isar_timetable.dart";
import "../isar_db/isar_timetable_class_time.dart";
import "../isar_db/isar_timetable_table.dart";

part "core_providers.g.dart";

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

@riverpod
class PrefNotifier<T extends Object?> extends _$PrefNotifier<T> {
  @override
  T build(PrefKey<T> key) {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    final value = prefs.get(key.key);
    return (value is T ? value : null) ?? key.defaultValue;
  }

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

@riverpod
Stream<User?> firebaseUser(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

/// 現在の認証ユーザーに対応する Firestore ドキュメント参照。
/// 未認証時は null。
@riverpod
DocumentReference<Map<String, dynamic>>? userDoc(Ref ref) {
  final user = ref.watch(firebaseUserProvider).value;
  if (user == null) return null;
  return FirebaseFirestore.instance.collection("users").doc(user.uid);
}

@Riverpod(keepAlive: true)
Stream<GoogleSignInAccount?> googleSignedInAccount(Ref ref) async* {
  final gsi = GoogleSignIn.instance;
  yield await gsi.attemptLightweightAuthentication();
  yield* gsi.authenticationEvents.asyncMap((ev) {
    return switch (ev) {
      GoogleSignInAuthenticationEventSignIn(:final user) => user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };
  });
}

/// This provider must be refreshed manually when the authorized scopes changed.
@riverpod
Future<AuthClient?> googleAuthenticatedClient(Ref ref) async {
  const scopes = [TasksApi.tasksScope];

  final user = ref.watch(googleSignedInAccountProvider).value;
  if (user == null) return null;

  final authorization = await user.authorizationClient.authorizationForScopes(scopes);
  return authorization?.authClient(scopes: scopes);
}
