import "dart:async";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:googleapis/oauth2/v2.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/failure.dart";
import "../../../utils/notifier_state_guard.dart";
import "../models/tasks_auth_exception.dart";
import "../repositories/tasks_auth_notifier.dart";

part "google_tasks_link_state_notifier.freezed.dart";
part "google_tasks_link_state_notifier.g.dart";

@freezed
sealed class GoogleTasksUser with _$GoogleTasksUser {
  const factory GoogleTasksUser({
    required String email,
  }) = _GoogleTasksUser;
}

@riverpod
Future<GoogleTasksUser?> connectedGoogleTasksUser(Ref ref) async {
  final client = await ref.watch(tasksAuthProvider.future);
  if (client == null) return null;

  try {
    final userInfo = await Oauth2Api(client).userinfo.v2.me
        .get($fields: "email");

    return GoogleTasksUser(email: userInfo.email ?? "Unknown");
  } catch (e) {
    throw TasksAuthException(TasksAuthErrorCode.failedToFetchUserEmail);
  }
}

@freezed
sealed class GoogleTasksLinkProcessState with _$GoogleTasksLinkProcessState {
  const factory GoogleTasksLinkProcessState.idle() = GoogleTasksLinkProcessStateIdle;

  const factory GoogleTasksLinkProcessState.loading() = GoogleTasksLinkProcessStateLoading;

  @Implements<ErrorState>()
  const factory GoogleTasksLinkProcessState.failed(
    Object error,
    StackTrace errorStackTrace,
  ) = GoogleTasksLinkProcessStateFailed;

  const factory GoogleTasksLinkProcessState.connected() = GoogleTasksLinkProcessStateConnected;

  const factory GoogleTasksLinkProcessState.disconnected() = GoogleTasksLinkProcessStateDisconnected;
}

@riverpod
class GoogleTasksLinkProcessStateNotifier extends _$GoogleTasksLinkProcessStateNotifier
    with NotifierStateGuard {
  @override
  GoogleTasksLinkProcessState build() => GoogleTasksLinkProcessState.idle();

  @override
  GoogleTasksLinkProcessState getErrorState(Object error, StackTrace st) {
    return GoogleTasksLinkProcessState.failed(error, st);
  }

  void connect() {
    final authNotifier = ref.read(tasksAuthProvider.notifier);
    guard(GoogleTasksLinkProcessState.loading(), () async {
      final result = await authNotifier.connect();
      if (!result) return GoogleTasksLinkProcessState.idle();
      return GoogleTasksLinkProcessState.connected();
    });
  }

  void disconnect() {
    final authNotifier = ref.read(tasksAuthProvider.notifier);
    guard(GoogleTasksLinkProcessState.loading(), () async {
      await authNotifier.disconnect();
      return GoogleTasksLinkProcessState.disconnected();
    });
  }
}
