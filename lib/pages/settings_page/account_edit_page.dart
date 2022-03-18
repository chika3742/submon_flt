import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class AccountEditPage extends StatefulWidget {
  const AccountEditPage(this.type, {Key? key}) : super(key: key);

  final EditingType type;

  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  final _form1Controller = TextEditingController();
  String? _form1Error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == EditingType.changeDisplayName) {
      _form1Controller.text =
          FirebaseAuth.instance.currentUser!.displayName ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var delete = widget.type == EditingType.delete;
    return Scaffold(
        appBar: AppBar(
          title: Text(getTitle()),
        ),
        body: Stack(
          children: [
            if (_loading) const LinearProgressIndicator(),
            Padding(
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
            )
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
      const Text("メールアドレスを変更します。\n\n"
          "新しいメールアドレスを入力して「送信」をタップすると、新しいメールアドレスに確認URLが送信されます。このURLをタップすることで、メールアドレスの変更が完了します。\n"
          "「送信」をタップするだけでは変更は完了しませんのでご注意ください。\n\n"
          "※メールは「chikach.net」ドメインから送信されます。迷惑メールに振り分けられていないか確認してください。"),
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
      await FirebaseAuth.instance.currentUser!
          .verifyBeforeUpdateEmail(_form1Controller.text);

      showSnackBar(context, "送信しました。ご確認ください。");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          _form1Error = "メールアドレスの形式が正しくありません";
          break;
        case "email-already-in-use":
          _form1Error = "このメールアドレスは既に使用されています";
          break;
        case "requires-recent-login":
          var result = await Navigator.pushNamed(context, "/signIn",
              arguments: {'reAuth': true});
          if (result == true) await changeEmail();
          break;
        default:
          handleAuthError(e, context);
      }
    } catch (e) {
      showSnackBar(context, "エラーが発生しました");
    }
    setState(() {
      _loading = false;
    });
  }

  // Change password
  Widget buildChangePassword() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("パスワードを変更します。\n\n"
              "「送信」をタップすると、登録されているメールアドレスにパスワード変更URLが記載されたメールを送信します。"
              "このURLをタップすることでパスワードを変更できます。\n\n"
              "※メールは「chikach.net」ドメインから届きます。迷惑メールに振り分けられていないかご確認ください。"),
        ]);
  }

  Future<void> changePassword() async {
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: FirebaseAuth.instance.currentUser!.email!);

      showSnackBar(context, "送信しました。ご確認ください。");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      handleAuthError(e, context);
    }
    setState(() {
      _loading = false;
    });
  }

  // Change display name
  Widget buildChangeDisplayName() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("ユーザー名を変更します。"),
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
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(_form1Controller.text);
      Navigator.pop(context);
      showSnackBar(context, "変更しました");
    } on FirebaseAuthException catch (e) {
      handleAuthError(e, context);
    }

    setState(() {
      _loading = false;
    });
  }

  // Delete
  Widget buildDelete() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("アカウントを削除します。\n\n"
              "アカウントを削除すると、サーバー上のデータがすべて削除され、二度と復元できません。\n\n"
              "よろしければ、「削除」をタップしてください。"),
        ]);
  }

  Future<void> deleteAccount() async {
    showSimpleDialog(
      context,
      "最終確認",
      "アカウントを削除すると、サーバー上のデータがすべて削除され、二度と復元できません。本当に全データを削除しますか？",
      onOKPressed: () async {
        setState(() {
          _loading = true;
        });
        try {
          await FirestoreProvider.deleteUser();
          await FirebaseAuth.instance.currentUser!.delete();

          showSnackBar(context, "アカウントを削除しました。");
          backToWelcomePage(context);
        } on FirebaseAuthException catch (e) {
          if (e.code == "requires-recent-login") {
            showSnackBar(context, "セキュリティのため、再度ログインをお願いします。");
            var result = await Navigator.pushNamed(context, "/signIn",
                arguments: {'reAuth': true});
            if (result == true) await deleteAccount();
          } else {
            handleAuthError(e, context);
          }
        } catch (e) {
          showSnackBar(context, "アカウントの削除に失敗しました。");
        }
        setState(() {
          _loading = false;
        });
      },
      showCancel: true,
    );
  }
}

enum EditingType { changeEmail, changePassword, changeDisplayName, delete }
