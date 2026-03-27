import "package:cloud_firestore/cloud_firestore.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:isar_community/isar.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/pref_key.dart";
import "../../../providers/core_providers.dart";
import "../../../providers/firestore_providers.dart";
import "../../../providers/pref_provider.dart";
import "../../../src/pigeons.g.dart";
import "../../../user_config.dart";

part "complete_sign_in_use_case.g.dart";
part "complete_sign_in_use_case.freezed.dart";

@freezed
sealed class CompleteSignInResult with _$CompleteSignInResult {
  const factory CompleteSignInResult({
    required bool newUser,
    required bool notificationPermissionDenied,
  }) = _CompleteSignInResult;
}

@Riverpod(keepAlive: true)
CompleteSignInUseCase completeSignInUseCase(Ref ref) {
  return CompleteSignInUseCase(
    ref.watch(prefProvider(PrefKey.firestoreLastChanged).notifier),
    ref.watch(isarProvider).requireValue,
    ref.watch(messagingApiProvider),
    ref.watch(generalApiProvider),
    ref.watch(firestoreUserConfigProvider.notifier),
    ref.watch(userDocProvider),
  );
}

class CompleteSignInUseCase {
  final PrefAccessor<int?> _firestoreLastChangedPref;
  final Isar _isar;
  final MessagingApi _messagingApi;
  final GeneralApi _generalApi;
  final FirestoreUserConfigUpdater _userConfigUpdater;
  final DocumentReference<Map<String, dynamic>>? _userDoc;

  const CompleteSignInUseCase(
    this._firestoreLastChangedPref,
    this._isar,
    this._messagingApi,
    this._generalApi,
    this._userConfigUpdater,
    this._userDoc,
  );

  Future<CompleteSignInResult> execute() async {
    UserConfig? userConfig;
    bool signUpNeeded = false;

    // Firestore からユーザー設定を直接読み取る（StreamNotifier の .future を経由しない）
    if (_userDoc != null) {
      try {
        final snapshot = await _userDoc.withConverter<UserConfig>(
          fromFirestore: UserConfig.fromFirestore,
          toFirestore: (config, options) => config.toFirestore(),
        ).get();
        userConfig = snapshot.data();
      } on FirebaseException catch (e) {
        if (e.code == "permission-denied") {
          signUpNeeded = true;
        } else {
          throw CompleteSignInException(e);
        }
      }
    }


    if (signUpNeeded) {
      await _userConfigUpdater.initializeUser();
    }

    // Clear the last changed timestamp to force fetching the latest user data
    // from Firestore.
    _firestoreLastChangedPref.update(null);

    // Clear local data
    await _isar.writeTxn(() async {
      await _isar.clear();
    });

    final notificationToken = await _messagingApi.getToken();
    await _userConfigUpdater.saveNotificationToken(notificationToken);

    _generalApi.updateWidgets();

    bool permissionDenied = false;

    if (userConfig case final userConfig?) {
      final requestResult = await _requestNotificationPermissionIfNeeded(userConfig);
      permissionDenied = requestResult == NotificationPermissionState.denied;
    }

    return CompleteSignInResult(
      newUser: signUpNeeded,
      notificationPermissionDenied: permissionDenied,
    );
  }

  Future<NotificationPermissionState?> _requestNotificationPermissionIfNeeded(
      UserConfig userConfig) async {
    if (userConfig.reminderNotificationTime != null ||
        userConfig.timetableNotificationTime != null ||
        userConfig.digestiveNotifications.isNotEmpty) {
      return (await _messagingApi.requestNotificationPermission())?.value;
    }
    return null;
  }
}

class CompleteSignInException implements Exception {
  final Object cause;

  const CompleteSignInException(this.cause);

  @override
  String toString() => "Failed to complete sign-in: $cause";
}
