import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../features/auth/presentation/auth_messages.dart";
import "../features/auth/repositories/auth_repository.dart";
import "../utils/ui.dart";

class EmailRegistrationPage extends ConsumerStatefulWidget {
  const EmailRegistrationPage({super.key, required this.email});

  static const routeName = "/sign-in/email/register";

  final String email;

  @override
  ConsumerState<EmailRegistrationPage> createState() =>
      _EmailRegistrationPageState();
}

class EmailRegistrationPageArguments {
  final String email;

  EmailRegistrationPageArguments({required this.email});
}

class _EmailRegistrationPageState
    extends ConsumerState<EmailRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _pwController = TextEditingController();
  final _pwReenterController = TextEditingController();

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
            child: Form(
              key: _formKey,
              child: Column(children: [
                Text("メールアドレス: ${widget.email}"),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pwController,
                  obscureText: true,
                  enabled: !_loading,
                  decoration: const InputDecoration(
                    label: Text("パスワード"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "入力してください";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pwReenterController,
                  obscureText: true,
                  enabled: !_loading,
                  decoration: const InputDecoration(
                    label: Text("パスワード(再入力)"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "入力してください";
                    }
                    if (value != _pwController.text) {
                      return "パスワードが一致しません";
                    }
                    return null;
                  },
                ),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                label: const Text("登録"),
                icon: const Icon(Icons.how_to_reg),
                onPressed: _register,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(widget.email, _pwController.text);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (!mounted) return;
      showSnackBar(context, authErrorMessage(e));
    }
  }
}
