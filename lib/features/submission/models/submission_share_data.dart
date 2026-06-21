import "package:cloud_firestore/cloud_firestore.dart";

/// Submission payload fetched from a share link (Firestore `submissionShares`).
///
/// This is a read-only view used when opening a shared submission; it is not the
/// full [Submission] domain model.
class SubmissionShareData {
  final String title;
  final DateTime due;
  final String? details;

  const SubmissionShareData({
    required this.title,
    required this.due,
    this.details,
  });

  factory SubmissionShareData.fromMap(Map<String, dynamic> data) {
    return SubmissionShareData(
      title: data["title"] as String,
      due: (data["due"] as Timestamp).toDate(),
      details: data["details"] as String?,
    );
  }
}
