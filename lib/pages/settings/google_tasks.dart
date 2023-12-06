import 'package:flutter/material.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

class GoogleTasksSettingsPage extends StatefulWidget {
  const GoogleTasksSettingsPage({super.key});

  static const routeName = "/settings/functions/google-tasks";

  @override
  State<GoogleTasksSettingsPage> createState() =>
      _GoogleTasksSettingsPageState();
}

class _GoogleTasksSettingsPageState extends State<GoogleTasksSettingsPage> {
  bool? googleTasksAvailable;

  @override
  void initState() {
    super.initState();

    Future(() {
      showLoadingModal(context);

      canAccessTasks().then((value) {
        Navigator.pop(context);
        setState(() {
          googleTasksAvailable = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      text: googleTasksAvailable == true
                          ? "連携済み (${googleSignIn.currentUser?.email})"
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
                          dynamic result;
                          if (googleSignIn.currentUser != null) {
                            result = await googleSignIn.requestScopes(scopes);
                          } else {
                            var r = await googleSignIn.signIn();
                            if (r == null) return;
                            result = await googleSignIn.requestScopes(scopes);
                          }

                          if (result == true) {
                            showSnackBar(context, "Google Tasksと連携しました。");
                            setState(() {
                              googleTasksAvailable = true;
                            });
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

                        await googleSignIn.disconnect();

                        setState(() {
                          googleTasksAvailable = false;
                        });
                        showSnackBar(context, "連携を解除しました。");
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
