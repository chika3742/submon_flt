import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:submon/auth/sign_in_handler.dart';
import 'package:submon/browser.dart';
import 'package:submon/main.dart';
import 'package:submon/pages/email_sign_in_page.dart';
import 'package:submon/ui_components/hidable_progress_indicator.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../utils/dynamic_links.dart';

class SignInPage extends StatefulWidget {
  const SignInPage(
      {Key? key,
      required this.initialCred,
      required this.mode,
      this.continuePath})
      : super(key: key);

  static const routeName = "/sign-in";

  final UserCredential? initialCred;
  final SignInMode mode;
  final String? continuePath;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class SignInPageArguments {
  final UserCredential? initialCred;
  final SignInMode mode;
  final String? continuePath;

  const SignInPageArguments(this.mode, {this.initialCred, this.continuePath});
}

class _SignInPageState extends State<SignInPage> {
  var loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == SignInMode.reauthenticate) {
      reAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ログイン / 新規登録'),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              HidableLinearProgressIndicator(show: loading),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text("続行するには、以下の利用規約・プライバシーポリシーに同意する必要があります。",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyLarge!
                                .color)),
                    Row(
                      children: [
                        TextButton(
                          onPressed: Browser.openTermsOfUse,
                          child: Text("利用規約",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: Browser.openPrivacyPolicy,
                          child: Text("プライバシーポリシー",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.mail, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade800,
                        ),
                        label: const Text("メールアドレスでサインイン",
                            style: TextStyle(color: Colors.white)),
                        onPressed: (!loading && widget.mode != SignInMode.reauthenticate)
                            ? () {
                                signInWithProvider(AuthProvider.email);
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (Platform.isIOS || Platform.isMacOS)
                      Column(
                        children: [
                          _buildAppleSignInButton(),
                          const SizedBox(height: 16),
                          _buildGoogleSignInButton(),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildGoogleSignInButton(),
                          const SizedBox(height: 16),
                          _buildAppleSignInButton(),
                        ],
                      ),
                    const SizedBox(height: 24),
                    if (Platform.isIOS)
                      Text(
                          "「Googleでログイン」もしくは「Twitterでログイン」をタップすると、「あなたに関する情報を共有することを許可」"
                          "するか聞かれる場合があります。\nここでいう「あなたに関する情報」はログインに必要な情報のことです。"
                          "ログインする場合は「続ける」をタップしてください。",
                          style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildAppleSignInButton() {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        icon: SvgPicture.asset(
          "assets/vector/apple.svg",
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
        label: const Text("Appleでサインイン", style: TextStyle(color: Colors.white)),
        onPressed: !loading && widget.mode != SignInMode.reauthenticate
            ? () {
                signInWithProvider(AuthProvider.apple);
              }
            : null,
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        icon: SvgPicture.asset(
          "assets/vector/google.svg",
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        label:
            const Text("Googleでサインイン", style: TextStyle(color: Colors.black)),
        onPressed: !loading && widget.mode != SignInMode.reauthenticate
            ? () {
                signInWithProvider(AuthProvider.google);
              }
            : null,
      ),
    );
  }

  Future<UserCredential?> signInWithProvider(AuthProvider provider) async {
    setState(() {
      loading = true;
    });

    try {
      var signInHandler = SignInHandler(widget.mode);
      var result = await signInHandler.signIn(provider, context: context);

      await signInHandler.handleSignInResult(result);

      return result.credential;
    } on FirebaseAuthException catch (e, stack) {
      if (widget.mode != SignInMode.reauthenticate) {
        handleCredentialError(e, stack);
        return null;
      } else {
        rethrow;
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showSnackBar(context, "エラーが発生しました。($e)");
      return null;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void handleCredentialError(FirebaseAuthException e, StackTrace stack) {
    switch (e.code) {
      case "account-exists-with-different-credential":
        showSnackBar(context, "このアカウントに紐付けられたメールアドレスのユーザーが既に存在します。");
        break;
      case "invalid-credential":
        print(e.message);
        showSnackBar(context, "エラー: 資格情報が無効です");
        break;
      default:
        handleAuthError(e, stack, context);
    }
  }

  void reAuth() {
    Future(() async {
      var auth = FirebaseAuth.instance;

      var currentUser = auth.currentUser!;
      var providerId = currentUser.providerData.first.providerId;

      if (providerId == EmailAuthProvider.PROVIDER_ID) {
        showLoadingModal(context);

        var methods = await auth.fetchSignInMethodsForEmail(currentUser.email!);

        Navigator.pop(globalContext!); // Close Loading modal

        if (methods.first == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD) {
          var result = await Navigator.pushNamed(globalContext!, EmailSignInPage.routeName,
              arguments: const EmailSignInPageArguments(reAuth: true));
          Navigator.pop(globalContext!, result != null);
        } else if (methods.first ==
            EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD) {
          showSimpleDialog(
            globalContext!,
            "追加認証",
            "セキュリティのため、再度ログインする必要があります。送信されたメールにあるURLをタップし、ログインしてください。",
            onOKPressed: () async {
              showLoadingModal(context);
              try {
                await auth.sendSignInLinkToEmail(
                    email: currentUser.email!,
                    actionCodeSettings: actionCodeSettings(getAppDomain(
                        widget.continuePath ?? "",
                        withScheme: true)));
                if (mounted) showSnackBar(context, "送信しました");
              } catch (e, stack) {
                showSnackBar(context, "エラーが発生しました");
                recordErrorToCrashlytics(e, stack);
              }
              Navigator.pop(context); // Close Loading modal
              Navigator.pop(context); // Close sign in page
            },
            onCancelPressed: () {
              Navigator.pop(context); // Close sign in page
            },
            showCancel: true,
          );
        }
      } else {
        try {
          UserCredential? result;
          if (providerId == GoogleAuthProvider.PROVIDER_ID) {
            result = await signInWithProvider(AuthProvider.google);
          } else if (providerId == "apple.com") {
            result = await signInWithProvider(AuthProvider.apple);
          }

          Navigator.pop(globalContext!, result != null && result.user != null);
        } on FirebaseAuthException catch (e, stack) {
          switch (e.code) {
            case "user-mismatch":
              showSnackBar(context, "ユーザーがログインされているものと一致しません");
              break;
            default:
              handleAuthError(e, stack, context);
          }
          Navigator.pop(context);
        }
      }
    });
  }
}
