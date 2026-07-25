import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";

import "../../../../core/result/result.dart";
import "../../../../routing/routes.dart";
import "../../../shared/ui/providers/scaffold_messenger.dart";
import "../../domain/models/auth_mode.dart";
import "../../domain/models/social_provider.dart";
import "../components/sign_in_method_button.dart";
import "../messages/auth_failure_message.dart";
import "../messages/auth_success_message.dart";
import "../view_models/sign_in_page_view_model.dart";

/// The main sign in page.
///
/// If the authentication succeeds, returns `true`.
class SignInPage extends ConsumerStatefulWidget {
  final AuthMode mode;

  /// {@template signInContinueUri}
  /// Continue URI used for redirection after email link auth.
  /// {@endtemplate}
  final Uri? continueUri;

  const SignInPage({super.key, required this.mode, required this.continueUri});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  SignInPageViewModelNotifier get notifier =>
      ref.read(signInPageViewModelProvider.notifier);

  AuthMode get mode => widget.mode;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInPageViewModelProvider);

    final title = switch (mode) {
      AuthMode.signIn => "ログイン / 新規登録",
      AuthMode.upgrade => "アカウントをアップグレード",
      AuthMode.reauthenticate => "再認証",
    };

    List<({
      String iconAsset,
      Color color,
      String methodName,
      SocialProvider provider,
    })> socialProviders = [
      (
        iconAsset: "assets/vector/google.svg",
        color: Colors.white,
        methodName: "Google",
        provider: SocialProvider.google,
      ),
      (
        iconAsset: "assets/vector/apple.svg",
        color: Colors.blueGrey,
        methodName: "Apple",
        provider: SocialProvider.apple,
      ),
    ];
    if (Platform.isIOS || Platform.isAndroid) {
      // make Apple first
      socialProviders = socialProviders.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: .all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("続行するには、以下の利用規約・プライバシーポリシーに同意する必要があります。"),
                SizedBox(height: 16),
                Row(
                  spacing: 16,
                  children: [
                    TextButton(
                      onPressed: notifier.showTerms,
                      child: Text("利用規約"),
                    ),
                    TextButton(
                      onPressed: notifier.showPrivacyPolicy,
                      child: Text("プライバシーポリシー"),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SignInMethodButton(
                  icon: const Icon(Icons.mail, color: Colors.white),
                  color: Colors.orange.shade800,
                  methodName: "メールアドレス",
                  onPressed: state.loadingProvider == null ? () async {
                    final result = await EmailSignInRoute(
                      mode: mode,
                      continueUri:  widget.continueUri,
                    ).push<bool>(context);
                    if (result == true) {

                    }
                  } : null,
                ),
                SizedBox(height: 32),
                Column(
                  spacing: 16,
                  children: [
                    for (final p in socialProviders)
                      SignInMethodButton(
                        icon: SvgPicture.asset(p.iconAsset),
                        methodName: p.methodName,
                        color: p.color,
                        isLoading: state.loadingProvider == p.provider,
                        onPressed: state.loadingProvider == null ? () async {
                          final result = await notifier.socialSignIn(p.provider, mode);
                          switch (result) {
                            case ResultOk(value: null):
                              break; // canceled by user
                            case ResultFailed(:final error):
                              ref.showErrorSnackBar(error.displayMessage);
                            case ResultOk(value: final result!):
                              ref.showSnackBar(result.authSuccessMessage);
                              if (context.mounted) {
                                context.pop(true);
                              }
                          }
                        } : null,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
