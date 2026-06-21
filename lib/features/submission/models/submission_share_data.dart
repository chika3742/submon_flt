/// Submission payload fetched from a share link (Firestore `submissionShares`).
///
/// A plain, persistence-independent value object. The Firestore-to-domain
/// conversion (e.g. `Timestamp` -> [DateTime]) lives in the repository layer.
class SubmissionShareData {
  final String title;
  final DateTime due;
  final String? details;

  const SubmissionShareData({
    required this.title,
    required this.due,
    this.details,
  });
}
