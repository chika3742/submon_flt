import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "firebase_providers.g.dart";

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
Stream<User?> firebaseUser(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
}

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
