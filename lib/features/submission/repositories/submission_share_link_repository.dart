import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../infrastructure/firebase_providers.dart";
import "../models/submission_share_data.dart";

part "submission_share_link_repository.g.dart";

/// Fetches submission data from a share link.
@riverpod
Future<SubmissionShareData?> submissionShareLink(Ref ref, String id) async {
  final snapshot =
      await ref.watch(firestoreProvider).doc("submissionShares/$id").get();
  if (!snapshot.exists) return null;
  return SubmissionShareData.fromMap(snapshot.data()!);
}
