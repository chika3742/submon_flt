import "dart:async";

import "package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:googleapis/tasks/v1.dart";
import "package:googleapis_auth/googleapis_auth.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../providers/core_providers.dart";
import "../models/tasks_auth_exception.dart";

part "tasks_auth_notifier.g.dart";

@riverpod
class TasksAuthNotifier extends _$TasksAuthNotifier {
  static const scopes = [TasksApi.tasksScope];

  @override
  Future<AuthClient?> build() async {
    final gsi = ref.watch(googleSignInProvider);

    return await _authClient(gsi);
  }

  Future<AuthClient?> _authClient(GoogleSignIn gsi) async {
    final authorization = await gsi.authorizationClient.authorizationForScopes(scopes);
    return authorization?.authClient(scopes: scopes);
  }

  Future<bool> connect() async {
    final gsi = ref.watch(googleSignInProvider);
    try {
      // request sign in to user
      await gsi.authenticate(scopeHint: scopes);

      // check the scope is granted
      if (await _authClient(gsi) == null) {
        await gsi.authorizationClient.authorizeScopes(scopes);
      }
    } on GoogleSignInException catch (e, st) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return false;
      }
      await ref.watch(crashlyticsProvider).recordError(e, st);
      throw TasksAuthException(TasksAuthErrorCode.fromGoogleSignInErrorCode(e.code));
    }

    ref.invalidateSelf();
    return true;
  }

  Future<void> disconnect() async {
    final gsi = ref.read(googleSignInProvider);
    await gsi.disconnect();
    // Directly set state to null instead of invalidateSelf() to avoid re-running
    // build(), which may return a non-null AuthClient with the now-revoked token.
    state = const AsyncData(null);
  }
}
