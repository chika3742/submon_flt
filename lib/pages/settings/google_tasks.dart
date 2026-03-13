import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:googleapis/tasks/v1.dart" as tasks;
import "../../providers/core_providers.dart";
import "../../utils/ui.dart";
import "../../utils/utils.dart";

class GoogleTasksSettingsPage extends ConsumerWidget {
  const GoogleTasksSettingsPage({super.key});

  static const routeName = "/settings/functions/google-tasks";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(googleSignedInAccountProvider).value;
    final client = ref.watch(googleAuthenticatedClientProvider).value;

    final googleTasksAvailable = user != null && client != null;

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text.rich(
                TextSpan(children: [
                  const TextSpan(text: "連携状態: "),
                  TextSpan(
                      text: googleTasksAvailable
                          ? "連携済み (${user.email})"
                          : "未連携",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(
                "提出物追加時に「提出物をGoogle Tasksに同期する」をオンにすると、Google Tasksでも提出物を確認できるようになります。\n"
                "データの利用方法等についてはプライバシーポリシーをご覧ください。",
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            if (googleTasksAvailable != true)
              Column(
                children: [
                  const Text("以下のボタンをタップで連携します。"),
                  const SizedBox(height: 8),
                  Material(
                    elevation: 4,
                    child: Ink.image(
                      image: const AssetImage(
                          "assets/img/btn_google_signin.png"),
                      height: 50,
                      width: 207.6,
                      padding: EdgeInsets.zero,
                      child: InkWell(
                        onTap: () async {
                          const scopes = [tasks.TasksApi.tasksScope];
                          final gsi = GoogleSignIn.instance;

                          try {
                            // request sign in to user if not yet
                            if (user == null) {
                              await gsi.authenticate(scopeHint: scopes);
                            }

                            // check the scope is granted
                            if (!await canAccessTasks()) {
                              await gsi.authorizationClient.authorizeScopes(scopes);
                            }

                            ref.invalidate(googleAuthenticatedClientProvider);
                            if (context.mounted) {
                              showSnackBar(context, "Google Tasksと連携しました。");
                            }
                          } on GoogleSignInException catch (e, st) {
                            switch (e.code) {
                              case GoogleSignInExceptionCode.canceled:
                                // canceled by user
                                return;
                              default:
                                showSnackBar(context, "エラーが発生しました。");
                                recordErrorToCrashlytics(e, st);
                                return;
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  OutlinedButton(
                    child: const Text("連携を解除する"),
                    onPressed: () async {
                      try {
                        showLoadingModal(context);

                        await GoogleSignIn.instance.disconnect();

                        if (context.mounted) {
                          showSnackBar(context, "連携を解除しました。");
                        }
                      } catch (e, stack) {
                        showSnackBar(context, "エラーが発生しました。");
                        recordErrorToCrashlytics(e, stack);
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("※SubmonにGoogleログインを利用している場合、ログイン時に自動的に連携されます。"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
