import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../isar_db/isar_submission.dart";
import "../../../providers/functions_service.dart";

part "create_submission_share_link_state_notifier.g.dart";

@riverpod
class CreateSubmissionShareLinkStateNotifier
    extends _$CreateSubmissionShareLinkStateNotifier {
  @override
  Future<({String url, String title})?> build() async => null;

  Future<void> execute(Submission submission) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final link = await ref.read(functionsServiceProvider)
          .createShareLink(
            FunctionsService.submissionToShareLinkData(submission),
          );
      return (url: link, title: submission.title);
    });
  }
}