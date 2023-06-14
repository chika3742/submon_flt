import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:submon/auth/sign_in_handler.dart';
import 'package:submon/components/dropdown_time_picker_bottom_sheet.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/messaging.dart';
import 'package:submon/pages/settings/account_edit_page.dart';
import 'package:submon/pages/settings/account_link_page.dart';
import 'package:submon/pages/settings/google_tasks.dart';
import 'package:submon/pages/settings/timetable.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/ui_components/settings_ui.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../../user_config.dart';

class FunctionsSettingsPage extends StatefulWidget {
  const FunctionsSettingsPage({Key? key}) : super(key: key);

  static const routeName = "/settings/functions";

  @override
  State<FunctionsSettingsPage> createState() => _FunctionsSettingsPageState();
}

class _FunctionsSettingsPageState extends State<FunctionsSettingsPage> {
  bool _pwEnabled = true;
  bool? _enableSE;
  TimeOfDay? _reminderTime;
  bool _loadingReminderTime = true;
  Timer? _signInStateCheckTimer;
  bool? _deviceCameraUIShouldBeUsed;

  StreamSubscription? _accountListener;

  @override
  void initState() {
    super.initState();
    SharedPrefs.use((prefs) {
      setState(() {
        _enableSE = prefs.isSEEnabled;
        _deviceCameraUIShouldBeUsed =
            Platform.isAndroid ? prefs.isDeviceCameraUIShouldBeUsed : null;
      });
    });

    FirestoreProvider.config.then((value) {
      setState(() {
        _reminderTime = value!.reminderNotificationTime;
      });
    }).onError<FirebaseException>((error, stackTrace) {
      handleFirebaseError(error, stackTrace, context, "リマインダー設定の取得に失敗しました。");
    }).whenComplete(() {
      setState(() {
        _loadingReminderTime = false;
      });
    });
  }

  @override
  void dispose() {
    _accountListener?.cancel();
    _signInStateCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    var displayName = auth.currentUser?.displayName;

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
                var requestPermissionResult =
                    await MessagingPlugin.requestNotificationPermission();
                if (requestPermissionResult ==
                    NotificationPermissionState.denied) {
                  showSnackBar(
                      globalContext!, "通知の表示が許可されていません。本体設定から許可してください。");
                } else {
                  var result = await showRoundedBottomSheet<TimeOfDay>(
                    context: context,
                    title: "リマインダー通知時刻",
                    child: DropdownTimePickerBottomSheet(
                      initialTime: _reminderTime,
                    ),
                  );

                  print(result);

                  if (result != null) {
                    // NotificationMethodChannel.registerReminder();
                    setState(() {
                      _loadingReminderTime = true;
                    });
                    try {
                      await FirestoreProvider.setReminderNotificationTime(
                          result);
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
          if (auth.currentUser != null && !auth.currentUser!.isAnonymous)
            SettingsTile(
              title: "ログアウト",
              onTap: () async {
                showSimpleDialog(context, "確認", "ログアウトしますか？",
                    onOKPressed: () async {
                  await SignInHandler.signOut();
                  showSnackBar(globalContext!, "ログアウトしました");
                }, showCancel: true);
              },
            ),
          if (auth.currentUser != null &&
              auth.currentUser!.email != "" &&
              !auth.currentUser!.isAnonymous)
            SettingsTile(
              title: emailChangeable() ? "メールアドレスの変更" : "メールアドレス",
              subtitle: auth.currentUser!.email,
              onTap: emailChangeable()
                  ? () async {
                      await Navigator.pushNamed(
                          context, AccountEditPage.changeEmailRouteName);
                      setState(() {});
                    }
                  : null,
            ),
          if (auth.currentUser != null && passwordChangeable() && _pwEnabled)
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
          if (auth.currentUser != null)
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
          if (auth.currentUser != null && auth.currentUser!.isAnonymous)
            SettingsTile(
              title: "アカウントをアップグレード",
              subtitle: "お試しアカウントを通常アカウントにアップグレードできます。",
              onTap: () async {
                var result = await Navigator.pushNamed(
                    context, SignInPage.routeName,
                    arguments: const SignInPageArguments(SignInMode.upgrade));
                if (result == true) {
                  setState(() {});
                  showSnackBar(globalContext!, "アカウントがアップグレードされました！");
                }
              },
            ),
          if (auth.currentUser != null)
            SettingsTile(
              title: auth.currentUser!.isAnonymous
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
        SettingsCategory(title: "その他の機能", tiles: [
          if (_enableSE != null)
            SwitchSettingsTile(
              title: "SEを有効にする",
              subtitle: "一部操作時にサウンドを再生します",
              value: _enableSE!,
              onChanged: (value) {
                SharedPrefs.use((prefs) {
                  prefs.isSEEnabled = value;
                });
                FirestoreProvider.updateUserConfig(
                    UserConfig.pathIsSEEnabled, value);
                setState(() {
                  _enableSE = value;
                });
              },
            ),
          SettingsTile(
            title: "時間割表設定",
            onTap: () {
              Navigator.pushNamed(context, TimetableSettingsPage.routeName);
            },
          ),
          if (_deviceCameraUIShouldBeUsed != null)
            CheckBoxSettingsTile(
              title: "端末側の撮影UIを使用",
              subtitle: "暗記カードのカメラ入力時、端末側の撮影画面を使用して撮影します。",
              value: _deviceCameraUIShouldBeUsed!,
              onChanged: (value) {
                SharedPrefs.use((prefs) {
                  prefs.isDeviceCameraUIShouldBeUsed = value!;
                });
                setState(() {
                  _deviceCameraUIShouldBeUsed = value!;
                });
              },
            ),
        ])
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
          FirestoreProvider.setReminderNotificationTime(null);
        },
      );
    }

    return null;
  }

  void _changePassword() async {
    var auth = FirebaseAuth.instance;
    showLoadingModal(context);
    try {
      var provider =
          await auth.fetchSignInMethodsForEmail(auth.currentUser!.email!);
      if (provider.isEmpty) throw FirebaseAuthException(code: "user-not-found");
      Navigator.pop(globalContext!);
      if (provider.first == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD) {
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
      handleAuthError(e, stack, context);
    } catch (e, stack) {
      showSnackBar(context, "エラーが発生しました");
      recordErrorToCrashlytics(e, stack);
    }
  }

  bool emailChangeable() {
    var providers = [
      EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD,
      EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD
    ];
    var currentUser = FirebaseAuth.instance.currentUser!;
    return !currentUser.isAnonymous &&
        providers.contains(currentUser.providerData.firstOrNull?.providerId);
  }

  bool passwordChangeable() {
    var currentUser = FirebaseAuth.instance.currentUser!;
    return !currentUser.isAnonymous &&
        currentUser.providerData.firstOrNull?.providerId ==
            EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD;
  }
}
