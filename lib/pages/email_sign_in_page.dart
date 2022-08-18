import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/main.dart';
import 'package:submon/models/sign_in_result.dart';
import 'package:submon/pages/email_registration_page.dart';
import 'package:submon/utils/ui.dart';

import '../utils/dynamic_links.dart';
import '../utils/utils.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({
    Key? key,
    required this.reAuth,
  }) : super(key: key);

  static const routeName = "/sign-in/email";

  final bool reAuth;

  @override
  State<StatefulWidget> createState() => EmailSignInPageState();
}

class EmailSignInPageArguments {
  final bool reAuth;

  const EmailSignInPageArguments({this.reAuth = false});
}

class EmailSignInPageState extends State<EmailSignInPage>
    with SingleTickerProviderStateMixin {
  var enableEmailForm = true;
  var enablePWForm = false;
  var processing = false;
  var visiblePW = false;
  var emailController = TextEditingController();
  var pwController = TextEditingController();
  AnimationController? pwAnimController;
  var pwOpacity = 0.0;
  String? emailError;
  String? pwError;
  String? message = msgEmail;

  static const msgEmail = "メールアドレスを入力してください";
  static const msgPW = "パスワードを入力してください";

  @override
  void initState() {
    super.initState();
    pwAnimController = AnimationController(vsync: this);
    if (widget.reAuth) {
      message = "本人確認のため、再度ログインをお願いします。";
      emailController.text = FirebaseAuth.instance.currentUser!.email!;
      enableEmailForm = false;
      enablePWForm = true;
      switchPasswordForm(true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(message!),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: enableEmailForm,
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
                      ignoring: pwOpacity == 0,
                      child: AnimatedOpacity(
                        opacity: pwOpacity,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            TextFormField(
                              obscureText: !visiblePW,
                              enabled: enablePWForm,
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
                      visible: widget.reAuth,
                      child: SizedBox(
                        width: 80,
                        child: OutlinedButton(
                          onPressed: processing
                              ? null
                              : () {
                                  if (pwOpacity != 0) {
                                    switchPasswordForm(false);
                                    setState(() {
                                      message = msgEmail;
                                      enableEmailForm = true;
                                    });
                                  } else {
                                    Navigator.pop(context);
                                  }
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

  void next() async {
    // フォームエラーハンドリング
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = msgEmail;
      });
      return;
    }
    if (pwOpacity != 0 && pwController.text.isEmpty) {
      setState(() {
        pwError = msgPW;
      });
      return;
    }
    setState(() {
      emailError = null;
      processing = true;
      enableEmailForm = false;
      enablePWForm = false;
    });

    // 処理
    var auth = FirebaseAuth.instance;
    try {
      if (pwOpacity == 0) {
        // サインイン方法別の処理
        var result =
            await auth.fetchSignInMethodsForEmail(emailController.text);

        setState(() {
          enablePWForm = true;
          processing = false;
        });

        if (result.isEmpty) {
          // アカウント新規作成
          setState(() {
            enableEmailForm = true;
          });
          showSelectSheet(
              context: context,
              title: "ログイン方法の選択",
              message:
                  "メールアドレスで新規登録を行います。\nメールアドレスでのログイン方法は2種類存在します。どちらか選択してください。(現状、以後変更できません)\n\n"
                  "・パスワードレス・・・登録したメールアドレスに送信されたリンクを踏むことでログインできます。(推奨)\n"
                  "・一般的なログイン・・・パスワードを利用してログインします。",
              actions: [
                SelectSheetAction("パスワードレス(推奨)", () async {
                  Navigator.pop(context);
                  setState(() {
                    processing = true;
                    enableEmailForm = false;
                  });

                  sendSignInEmail();

                  setState(() {
                    processing = false;
                    enableEmailForm = true;
                  });
                }),
                SelectSheetAction("一般的なログイン", () async {
                  Navigator.pop(context);
                  var result = await Navigator.pushNamed<UserCredential>(
                      context, EmailRegistrationPage.routeName,
                      arguments: EmailRegistrationPageArguments(
                          email: emailController.text));
                  if (result != null && mounted) {
                    Navigator.pop(context, SignInResult(credential: result));
                  }
                }),
              ]);
        } else if (result.first ==
            EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD) {
          // パスワードサインイン
          switchPasswordForm(true);
          setState(() {
            message = msgPW;
          });
        } else if (result.first ==
            EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD) {
          // パスワードレスサインイン
          sendSignInEmail();
        } else {
          // その他(ソーシャルログイン)
          setState(() {
            enableEmailForm = true;
          });
          showSimpleDialog(globalContext!, "エラー",
              "このアカウントは既にGoogleログインを利用して作成されています。\n前の画面に戻り、「Google でログイン」からログインしてください。",
              onOKPressed: () {});
        }
      } else {
        // パスワードを用いたログイン処理
        UserCredential result;

        if (widget.reAuth) {
          result = await auth.currentUser!.reauthenticateWithCredential(
              EmailAuthProvider.credential(
                  email: emailController.text, password: pwController.text));
        } else {
          result = await auth.signInWithEmailAndPassword(
              email: emailController.text, password: pwController.text);
        }

        if (result.user != null && mounted) {
          Navigator.of(context).pop(SignInResult(credential: result));
        }
      }
    } on FirebaseAuthException catch (e, stack) {
      switch (e.code) {
        case 'invalid-email':
          setState(() {
            processing = false;
            enableEmailForm = true;
            emailError = "メールアドレスの形式が正しくありません";
          });
          break;
        case 'wrong-password':
          setState(() {
            processing = false;
            enablePWForm = true;
            pwError = "パスワードが間違っています";
          });
          break;
        default:
          setState(() {
            processing = false;
            enableEmailForm = false;
            enablePWForm = false;
          });
          handleAuthError(e, stack, context);
          break;
      }
    }
  }

  void switchPasswordForm(bool show) {
    setState(() {
      pwOpacity = show ? 1 : 0;
    });
    pwAnimController?.animateTo(show ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        curve: show ? Curves.easeOutQuint : Curves.easeInQuint);
  }

  void sendSignInEmail() {
    showLoadingModal(context);

    FirebaseAuth.instance
        .sendSignInLinkToEmail(
      email: emailController.text,
      actionCodeSettings:
          actionCodeSettings("https://submon.app/sign-in-from-email"),
    )
        .whenComplete(() {
      Navigator.pop(Application.globalKey.currentContext!);
    }).then((value) {
      SharedPrefs.use((prefs) {
        prefs.emailForUrlLogin = emailController.text;
      });
      showSimpleDialog(
          Application.globalKey.currentContext!,
          "完了",
          "メールを入力されたアドレスに送信しました。受信したメールのリンクをタップしてログインしてください。\n\n"
              "※メールは「submon.app」ドメインから送信されます。迷惑メールに振り分けられていないかご確認ください。",
          onOKPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      }, allowCancel: false);
    }).onError((error, stackTrace) {
      showSnackBar(context, "エラーが発生しました。");
      recordErrorToCrashlytics(error, stackTrace);
    });
  }

  void onPWForgot() {
    showSimpleDialog(context, "パスワードを忘れた場合",
        "下のOKボタンを押すと入力されたメールアドレス宛にパスワードリセット用のURLを送信します。そのURLを開いてパスワードをリセットしてください。\n\n※メールは「submon.app」というドメインから届きます。迷惑メール設定をしている場合はご注意ください。",
        onOKPressed: () async {
      setState(() {
        processing = true;
        enablePWForm = false;
      });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        showSnackBar(context, "送信しました。ご確認ください。");
      } on FirebaseAuthException catch (e, stack) {
        handleAuthError(e, stack, context);
      } finally {
        setState(() {
          processing = false;
          enablePWForm = true;
        });
      }
    }, showCancel: true);
  }
}
