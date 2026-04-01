import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../features/auth/models/auth_continue_destination.dart";
import "../../features/auth/models/auth_exception.dart";
import "../../features/auth/presentation/auth_messages.dart";
import "../../features/auth/repositories/auth_repository.dart";
import "../../features/auth/use_cases/common.dart";
import "../../providers/firebase_providers.dart";
import "../../utils/ui.dart";
import "../sign_in_page.dart";

class AccountEditPage extends ConsumerStatefulWidget {
  AccountEditPage(this.type, {super.key, AccountEditPageArguments? args})
      : initialEmail = args?.initialEmail;

  static const changeEmailRouteName = "/account/changeEmail";
  static const changePasswordRouteName = "/account/changePassword";
  static const changeDisplayNameRouteName = "/account/changeDisplayName";
  static const deleteRouteName = "/account/delete";

  final String? initialEmail;

  final EditingType type;

  @override
  ConsumerState<AccountEditPage> createState() => _AccountEditPageState();
}

class AccountEditPageArguments {
  final String? initialEmail;

  AccountEditPageArguments(this.initialEmail);
}

class _AccountEditPageState extends ConsumerState<AccountEditPage> {
  final _form1Controller = TextEditingController();
  String? _form1Error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == EditingType.changeDisplayName) {
      _form1Controller.text =
          ref.read(firebaseUserProvider).value?.displayName ?? "";
    }
    if (widget.type == EditingType.changeEmail && widget.initialEmail != null) {
      _form1Controller.text = widget.initialEmail!;
      Future(() {
        changeEmail();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final delete = widget.type == EditingType.delete;
    return Scaffold(
        appBar: AppBar(
          title: Text(getTitle()),
        ),
        body: Stack(
          children: [
            if (_loading) const LinearProgressIndicator(),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: buildContent(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton.extended(
                  icon: Icon(delete ? Icons.delete : Icons.send,
                      color: delete ? Colors.white : null),
                  label: Text(delete ? "削除" : "送信",
                      style: TextStyle(color: delete ? Colors.white : null)),
                  backgroundColor: delete ? Colors.redAccent : null,
                  onPressed: !_loading
                      ? () {
                          switch (widget.type) {
                            case EditingType.changeEmail:
                              changeEmail();
                              break;
                            case EditingType.changePassword:
                              changePassword();
                              break;
                            case EditingType.changeDisplayName:
                              changeDisplayName();
                              break;
                            case EditingType.delete:
                              deleteAccount();
                          }
                        }
                      : null,
                ),
              ),
            ),
          ],
        ));
  }

  String getTitle() {
    switch (widget.type) {
      case EditingType.changeEmail:
        return "メールアドレスの変更";
      case EditingType.changePassword:
        return "パスワードの変更";
      case EditingType.changeDisplayName:
        return "ユーザー名の変更";
      case EditingType.delete:
        return "アカウントの削除";
    }
  }

  Widget buildContent() {
    switch (widget.type) {
      case EditingType.changeEmail:
        return buildChangeEmail();
      case EditingType.changePassword:
        return buildChangePassword();
      case EditingType.changeDisplayName:
        return buildChangeDisplayName();
      case EditingType.delete:
        return buildDelete();
    }
  }

  // Change email
  Widget buildChangeEmail() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text.rich(TextSpan(
        children: const [
          TextSpan(text: "メールアドレスを変更します。\n\n"),
          TextSpan(
              text: "「送信」をタップすると、変更先のメールアドレスに確認メールが"
                  "届きます。そのメール内にあるリンクをタップすることで変更が完了します。"),
          TextSpan(
              text: "「送信」のタップのみでは変更は完了しませんのでご注意ください。\n\n",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.redAccent)),
          TextSpan(
              text: "※メールは「submon.app」ドメインから送信されます。迷惑メールに振り分けられていないか確認してください。"),
        ],
        style: Theme.of(context).textTheme.bodyLarge,
      )),
      const SizedBox(height: 16),
      TextFormField(
        controller: _form1Controller,
        enabled: !_loading,
        decoration: InputDecoration(
          errorText: _form1Error,
          label: const Text("メールアドレス"),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 80),
    ]);
  }

  Future<void> changeEmail() async {
    setState(() {
      if (_form1Controller.text.isEmpty) {
        _form1Error = "入力してください";
      } else {
        _form1Error = null;
      }
    });
    if (_form1Error != null) return;

    setState(() {
      _loading = true;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .verifyBeforeUpdateEmail(_form1Controller.text);

      if (!mounted) return;
      showSnackBar(context, "入力されたメールアドレスに確認メールを送信しました。ご確認ください。");
      Navigator.pop(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      switch (e.code) {
        case AuthErrorCode.requiresRecentLogin:
          showSnackBar(context, e.code.userFriendlyMessage);
          final result = await Navigator.pushNamed(
            context,
            SignInPage.routeName,
            arguments: SignInPageArguments(
              AuthMode.reauthenticate,
              continueUri: AuthContinueDestination.changeEmail(
                newEmail: _form1Controller.text,
              ).toUri(),
            ),
          );
          if (result == true) {
            await changeEmail();
          } else {
            if (mounted) Navigator.pop(context);
          }
        case AuthErrorCode.invalidEmail:
        case AuthErrorCode.emailAlreadyInUse:
          _form1Error = e.code.userFriendlyMessage;
        default:
          showSnackBar(context, authErrorMessage(e));
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, authErrorMessage(e));
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  // Change password
  Widget buildChangePassword() {
    return Text(
        "パスワードを変更します。\n\n"
        "「送信」をタップすると、登録されているメールアドレスにパスワード変更URLが記載されたメールを送信します。"
        "このURLをタップすることでパスワードを変更できます。\n\n"
        "※メールは「submon.app」ドメインから届きます。迷惑メールに振り分けられていないかご確認ください。",
        style: Theme.of(context).textTheme.bodyLarge);
  }

  Future<void> changePassword() async {
    setState(() {
      _loading = true;
    });
    try {
      final email = ref.read(firebaseUserProvider).value?.email;
      if (email == null) return;
      await ref.read(authRepositoryProvider).sendPasswordResetLink(email);

      if (!mounted) return;
      showSnackBar(context, "送信しました。ご確認ください。");
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, authErrorMessage(e));
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  // Change display name
  Widget buildChangeDisplayName() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("ユーザー名を変更します。この名称は、アカウントの編集を行った際に運営から届く各種メールに記載されます。"),
      const SizedBox(height: 16),
      TextFormField(
        controller: _form1Controller,
        enabled: !_loading,
        decoration: InputDecoration(
            errorText: _form1Error,
            label: const Text("ユーザー名"),
            border: const OutlineInputBorder()),
      ),
    ]);
  }

  Future<void> changeDisplayName() async {
    setState(() {
      if (_form1Controller.text.isEmpty) {
        _form1Error = "入力してください";
      } else {
        _form1Error = null;
      }
    });
    if (_form1Error != null) return;

    setState(() {
      _loading = true;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .updateDisplayName(_form1Controller.text);
      ref.invalidate(firebaseUserProvider);
      if (!mounted) return;
      Navigator.pop(context);
      showSnackBar(context, "変更しました");
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, authErrorMessage(e));
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  // Delete
  Widget buildDelete() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("アカウントを削除します。\n\n"
            "アカウントを削除すると、サーバー上のデータがすべて削除され、二度と復元できません。\n\n"
            "よろしければ、「削除」をタップしてください。"),
      ],
    );
  }

  Future<void> deleteAccount() async {
    showSimpleDialog(
      context,
      "最終確認",
      "アカウントを削除すると、サーバー上のデータがすべて削除され、二度と復元できません。本当に全データを削除しますか？\n\n(セキュリティのため再ログインが必要になる場合があります。)",
      onOKPressed: () async {
        setState(() {
          _loading = true;
        });
        await _executeAccountDeletion();
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      },
      showCancel: true,
    );
  }

  Future<void> _executeAccountDeletion() async {
    try {
      await ref.read(authRepositoryProvider).deleteUser();

      if (!mounted) return;
      showSnackBar(context, "アカウントを削除しました。");
      backToWelcomePage(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      if (e.code == AuthErrorCode.requiresRecentLogin) {
        showSnackBar(context, "セキュリティのため再ログインが必要です。");
        final result = await Navigator.pushNamed(context, SignInPage.routeName,
            arguments: SignInPageArguments(
              AuthMode.reauthenticate,
              continueUri: const AuthContinueDestination.deleteAccount().toUri(),
            ));
        if (result == true) {
          await _executeAccountDeletion();
        }
      } else {
        showSnackBar(context, authErrorMessage(e));
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, authErrorMessage(e));
    }
  }
}

enum EditingType { changeEmail, changePassword, changeDisplayName, delete }
