import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/color_picker_dialog.dart';
import 'package:submon/components/settings_ui.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/utils/ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CanvasLmsSyncPage extends StatefulWidget {
  const CanvasLmsSyncPage({Key? key}) : super(key: key);

  @override
  State<CanvasLmsSyncPage> createState() => _CanvasLmsSyncPageState();
}

class _CanvasLmsSyncPageState extends State<CanvasLmsSyncPage> {
  bool connected = false;
  int? _currentUniversityId;
  final _accessTokenController = TextEditingController();
  final _scrollController = ScrollController();

  CanvasLms? canvas;

  @override
  void initState() {
    Future(() async {
      showLoadingModal(context);

      try {
        var canvas = (await FirestoreProvider.config)?.lms?.canvas;
        if (canvas != null) {
          setState(() {
            connected = true;
            this.canvas = canvas;
          });
        }
      } catch (e) {
        debugPrint(e.toString());
        showSnackBar(context, "連携状態の取得に失敗しました");
      }
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas と連携'),
      ),
      body: Stack(
        children: [
          if (!connected)
            Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        '大学等で利用するCanvas LMS(※)を Submon に連携することが出来ます。'
                        '月曜日〜土曜日の18:00にCanvasに登録された提出物を同期し、Submonに自動的に追加します。\n\n'
                        '以下から大学名を選択し、以下の方法で取得したアクセストークンを貼り付けてください。(提出物の同期以外の目的でこのアクセストークンを利用することはありません。)\n\n'
                        '※大学によって通称が異なります(例えば岐阜大学なら「AiMS Gifu」など)。',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      Image.asset("assets/img/canvaslms_guide_1.jpg",
                          width: 250),
                      const SizedBox(height: 16),
                      Image.asset("assets/img/canvaslms_guide_2.jpg",
                          width: 250),
                      const SizedBox(height: 16),
                      Image.asset("assets/img/canvaslms_guide_3.jpg",
                          width: 250),
                      const SizedBox(height: 16),
                      Image.asset("assets/img/canvaslms_guide_4.jpg",
                          width: 250),
                      const SizedBox(height: 16),
                      Image.asset("assets/img/canvaslms_guide_5.jpg"),
                      const SizedBox(height: 32),
                      DropdownButtonFormField<int>(
                        items: UniversityLms.getDropdownItemList(),
                        value: _currentUniversityId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('大学'),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _currentUniversityId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 200,
                        child: OutlinedButton(
                          child: const Text('追加報告'),
                          onPressed: () {
                            launchUrlString(
                                "https://docs.google.com/forms/d/e/1FAIpQLSeb0kHMcYWkl8LDpiS6NqoViuU5DHL8FcRRBHyMXXSzhiCx3Q/viewform?usp=pp_url&entry.1540960450=Canvas+LMS%E3%82%92%E5%88%A9%E7%94%A8%E3%81%99%E3%82%8B%E5%A4%A7%E5%AD%A6%E3%81%AE%E5%A0%B1%E5%91%8A",
                                mode: LaunchMode.externalApplication);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '「自分の通っている大学がない！」という際はこちらから報告してください。(ただしLMSの画面が上と同じものに限ります)',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _accessTokenController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('アクセストークン'),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          child: const Text('連携する'),
                          onPressed: integrate,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            )
          else
            SizedBox.expand(
              child: SettingsListView(
                categories: [
                  if (canvas != null)
                    SettingsCategory(
                      title: "ステータス",
                      tiles: [
                        SettingsTile(
                          title: "連携状態",
                          subtitle:
                              "連携中 (${UniversityLms.list.firstWhere((e) => e.id == canvas!.universityId, orElse: () => const UniversityLms(0, "")).name})",
                        ),
                        SettingsTile(
                          title: "最終同期",
                          subtitle: canvas!.lastSync != null
                              ? "${DateFormat("yyyy-MM-dd HH:mm").format(canvas!.lastSync!.toDate())} (${canvas!.hasError == true ? "最後の同期に失敗しました。連携を解除し、再度連携をお試しください。" : "成功"})"
                              : "未同期",
                        ),
                        SettingsTile(
                          title: "今すぐ同期",
                          onTap: () {
                            showSimpleDialog(context, "注意",
                                "本機能は短時間に何度も実行しないでください。\n\n今すぐ同期しますか？",
                                showCancel: true, onOKPressed: () async {
                              showLoadingModal(context);
                              try {
                                await FirebaseFunctions.instanceFor(
                                        region: "asia-northeast1")
                                    .httpsCallable("canvasSyncNow")();
                                Navigator.pop(context);
                                showSimpleDialog(context, "完了",
                                    "同期リクエストを送信しました。結果は本画面でご確認ください。");
                              } catch (e) {
                                Navigator.pop(context);
                                showSimpleDialog(context, "エラー", "エラーが発生しました。");
                                print(e);
                              }
                            });
                          },
                        ),
                        SettingsTile(
                            title: "提出物カラー選択",
                            subtitle: "提出物が追加される際のカラーを設定できます。",
                            onTap: () async {
                              var result = await showDialog<Color>(
                                context: context,
                                builder: (_) {
                                  return ColorPickerDialog(
                                      initialColor:
                                          Color(canvas!.submissionColor));
                                },
                              );
                              if (result != null) {
                                showLoadingModal(context);
                                await FirestoreProvider
                                    .setCanvasLmsSubmissionColor(result);
                                canvas?.submissionColor = result.value;
                                Navigator.pop(context);
                              }
                            }),
                        SettingsTile(
                            title: "同期除外リストのクリア",
                            subtitle:
                                "提出物を削除すると自動的に除外リストに登録されます。このリストをクリアすると、次回同期時に追加されるようになります。",
                            onTap: () {
                              showSimpleDialog(
                                  context, "確認", "同期除外リストをクリアしますか？",
                                  showCancel: true, onOKPressed: () async {
                                showLoadingModal(context);
                                await FirestoreProvider
                                    .clearCanvasLmsSyncExcludeList();
                                Navigator.pop(context);
                                showSnackBar(context, "クリアしました");
                              });
                            }),
                        SettingsTile(
                            title: "連携を解除する",
                            onTap: () {
                              showSimpleDialog(context, "確認",
                                  "連携を解除しますか？\n※アクセストークンを再生成する必要があります",
                                  showCancel: true, onOKPressed: () async {
                                showLoadingModal(context);
                                await FirestoreProvider.disconnectCanvasLms();
                                Navigator.pop(context);
                                setState(() {
                                  connected = false;
                                });
                              });
                            }),
                        SettingsTile(
                          subtitle: "同期は月〜土(18:00)に行われます",
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void integrate() async {
    if (_currentUniversityId == null) {
      showSnackBar(context, "大学を選択してください");
      return;
    }
    if (_accessTokenController.text == "") {
      showSnackBar(context, "アクセストークンを入力してください");
      return;
    }

    showLoadingModal(context);

    try {
      var result =
          await FirebaseFunctions.instanceFor(region: "asia-northeast1")
              .httpsCallable("validateCanvasAccessToken")
              .call({
        "universityId": _currentUniversityId,
        "accessToken": _accessTokenController.text,
      });

      if (result.data?["success"] == true) {
        showSnackBar(context, "連携しました");
        Navigator.pop(context);
      } else {
        showSnackBar(context, "連携に失敗しました。");
      }
    } on FirebaseFunctionsException catch (e) {
      switch (e.details) {
        case "failed-validation":
          showSnackBar(context, "アクセストークンが不正です。(${e.message})");
          break;
        case "invalid-university-id":
          showSnackBar(
              context, "大学が未登録です。しばらく待っても同じエラーが表示される場合、開発者に報告をお願いします。");
          break;
        default:
          showSnackBar(context, "エラーが発生しました。(${e.message})");
      }
    } finally {
      Navigator.pop(context);
    }
  }
}

class UniversityLms {
  final int id;
  final String name;

  const UniversityLms(this.id, this.name);

  static const List<UniversityLms> list = [
    UniversityLms(0, "Canvas (canvas.instructure.com)"),
    UniversityLms(1, "岐阜大学 (AiMS Gifu)"),
    UniversityLms(2, "慶應義塾大学 (K-LMS)"),
  ];

  static List<DropdownMenuItem<int>> getDropdownItemList() {
    return list.map<DropdownMenuItem<int>>((e) {
      return DropdownMenuItem<int>(
        value: e.id,
        child: Text(e.name),
      );
    }).toList();
  }
}
