import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/ui_components/settings_ui.dart';
import 'package:submon/utils/ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../user_config.dart';
import '../../utils/utils.dart';

class CanvasLmsSyncSettingsPage extends StatefulWidget {
  const CanvasLmsSyncSettingsPage({Key? key}) : super(key: key);

  static const routeName = "/settings/functions/canvas";

  @override
  State<CanvasLmsSyncSettingsPage> createState() => _CanvasLmsSyncSettingsPageState();
}

class _CanvasLmsSyncSettingsPageState extends State<CanvasLmsSyncSettingsPage> {
  bool connected = false;
  int? _currentUniversityId;
  final _accessTokenController = TextEditingController();
  final _scrollController = ScrollController();
  List<UniversityLms> universities = [];

  Canvas? canvas;

  @override
  void initState() {
    Future(() async {
      showLoadingModal(context);

      await _fetchSyncStatus();

      if (mounted) Navigator.pop(context);
    });
    super.initState();
  }

  Future<void> _fetchSyncStatus() async {
    try {
      universities = await UniversityLms.fetch();
      setState(() {});

      var canvas = (await FirestoreProvider.config)?.lms?.canvas;
      if (canvas != null) {
        connected = true;
        this.canvas = canvas;
      } else {
        connected = false;
        this.canvas = null;
      }
      setState(() {});
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stack);
      showSnackBar(context, "連携状態の取得に失敗しました");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                      items: _buildDropdownItemList(),
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
                        onPressed: integrate,
                        child: const Text('連携する'),
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
            child: RefreshIndicator(
              onRefresh: _fetchSyncStatus,
              child: SettingsListView(
                categories: [
                  if (canvas != null)
                    SettingsCategory(
                      title: "ステータス",
                      tiles: [
                        SettingsTile(
                          title: "連携状態",
                          subtitle:
                          "連携中 (${universities.firstWhereOrNull((e) => e.id == canvas!.universityId)?.name})",
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
                                if (mounted) {
                                  Navigator.pop(context);
                                  showSimpleDialog(context, "完了",
                                      "同期リクエストを送信しました。しばらく待ってから本画面を下にスワイプして結果をご確認ください。");
                                }
                              } catch (e, stack) {
                                Navigator.pop(context);
                                showSimpleDialog(context, "エラー", "エラーが発生しました。");
                                recordErrorToCrashlytics(e, stack);
                              }
                            });
                          },
                        ),
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
          ),
      ],
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

  List<DropdownMenuItem<int>> _buildDropdownItemList() {
    return universities.map<DropdownMenuItem<int>>((e) {
      return DropdownMenuItem<int>(
        value: e.id,
        child: Text(e.name),
      );
    }).toList();
  }
}

class UniversityLms {
  final int id;
  final String name;

  const UniversityLms(this.id, this.name);

  static Future<List<UniversityLms>> fetch() async {
    String url;
    if (kReleaseMode) {
      url =
          "https://asia-northeast1-submon-prod.cloudfunctions.net/getUniversities";
    } else {
      url =
          "https://asia-northeast1-submon-mgr.cloudfunctions.net/getUniversities";
    }
    var res = await http.get(Uri.parse(url));

    return const JsonDecoder()
        .convert(res.body)
        .map<UniversityLms>((e) => UniversityLms.fromJson(Map.from(e)))
        .toList();
  }

  UniversityLms.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"];
}
