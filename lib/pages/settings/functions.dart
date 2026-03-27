import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../browser.dart";
import "../../components/dropdown_time_picker_bottom_sheet.dart";
import "../../features/auth/use_cases/common.dart";
import "../../features/auth/use_cases/sign_out_use_case.dart";
import "../../main.dart";
import "../../providers/core_providers.dart";
import "../../providers/firestore_providers.dart";
import "../../src/pigeons.g.dart";
import "../../ui_components/settings_ui.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";
import "../sign_in_page.dart";
import "account_edit_page.dart";
import "account_link_page.dart";
import "google_tasks.dart";
import "timetable.dart";

class FunctionsSettingsPage extends ConsumerStatefulWidget {
  const FunctionsSettingsPage({super.key});

  static const routeName = "/settings/functions";

  @override
  ConsumerState<FunctionsSettingsPage> createState() =>
      _FunctionsSettingsPageState();
}

class _FunctionsSettingsPageState extends ConsumerState<FunctionsSettingsPage> {
  bool _pwEnabled = true;
  TimeOfDay? _reminderTime;
  bool _loadingReminderTime = true;
  Timer? _signInStateCheckTimer;

  StreamSubscription? _accountListener;

  @override
  void initState() {
    super.initState();
    // TODO: hooksを使ってbuild関数内で完結できるようにする
    _initReminderTime();
  }

  Future<void> _initReminderTime() async {
    try {
      final config = await ref.read(firestoreUserConfigProvider.future);
      if (!mounted) return;
      setState(() {
        _reminderTime = config?.reminderNotificationTime;
      });
    } on FirebaseException catch (e, stackTrace) {
      ref.read(crashlyticsProvider).recordError(e, stackTrace);
      if (!context.mounted) return;
      switch (e.code) {
        case "permission-denied":
          showFirestoreReadFailedDialog(
            context,
            "リマインダー設定の取得に失敗しました。",
            onSignOut: () async {
              await ref.read(signOutUseCaseProvider).execute();
            },
            onShowAnnouncements: () {
              Browser.openAnnouncements();
              SystemChannels.platform.invokeMethod("SystemNavigator.pop");
            },
          );
        default:
          showSnackBar(context, "リマインダー設定の取得に失敗しました。(${e.code})",
              duration: const Duration(seconds: 20));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingReminderTime = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _accountListener?.cancel();
    _signInStateCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseUserProvider).value;
    final displayName = user?.displayName;

    return SettingsListView(
      categories: [
        SettingsCategory(
          title: "リマインダー通知",
          tiles: [
            SettingsTile(
                subtitle: "設定した時刻にリマインダー通知をします。期限が近づいた提出物がある場合、その一覧を通知します。"),
            SettingsTile(
              title: "通知時刻",
              enabled: !_loadingReminderTime,
              subtitle: getUnsetOrString(
                  _reminderTime?.format(context), _loadingReminderTime),
              leading: const Icon(Icons.schedule),
              trailing: _buildReminderTimeTrailing(),
              onTap: () async {
                // check permission
                final requestPermissionResult =
                    await MessagingApi().requestNotificationPermission();
                if (requestPermissionResult?.value !=
                    NotificationPermissionState.granted) {
                  showSnackBar(
                      globalContext!, "通知の表示が許可されていません。本体設定から許可してください。");
                } else {
                  if (!context.mounted) return;

                  // show time picker for reminder time
                  final result = await showRoundedBottomSheet<TimeOfDay>(
                    context: context,
                    title: "リマインダー通知時刻",
                    child: DropdownTimePickerBottomSheet(
                      initialTime: _reminderTime,
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      _loadingReminderTime = true;
                    });
                    try {
                      await ref
                          .read(firestoreUserConfigProvider.notifier)
                          .setReminderNotificationTime(result);
                      setState(() {
                        _reminderTime = result;
                      });
                    } catch (e) {
                      showSnackBar(globalContext!, "設定に失敗しました");
                    }
                    setState(() {
                      _loadingReminderTime = false;
                    });
                  }
                }
              },
            ),
          ],
        ),
        SettingsCategory(title: "アカウント", tiles: [
          if (user != null && !user.isAnonymous)
            SettingsTile(
              title: "ログアウト",
              onTap: () {
                showSimpleDialog(
                  context,
                  "ログアウト",
                  "ログアウトしますか？",
                  onOKPressed: () async {
                    await ref.read(signOutUseCaseProvider).execute();
                    if (context.mounted) {
                      showSnackBar(context, "ログアウトしました");
                    }
                  },
                  showCancel: true,
                );
              },
            ),
          if (user != null &&
              user.email != "" &&
              !user.isAnonymous)
            SettingsTile(
              title: emailChangeable() ? "メールアドレスの変更" : "メールアドレス",
              subtitle: user.email,
              onTap: emailChangeable()
                  ? () async {
                      await Navigator.pushNamed(
                          context, AccountEditPage.changeEmailRouteName);
                      setState(() {});
                    }
                  : null,
            ),
          if (user != null && passwordChangeable() && _pwEnabled)
            SettingsTile(
              title: "パスワードの変更",
              onTap: () {
                _changePassword();
              },
            ),
          SettingsTile(
              title: "外部アカウント連携設定",
              onTap: () async {
                await Navigator.pushNamed(context, AccountLinkPage.routeName);
                setState(() {});
              }),
          if (user != null)
            SettingsTile(
              title: "ユーザー名の変更",
              subtitle: displayName != null && displayName.isNotEmpty
                  ? displayName
                  : "未設定",
              onTap: () async {
                await Navigator.pushNamed(
                    context, AccountEditPage.changeDisplayNameRouteName);
                setState(() {});
              },
            ),
          if (user != null && user.isAnonymous)
            SettingsTile(
              title: "アカウントをアップグレード",
              subtitle: "お試しアカウントを通常アカウントにアップグレードできます。",
              onTap: () async {
                final result = await Navigator.pushNamed(
                    context, SignInPage.routeName,
                    arguments: const SignInPageArguments(AuthMode.upgrade));
                if (result == true) {
                  setState(() {});
                  showSnackBar(globalContext!, "アカウントがアップグレードされました！");
                }
              },
            ),
          if (user != null)
            SettingsTile(
              title: user.isAnonymous
                  ? "ログアウト(アカウントの削除)"
                  : "アカウントの削除",
              titleTextStyle: const TextStyle(color: Colors.red),
              onTap: () async {
                await Navigator.pushNamed(
                    context, AccountEditPage.deleteRouteName);
                setState(() {});
              },
            ),
        ]),
        SettingsCategory(title: "Google Tasks連携", tiles: [
          SettingsTile(
            title: "Google Tasks連携設定",
            subtitle:
                "Google Tasksへ提出物を追加し、Google TasksおよびGoogle カレンダーに表示できます。",
            onTap: () async {
              Navigator.pushNamed(context, GoogleTasksSettingsPage.routeName);
            },
          ),
        ]),
        SettingsCategory(
          title: "その他の機能",
          tiles: [
            SettingsTile(
              title: "時間割表設定",
              onTap: () {
                Navigator.pushNamed(context, TimetableSettingsPage.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget? _buildReminderTimeTrailing() {
    if (_loadingReminderTime) {
      return const CircularProgressIndicator();
    }

    if (_reminderTime != null) {
      return IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _reminderTime = null;
          });
          // NotificationMethodChannel.unregisterReminder();
          ref
              .read(firestoreUserConfigProvider.notifier)
              .setReminderNotificationTime(null);
        },
      );
    }

    return null;
  }

  Future<void> _changePassword() async {
    final user = ref.read(firebaseUserProvider).requireValue!;
    showLoadingModal(context);
    try {
      final providerData = user.providerData;
      if (providerData.isEmpty) throw FirebaseAuthException(code: "user-not-found");
      Navigator.pop(globalContext!);
      if (providerData.first.providerId == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD) {
        await Navigator.pushNamed(
            globalContext!, AccountEditPage.changePasswordRouteName);
        setState(() {});
      } else {
        setState(() {
          _pwEnabled = false;
        });
        showSnackBar(globalContext!, "パスワードレス アカウントでパスワードの変更はできません");
      }
    } on FirebaseAuthException catch (e, stack) {
      Navigator.pop(context);
      if (e.code == "user-not-found") {
        showSnackBar(context, "ユーザーが見つかりません。再度ログインしてください。");
      } else {
        showSnackBar(context, "アカウント状態の取得に失敗しました (Code: ${e.code})");
      }
      ref.read(crashlyticsProvider).recordError(e, stack);
    } catch (e, stack) {
      showSnackBar(context, "エラーが発生しました");
      ref.read(crashlyticsProvider).recordError(e, stack);
    }
  }

  bool emailChangeable() {
    final providers = [
      EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD,
      EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD
    ];
    final currentUser = ref.read(firebaseUserProvider).requireValue!;
    return !currentUser.isAnonymous
        && currentUser.providerData.any((p) => providers.contains(p.providerId));
  }

  bool passwordChangeable() {
    final currentUser = ref.read(firebaseUserProvider).requireValue!;
    return !currentUser.isAnonymous &&
        currentUser.providerData.firstOrNull?.providerId ==
            EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD;
  }
}
