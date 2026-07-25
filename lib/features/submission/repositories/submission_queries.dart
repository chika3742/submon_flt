import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../models/submission.dart";
import "submission_providers.dart";

part "submission_queries.g.dart";

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
