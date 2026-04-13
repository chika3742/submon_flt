import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";

import "../../../logging/infrastructure/crashlytics.dart";
import "../repositories/firebase_auth_repository.dart";

/// Returns `true` if the user is signed in, `false` otherwise.
/// Intended to be used before Riverpod initialization.
Future<bool> signInState() async {
  return await FirebaseAuthRepository(
    FirebaseAuth.instance,
    CrashlyticsErrorReporter(FirebaseCrashlytics.instance),
  ).currentUser().first != null;
}
