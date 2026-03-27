import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../isar_db/isar_digestive.dart";
import "../isar_db/isar_submission.dart";
import "../pages/home_tabs/tab_digestive_list.dart";
import "../repositories/digestive_repository.dart";
import "core_providers.dart";
import "firebase_providers.dart";
import "firestore_error_notifier.dart";
import "firestore_providers.dart";

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

/// Digestive リストを Submission 情報と結合して Stream で返す。
@riverpod
Stream<List<DigestiveWithSubmission>> undoneDigestivesWithSubmission(
  Ref ref,
) {
  final repo = ref.watch(digestiveRepositoryProvider);
  final isar = ref.watch(isarProvider).requireValue;

  return repo.collection
      .filter()
      .doneEqualTo(false)
      .sortByStartAt()
      .watch(fireImmediately: true)
      .asyncMap((digestives) async {
    final ids =
        digestives.map((d) => d.submissionId).whereType<int>().toSet().toList();
    final submissions = await isar.submissions.getAll(ids);
    final submissionMap = Map.fromIterables(ids, submissions);

    return digestives
        .map((d) => DigestiveWithSubmission.fromObject(
              d,
              d.submissionId != null ? submissionMap[d.submissionId] : null,
            ))
        .toList();
  });
}
