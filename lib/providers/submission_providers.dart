import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../isar_db/isar_submission.dart";
import "../repositories/submission_repository.dart";
import "core_providers.dart";
import "digestive_providers.dart";
import "firestore_providers.dart";

part "submission_providers.g.dart";

@riverpod
SubmissionRepository submissionRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final firestore = ref.watch(firestoreProvider("submission").notifier);
  final authClient = ref.watch(googleAuthenticatedClientProvider).value;
  return SubmissionRepository(
    isar,
    firestore,
    authClient,
    ref.watch(digestiveRepositoryProvider),
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
