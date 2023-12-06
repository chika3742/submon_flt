import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:submon/main.dart';

import '../utils/ui.dart';
import '../utils/utils.dart';

class EmailRegistrationPage extends StatefulWidget {
  const EmailRegistrationPage({super.key, required this.email});

  static const routeName = "/sign-in/email/register";

  final String email;

  @override
  State<EmailRegistrationPage> createState() => _EmailRegistrationPageState();
}

class EmailRegistrationPageArguments {
  final String email;

  EmailRegistrationPageArguments({required this.email});
}

class _EmailRegistrationPageState extends State<EmailRegistrationPage> {
  final _pwController = TextEditingController();
  String? _pwError;
  final _pwReenterController = TextEditingController();
  String? _pwReenterError;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規登録"),
      ),
      body: Stack(
        children: [
          if (_loading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Text("メールアドレス: ${widget.email}"),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pwController,
                obscureText: true,
                enabled: !_loading,
                decoration: InputDecoration(
                  label: const Text("パスワード"),
                  errorText: _pwError,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _pwReenterController,
                obscureText: true,
                enabled: !_loading,
                decoration: InputDecoration(
                    label: const Text("パスワード(再入力)"),
                    errorText: _pwReenterError,
                    border: const OutlineInputBorder()),
              ),
            ]),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                label: const Text("登録"),
                icon: const Icon(Icons.how_to_reg),
                onPressed: register,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void register() async {
    setState(() {
      if (_pwController.text.isEmpty) {
        _pwError = "入力してください";
      } else {
        _pwError = null;
      }
      if (_pwReenterController.text.isEmpty) {
        _pwReenterError = "入力してください";
        return;
      } else {
        _pwReenterError = null;
      }
      if (_pwReenterController.text != _pwController.text) {
        _pwReenterError = "パスワードが一致しません";
      } else {
        _pwReenterError = null;
      }
    });
    if (_pwError != null || _pwReenterError != null) return;

    setState(() {
      _loading = true;
    });
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.email, password: _pwController.text);

      showSnackBar(globalContext!, "アカウントを作成しました");
      Navigator.pop(globalContext!, result);
    } on FirebaseAuthException catch (e, stack) {
      setState(() {
        _loading = false;
      });
      switch (e.code) {
        case "auth/invalid-password":
          showSnackBar(context, "パスワードが短すぎます。最低6文字で指定してください。");
          break;
        default:
          handleAuthError(e, stack, context);
          break;
      }
    }
  }
}
