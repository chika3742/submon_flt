import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../infrastructure/core_providers.dart";
import "../../../infrastructure/firebase_providers.dart";
import "../../../infrastructure/firestore_error_notifier.dart";
import "../../../infrastructure/firestore_providers.dart";
import "../models/isar_digestive.dart";
import "digestive_repository.dart";

part "digestive_providers.g.dart";

@riverpod
DigestiveRepository digestiveRepository(Ref ref) {
  final isar = ref.watch(isarProvider).requireValue;
  final firestore =
      ref.watch(firestoreCollectionProvider("digestive").notifier);
  final userConfig = ref.watch(firestoreUserConfigProvider.notifier);
  final crashlytics = ref.watch(crashlyticsProvider);
  return DigestiveRepository(
    isar,
    firestore,
    crashlytics,
    ref.watch(firestoreErrorProvider.notifier),
    userConfig,
  );
}

@riverpod
Stream<List<Digestive>> undoneDigestives(Ref ref) {
  final repo = ref.watch(digestiveRepositoryProvider);
  return repo.collection
      .filter()
      .doneEqualTo(false)
      .sortByStartAt()
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Digestive>> doneDigestives(Ref ref) {
  final repo = ref.watch(digestiveRepositoryProvider);
  return repo.collection
      .filter()
      .doneEqualTo(true)
      .sortByStartAtDesc()
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Digestive>> digestivesBySubmission(Ref ref, int submissionId) {
  final repo = ref.watch(digestiveRepositoryProvider);
  return repo.collection
      .filter()
      .submissionIdEqualTo(submissionId)
      .sortByStartAt()
      .watch(fireImmediately: true);
}
