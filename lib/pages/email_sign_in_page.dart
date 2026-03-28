import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../features/auth/presentation/sign_in_state_notifier.dart";
import "../features/auth/use_cases/common.dart";
import "../providers/firebase_providers.dart";
import "../utils/ui.dart";
import "email_registration_page.dart";

enum _EmailSignInStep { email, password }

class EmailSignInPage extends ConsumerStatefulWidget {
  const EmailSignInPage({
    super.key,
    required this.mode,
  });

  static const routeName = "/sign-in/email";

  final AuthMode mode;

  @override
  ConsumerState<EmailSignInPage> createState() => EmailSignInPageState();
}

class EmailSignInPageArguments {
  final AuthMode mode;

  const EmailSignInPageArguments(this.mode);
}

class EmailSignInPageState extends ConsumerState<EmailSignInPage>
    with SingleTickerProviderStateMixin {
  var _step = _EmailSignInStep.email;
  var processing = false;
  var visiblePW = false;
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  AnimationController? pwAnimController;
  String? emailError;
  String? pwError;

  bool get _isPasswordStep => _step == _EmailSignInStep.password;

  @override
  void initState() {
    super.initState();
    pwAnimController = AnimationController(vsync: this);
    if (widget.mode == AuthMode.reauthenticate) {
      emailController.text =
          ref.read(firebaseUserProvider).requireValue!.email!;
      _step = _EmailSignInStep.password;
      pwAnimController!.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInStateProvider, (_, next) {
      final newProcessing = next is AuthBusyState;
      if (newProcessing != processing) {
        setState(() {
          processing = newProcessing;
        });
      }

      if (next is SignInStateReAuthSucceeded) {
        Navigator.pop(context, true);
      }

      if (next is SignInStatePasswordResetLinkSent) {
        showSimpleDialog(
            context,
            "完了",
            "入力されたアドレスにメールを送信しました。受信したメールのリンクからパスワードをリセットしてください。\n\n"
                "※メールは「submon.app」ドメインから送信されます。迷惑メールに振り分けられていないかご確認ください。",
            onOKPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        }, allowCancel: false);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("メールアドレスを使用")),
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: processing,
              child: const LinearProgressIndicator(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(switch (_step) {
                    _EmailSignInStep.email => "メールアドレスを入力してください",
                    _EmailSignInStep.password =>
                      widget.mode == AuthMode.reauthenticate
                          ? "本人確認のため、再度ログインをお願いします。"
                          : "パスワードを入力してください",
                  }),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: _step == _EmailSignInStep.email && !processing,
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "メールアドレス",
                        border: const OutlineInputBorder(),
                        errorText: emailError),
                    onFieldSubmitted: (_) {
                      next();
                    },
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: Tween(
                            begin: const Offset(0, -0.4),
                            end: const Offset(0, 0))
                        .animate(pwAnimController!),
                    child: IgnorePointer(
                      ignoring: !_isPasswordStep,
                      child: AnimatedOpacity(
                        opacity: _isPasswordStep ? 1.0 : 0.0,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            TextFormField(
                              obscureText: !visiblePW,
                              enabled: _step == _EmailSignInStep.password &&
                                  !processing,
                              controller: pwController,
                              decoration: InputDecoration(
                                labelText: "パスワード",
                                suffixIcon: IconButton(
                                  icon: Icon(visiblePW
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      visiblePW = !visiblePW;
                                    });
                                  },
                                ),
                                border: const OutlineInputBorder(),
                                errorText: pwError,
                              ),
                              onFieldSubmitted: (_) {
                                next();
                              },
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: onPWForgot,
                              child: const Text("パスワードを忘れた場合"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Visibility(
                      visible: _isPasswordStep &&
                          widget.mode != AuthMode.reauthenticate,
                      child: SizedBox(
                        width: 80,
                        child: OutlinedButton(
                          onPressed: processing
                              ? null
                              : () {
                                  _transitionToStep(_EmailSignInStep.email);
                                },
                          child: const Text("戻る"),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: processing ? null : next,
                      child: const Text("次へ"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> next() async {
    // フォームエラーハンドリング
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "メールアドレスを入力してください";
      });
      return;
    }
    if (_isPasswordStep && pwController.text.isEmpty) {
      setState(() {
        pwError = "パスワードを入力してください";
      });
      return;
    }
    setState(() {
      emailError = null;
      pwError = null;
      processing = true;
    });

    if (!_isPasswordStep) {
      await _handleEmailLookup();
    } else {
      ref.read(signInStateProvider.notifier).signInWithEmailPassword(
            emailController.text,
            pwController.text,
            mode: widget.mode,
          );
    }
  }

  Future<void> _handleEmailLookup() async {
    final methods = await ref
        .read(signInStateProvider.notifier)
        .lookupEmailSignInMethod(emailController.text);

    if (methods == null || !mounted) return;

    if (methods.isEmpty) {
      showSelectSheet(
          context: context,
          title: "ログイン方法の選択",
          message:
              "メールアドレスで新規登録を行います。\nメールアドレスでのログイン方法は2種類存在します。どちらか選択してください。(現状、以後変更できません)\n\n"
              "・パスワードレス・・・登録したメールアドレスに送信されたリンクを踏むことでログインできます。(推奨)\n"
              "・一般的なログイン・・・パスワードを利用してログインします。",
          actions: [
            SelectSheetAction("パスワードレス(推奨)", () {
              Navigator.pop(context);
              sendSignInEmail();
            }),
            SelectSheetAction("一般的なログイン", () async {
              Navigator.pop(context);
              final result = await Navigator.pushNamed<bool>(
                  context, EmailRegistrationPage.routeName,
                  arguments: EmailRegistrationPageArguments(
                      email: emailController.text));
              if (result == true && mounted) {
                ref
                    .read(signInStateProvider.notifier)
                    .completeCurrentSignIn();
              }
            }),
          ]);
    } else if (methods.any((m) => m == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD)) {
      _transitionToStep(_EmailSignInStep.password);
    } else if (methods.any((m) => m == EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD)) {
      sendSignInEmail();
    } else {
      showSimpleDialog(context, "エラー",
          "このアカウントはメールアドレスを使用してサインインできません。\n前の画面に戻り、「Google でサインイン」もしくは「Apple でサインイン」からサインインしてください。",
          onOKPressed: () {});
    }
  }

  void _transitionToStep(_EmailSignInStep newStep) {
    setState(() {
      _step = newStep;
    });
    final show = newStep == _EmailSignInStep.password;
    pwAnimController?.animateTo(
      show ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: show ? Curves.easeOutQuint : Curves.easeInQuint,
    );
  }

  void sendSignInEmail() {
    ref.read(signInStateProvider.notifier).sendSignInEmail(
          emailController.text,
          widget.mode,
        );
  }

  void onPWForgot() {
    showSimpleDialog(context, "パスワードを忘れた場合",
        "下のOKボタンを押すと入力されたメールアドレス宛にパスワードリセット用のURLを送信します。そのURLを開いてパスワードをリセットしてください。\n\n※メールは「submon.app」というドメインから届きます。迷惑メール設定をしている場合はご注意ください。",
        onOKPressed: () async {
      setState(() {
        processing = true;
      });
      ref.read(signInStateProvider.notifier)
          .sendPasswordResetLink(emailController.text);
    }, showCancel: true);
  }
}
