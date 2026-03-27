import "package:google_sign_in/google_sign_in.dart";
import "package:isar_community/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../features/auth/repositories/apple_sign_in_android.dart";
import "../isar_db/isar_digestive.dart";
import "../isar_db/isar_memorization_card_group.dart";
import "../isar_db/isar_submission.dart";
import "../isar_db/isar_timetable.dart";
import "../isar_db/isar_timetable_class_time.dart";
import "../isar_db/isar_timetable_table.dart";
import "../src/pigeons.g.dart";
import "firebase_providers.dart";

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

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn.instance;

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
