import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../infrastructure/core_providers.dart";
import "../infrastructure/firebase_providers.dart";
import "../infrastructure/firestore_error_notifier.dart";
import "../infrastructure/firestore_providers.dart";
import "../isar_db/isar_submission.dart";
import "../repositories/submission_repository.dart";

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

@riverpod
Stream<List<Submission>> undoneSubmissions(Ref ref) {
  final repo = ref.watch(submissionRepositoryProvider);
  return repo.collection
      .filter()
      .doneEqualTo(false)
      .sortByImportantDesc()
      .thenByDue()
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Submission>> doneSubmissions(Ref ref) {
  final repo = ref.watch(submissionRepositoryProvider);
  return repo.collection
      .filter()
      .doneEqualTo(true)
      .sortByDueDesc()
      .watch(fireImmediately: true);
}

@riverpod
Stream<Submission?> submission(Ref ref, int id) {
  final repo = ref.watch(submissionRepositoryProvider);
  return repo.collection.watchObject(id, fireImmediately: true);
}
