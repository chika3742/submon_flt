import "package:cloud_firestore/cloud_firestore.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "submission_share_link_provider.g.dart";

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

/// 共有リンクから提出物データを取得する。
@riverpod
Future<SubmissionShareData?> submissionShareLink(Ref ref, String id) async {
  final snapshot =
      await FirebaseFirestore.instance.doc("submissionShares/$id").get();
  if (!snapshot.exists) return null;
  return SubmissionShareData.fromMap(snapshot.data()!);
}
