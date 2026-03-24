import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../providers/core_providers.dart";
import "../../../providers/firestore_providers.dart";
import "../../../src/pigeons.g.dart";
import "../repositories/auth_repository.dart";

part "sign_out_use_case.g.dart";

@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(
    ref.watch(authRepositoryProvider),
    ref.watch(messagingApiProvider),
    ref.watch(generalApiProvider),
    ref.watch(firestoreUserConfigProvider.notifier),
  );
}

class SignOutUseCase {
  final AuthRepository _authRepository;
  final MessagingApi _messagingApi;
  final GeneralApi _generalApi;
  final FirestoreUserConfigUpdater _userConfigUpdater;

  const SignOutUseCase(
    this._authRepository,
    this._messagingApi,
    this._generalApi,
    this._userConfigUpdater,
  );

  /// サインアウトを実行する。
  ///
  /// 1. 通知トークン削除（signOut 前に Firestore アクセスが必要）
  /// 2. Firebase / Google サインアウト
  /// 3. ウィジェット更新
  ///
  /// 画面遷移は呼び出し元の責務。
  Future<void> execute() async {
    final token = await _messagingApi.getToken();
    await _userConfigUpdater.removeNotificationToken(token);
    await _authRepository.signOut();
    _generalApi.updateWidgets();
  }
}
