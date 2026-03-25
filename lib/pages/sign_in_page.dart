import "dart:io";

import "package:firebase_auth/firebase_auth.dart" hide AuthProvider;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../browser.dart";
import "../features/auth/presentation/auth_messages.dart";
import "../features/auth/presentation/sign_in_state_notifier.dart";
import "../features/auth/repositories/auth_repository.dart";
import "../features/auth/use_cases/common.dart";
import "../ui_components/hidable_progress_indicator.dart";
import "../utils/ui.dart";
import "email_sign_in_page.dart";
import "home_page.dart";

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({
    super.key,
    required this.initialCred,
    required this.mode,
    this.continueUri,
  });

  static const routeName = "/sign-in";

  final UserCredential? initialCred;
  final AuthMode mode;
  final Uri? continueUri;

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class SignInPageArguments {
  final UserCredential? initialCred;
  final AuthMode mode;
  final Uri? continueUri;

  const SignInPageArguments(this.mode, {this.initialCred, this.continueUri});
}

class _SignInPageState extends ConsumerState<SignInPage> {
  @override
  void initState() {
    super.initState();
    if (widget.mode == AuthMode.reauthenticate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(signInStateProvider.notifier).reAuth();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInStateProvider);

    ref.listen(signInStateProvider, (_, next) {
      _handleStateChange(next, context);
    });

    final title = switch (widget.mode) {
      AuthMode.signIn => "ログイン / 新規登録",
      AuthMode.upgrade => "アカウントをアップグレード",
      AuthMode.reauthenticate => "再認証",
    };

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              HidableLinearProgressIndicator(show: state is AuthBusyState),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text("続行するには、以下の利用規約・プライバシーポリシーに同意する必要があります。",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!
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
                        onPressed: state is! AuthBusyState
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  EmailSignInPage.routeName,
                                  arguments:
                                      EmailSignInPageArguments(widget.mode),
                                );
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (Platform.isIOS || Platform.isMacOS)
                      Column(
                        children: [
                          _buildAppleSignInButton(state),
                          const SizedBox(height: 16),
                          _buildGoogleSignInButton(state),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildGoogleSignInButton(state),
                          const SizedBox(height: 16),
                          _buildAppleSignInButton(state),
                        ],
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _handleStateChange(SignInState next, BuildContext context) async {
    switch (next) {
      case SignInStateSignInSucceeded(:final completionResult):
        showSnackBar(context, signInSuccessMessage(completionResult));
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.routeName,
          (route) => false,
        );
      case SignInStateUpgradeSucceeded():
        showSnackBar(context, "アカウントをアップグレードしました。");
        Navigator.of(context).pop(true);
      case SignInStateReAuthSucceeded():
        Navigator.of(context).pop(true);
      case SignInStateReAuthCanceled():
        Navigator.of(context).pop(false);
      case SignInStateWaitingForPasswordSignIn():
        final result = await Navigator.pushNamed(
          context,
          EmailSignInPage.routeName,
          arguments: const EmailSignInPageArguments(AuthMode.reauthenticate),
        );
        if (result != true) {
          ref.read(signInStateProvider.notifier).cancel();
          if (context.mounted) Navigator.pop(context);
        }
      case SignInStateWaitingForEmailLinkDialog():
        showSimpleDialog(
          context,
          "追加認証",
          "セキュリティのため、再度ログインする必要があります。送信されたメールにあるURLをタップし、ログインしてください。",
          onOKPressed: () {
            ref.read(signInStateProvider.notifier)
                .confirmEmailLinkReAuth(widget.continueUri.toString());
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
          showCancel: true,
        );
      case SignInStateSignInLinkSent():
        showSnackBar(context, "送信しました");
        Navigator.pop(context);
      case SignInStateFailed(:final error):
        showSnackBar(
          context,
          authErrorMessage(error),
          duration: Duration(seconds: 20),
        );
      case SignInStateIdle():
      case SignInStateBusy():
      case SignInStatePasswordResetLinkSent(): // handled in email sign-in page
        break;
    }
  }

  Widget _buildAppleSignInButton(SignInState state) {
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
        onPressed: state is! AuthBusyState
            ? () {
                ref.read(signInStateProvider.notifier)
                    .signInWithProvider(AuthProvider.apple, mode: widget.mode);
              }
            : null,
      ),
    );
  }

  Widget _buildGoogleSignInButton(SignInState state) {
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
        onPressed: state is! AuthBusyState
            ? () {
                ref.read(signInStateProvider.notifier)
                    .signInWithProvider(AuthProvider.google, mode: widget.mode);
              }
            : null,
      ),
    );
  }
}
