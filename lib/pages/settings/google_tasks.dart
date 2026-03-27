import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../features/google_tasks/models/tasks_auth_exception.dart";
import "../../features/google_tasks/presentation/google_tasks_link_state_notifier.dart";
import "../../utils/ui.dart";

class GoogleTasksSettingsPage extends ConsumerWidget {
  const GoogleTasksSettingsPage({super.key});

  static const routeName = "/settings/functions/google-tasks";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final processState = ref.watch(googleTasksLinkProcessStateProvider);
    final linkState = ref.watch(connectedGoogleTasksUserProvider);

    ref.listen(googleTasksLinkProcessStateProvider, (_, next) {
      switch (next) {
        case GoogleTasksLinkProcessStateConnected():
          showSnackBar(context, "Google Tasksとの連携に成功しました。");
        case GoogleTasksLinkProcessStateDisconnected():
          showSnackBar(context, "Google Tasksとの連携を解除しました。");
        case GoogleTasksLinkProcessStateFailed(:final TasksAuthException e):
          showSnackBar(context, e.code.userFriendlyMessage);
        case GoogleTasksLinkProcessStateFailed():
          showSnackBar(context, "Google Tasksとの連携に失敗しました");
        case GoogleTasksLinkProcessStateIdle():
        case GoogleTasksLinkProcessStateLoading():
          // do nothing
      }
    });

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
                      text: switch (linkState) {
                        AsyncLoading() => "読み込み中...",
                        AsyncData(:final value?) => "連携中 (${value.email})",
                        _ => "未連携",
                      },
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
            switch ((processState, linkState)) {
              (GoogleTasksLinkProcessStateLoading(), _) || (_, AsyncLoading()) => const CircularProgressIndicator(),
              (_, AsyncData(value: null)) => Column(
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
                            ref.read(googleTasksLinkProcessStateProvider.notifier)
                                .connect();
                          },
                        ),
                    ),
                  ),
                ],
              ),
              _ => Column(
                children: [
                  OutlinedButton(
                    child: const Text("連携を解除する"),
                    onPressed: () async {
                      ref.read(googleTasksLinkProcessStateProvider.notifier).disconnect();
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text("※SubmonにGoogleログインを利用している場合、ログイン時に自動的に連携されます。"),
                ],
              ),
            },
          ],
        ),
      ),
    );
  }
}
