import "package:firebase_auth/firebase_auth.dart";
import "package:isar_community/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

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

/// main() で初期化済みの SharedPreferencesWithCache を受け取る同期 Provider。
/// ProviderScope の overrides で実体を注入する。
@riverpod
SharedPreferencesWithCache sharedPreferences(Ref ref) {
  throw UnimplementedError(
    "sharedPreferencesProvider must be overridden in ProviderScope",
  );
}

@riverpod
Stream<User?> firebaseUser(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}
