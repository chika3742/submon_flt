import "package:cloud_firestore/cloud_firestore.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../infrastructure/firebase_providers.dart";
import "../models/submission_share_data.dart";

part "submission_share_link_repository.g.dart";

/// Fetches submission data from a share link.
///
/// The Firestore-to-domain conversion (e.g. `Timestamp` -> [DateTime]) is done
/// here so [SubmissionShareData] stays persistence-independent.
@riverpod
Future<SubmissionShareData?> submissionShareLink(Ref ref, String id) async {
  final snapshot =
      await ref.watch(firestoreProvider).doc("submissionShares/$id").get();
  if (!snapshot.exists) return null;
  final data = snapshot.data()!;
  return SubmissionShareData(
    title: data["title"] as String,
    due: (data["due"] as Timestamp).toDate(),
    details: data["details"] as String?,
  );
}
