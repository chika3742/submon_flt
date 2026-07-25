import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../../utils/email_validator.dart";
import "../../../shared/ui/components/hidable_progress_bar.dart";
import "../../../shared/ui/providers/modals.dart";
import "../../../shared/ui/providers/scaffold_messenger.dart";
import "../../domain/models/auth_mode.dart";
import "../components/divider_with_text.dart";
import "../messages/auth_failure_message.dart";
import "../messages/auth_success_message.dart";
import "../view_models/email_sign_in_view_model.dart";

class EmailSignInPage extends ConsumerStatefulWidget {
  final AuthMode mode;

  /// {@macro signInContinueUri}
  final Uri? continueUri;

  const EmailSignInPage({super.key, required this.mode, this.continueUri});

  @override
  ConsumerState<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends ConsumerState<EmailSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _shouldValidatePassword = false;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.mode == .reauthenticate) {
      unawaited(_initCurrentUserEmail());
    }
  }

  Future<void> _initCurrentUserEmail() async {
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailSignInViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("メールアドレスでログイン/新規登録"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            HidableProgressBar(show: state.processing),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                canPop: !state.processing,
                child: Padding(
                  padding: .all(16.0),
                  child: Column(
                    spacing: 16.0,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(switch (widget.mode) {
                        .reauthenticate => "本人確認のため、再度ログインをお願いします。",
                        _ => "メールアドレスを入力してください",
                      }),
                      TextFormField(
                        controller: _emailController,
                        enabled: !state.processing,
                        decoration: InputDecoration(
                          labelText: "メールアドレス",
                          border: OutlineInputBorder(),
                        ),
                        validator: emailValidator,
                      ),
                      Divider(),
                      FilledButton.tonalIcon(
                        icon: Icon(Icons.mail),
                        onPressed: !state.processing ? _sendEmailLink : null,
                        label: Text("メールリンクでログイン/新規登録"),
                      ),
                      DividerWithText(
                        child: Text("または", style: TextStyle(fontSize: 16)),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !state.processing,
                        obscureText: _obscurePassword,
                        validator: _passwordValidator,
                        decoration: InputDecoration(
                          labelText: "パスワード",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      FilledButton.tonalIcon(
                        icon: Icon(Icons.password),
                        onPressed: !state.processing ? _signInWithPassword : null,
                        label: Text("パスワードでログイン"),
                      ),
                      Text("※パスワードを登録していない場合には、パスワードでのログインは利用できません。"),
                      Text("※現在、パスワードを用いた新規登録はできません。"
                          "メールアドレスを使用する場合は、メールリンクログインを使用してください。"),
                      Align(
                        alignment: .centerEnd,
                        child: OutlinedButton(
                          onPressed: !state.processing ? _sendPasswordResetLink : null,
                          child: Text("パスワードを忘れた場合"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _passwordValidator(String? value) {
    if (!_shouldValidatePassword) return null;
    return value!.isEmpty ? "入力してください" : null;
  }

  bool _validateEmailOnly() {
    _shouldValidatePassword = false;

    return _formKey.currentState!.validate();
  }

  bool _validateAllFields() {
    _shouldValidatePassword = true;
    return _formKey.currentState!.validate();
  }

  Future<void> _sendEmailLink() async {
    if (!_validateEmailOnly()) return;

    (await ref.read(emailSignInViewModelProvider.notifier)
        .sendSignInEmail(_emailController.text, widget.mode))
        .tap(
      ok: (_) async {
        await ref.showSimpleDialog("メールを送信しました",
            "届いたメールに記載のリンクを開いてログインしてください。");
        if (mounted) {
          context.pop(false); // auth is not yet completed
        }
      },
      failed: (e, _) {
        ref.showErrorSnackBar(e.displayMessage);
      },
    );
  }

  Future<void> _signInWithPassword() async {
    if (!_validateAllFields()) return;

    (await ref.read(emailSignInViewModelProvider.notifier)
        .signInWithPassword(
      _emailController.text,
      _passwordController.text,
      widget.mode,
    )).tap(
      ok: (result) {
        ref.showSnackBar(result.authSuccessMessage);
        // TODO: go to home page
      },
      failed: (e, _) {
        ref.showErrorSnackBar(e.displayMessage);
      },
    );
  }

  Future<void> _sendPasswordResetLink() async {
    if (!_validateEmailOnly()) {
      await ref.showSimpleDialog(
        "パスワードを忘れた場合",
        "パスワードリセット用のURLを、ご登録のメールアドレス宛に送信します。\n\n"
            "続けるには、前の画面でメールアドレスを入力してから「パスワードを忘れた場合」を"
            "選択してください。",
      );
      return;
    }

    final proceed = await ref.showSimpleDialog(
      "パスワードを忘れた場合",
      "入力されたメールアドレス宛にパスワードリセット用のURLを送信します。"
          "そのURLを開いてパスワードをリセットしてください。\n\n※メールは「submon.app」"
          "というドメインから届きます。迷惑メール設定をしている場合はご注意ください。",
      showCancel: true,
    );
    if (!proceed) return;
    if (!_validateEmailOnly()) return;

    (await ref.read(emailSignInViewModelProvider.notifier)
        .sendPasswordResetEmail(_emailController.text)).tap(
      ok: (_) {
        ref.showSnackBar("送信しました。メールボックスをご確認ください。");
      },
      failed: (e, _) {
        ref.showErrorSnackBar(e.displayMessage);
      },
    );
  }
}
