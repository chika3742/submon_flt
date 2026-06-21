import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../infrastructure/core_providers.dart";
import "../../../infrastructure/firebase_providers.dart";
import "../../../infrastructure/firestore_error_notifier.dart";
import "../../../infrastructure/firestore_providers.dart";
import "submission_repository.dart";

part "submission_providers.g.dart";

@riverpod
SubmissionRepository submissionRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final firestore = ref.watch(firestoreCollectionProvider("submission").notifier);
  final crashlytics = ref.watch(crashlyticsProvider);
  return SubmissionRepository(
    isar,
    firestore,
    crashlytics,
    ref.watch(firestoreErrorProvider.notifier),
  );
}
