import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../infrastructure/core_providers.dart";
import "../../submission/models/submission.dart";
import "../models/digestive_with_submission.dart";
import "../models/isar_digestive.dart";
import "../repositories/digestive_providers.dart";

part "undone_digestives_with_submission.g.dart";

/// 未完了の Digestive リストを Submission 情報と結合して Stream で返す。
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
