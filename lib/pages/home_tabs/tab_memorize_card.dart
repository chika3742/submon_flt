import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/db/memorize_card_folder.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/pages/memorize_card/camera_preview_page.dart';
import 'package:submon/utils/ui.dart';

class TabMemorizeCard extends StatefulWidget {
  const TabMemorizeCard({Key? key}) : super(key: key);

  @override
  _TabMemorizeCardState createState() => _TabMemorizeCardState();
}

class _TabMemorizeCardState extends State<TabMemorizeCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _animController;
  StreamSubscription? _streamSubscription;

  final ends = [0.6, 0.7, 0.8, 0.9, 1.0];

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, value: 0, duration: const Duration(milliseconds: 500));

    _animController?.forward();

    _streamSubscription =
        eventBus.on<MemorizeCardAddButtonPressed>().listen((event) {
      showMemorizeCardAddSheet();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _buildMemorizeItem("カードを見る", 1, Icons.remove_red_eye),
            _buildMemorizeItem("チェックテスト", 2, Icons.check),
            _buildMemorizeItem("テストの結果", 3, Icons.trending_up),
            _buildMemorizeItem("みんなのカード", 4, Icons.catching_pokemon),
            _buildMemorizeItem("カード作成", 5, Icons.add, onTap: () {
              eventBus.fire(MemorizeCardAddButtonPressed());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMemorizeItem(String title, int index, IconData icon,
      {void Function()? onTap}) {
    return SlideTransition(
        position: Tween(
                begin: Offset(-0.5 - index.toDouble() * 0.3, 0),
                end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animController!,
                curve:
                    Interval(0, ends[index - 1], curve: Curves.easeOutQuint))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 80,
            child: Card(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(icon, size: 32),
                          const SizedBox(width: 16),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onTap == null)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Coming Soon',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: 'Play',
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void showMemorizeCardAddSheet() {
    showRoundedBottomSheet(
      context: context,
      useRootNavigator: true,
      title: "追加",
      child: Column(
        children: [
          ListTile(
            title: Text('手入力でカード追加'),
            leading: Icon(Icons.add),
          ),
          if (Platform.isAndroid || Platform.isIOS)
            ListTile(
              title: const Text('カメラ入力でカード追加'),
              leading: const Icon(Icons.camera_alt),
              onTap: () async {
                // 同意画面を表示
                var pref = SharedPrefs(await SharedPreferences.getInstance());
                if (!pref.isCameraPrivacyPolicyDisplayed) {
                  var dialogResult = await showSimpleDialog(
                    context,
                    policyDialogTitle,
                    policyDialogContent,
                    allowCancel: false,
                    showCancel: true,
                    okText: "同意する",
                    cancelText: "同意しない",
                  );
                  if (dialogResult != true) {
                    return;
                  }
                  pref.isCameraPrivacyPolicyDisplayed = true;
                }

                _popRoot();
                Colors.orangeAccent;

                // フォルダー選択画面を表示
                _showFolderSelectBottomSheet((id) async {
                  if (await Permission.camera.request().isGranted ||
                      Platform.isIOS) {
                    _popRoot();

                    eventBus.fire(SubmissionDetailPageOpened(true));
                    // カメラを表示
                    await Navigator.of(context, rootNavigator: true)
                        .pushNamed("/memorize_card/camera", arguments: {
                      "folderId": id,
                    });

                    eventBus.fire(SubmissionDetailPageOpened(false));
                  } else {
                    showSimpleDialog(
                      context,
                      "権限について",
                      "カメラ権限を許可しない選択をしたため、この機能はご利用いただけません。許可画面が表示されなかった場合は、設定画面から権限を許可する必要があります。",
                      showCancel: true,
                      okText: "設定画面に移動",
                      onOKPressed: () {
                        openAppSettings();
                      },
                    );
                  }
                });
              },
            ),
          ListTile(
            title: const Text('フォルダーの追加'),
            leading: const Icon(Icons.folder),
            onTap: () {
              _popRoot();
              _showCreateFolderBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  void _showFolderSelectBottomSheet(Function(int id) onSelected) {
    MemorizeCardFolderProvider().use((provider) async {
      var folders = await provider.getAll();
      await showRoundedDraggableBottomSheet(
        context: context,
        useRootNavigator: true,
        title: "フォルダー選択",
        builder: (context, controller) {
          return Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: controller,
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    var item = folders[index];
                    return ListTile(
                      title: Text(item.title),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 0,
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('名称変更'),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('削除'),
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              break;
                            case 1:
                              break;
                          }
                        },
                      ),
                      onTap: () {
                        onSelected(item.id!);
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      splashRadius: 24,
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _popRoot();
                        _showCreateFolderBottomSheet(onDismiss: () {
                          _showFolderSelectBottomSheet(onSelected);
                        });
                      },
                    ),
                  ),
                ),
                if (folders.isEmpty)
                  const Center(
                    child: Text('フォルダーがありません'),
                  )
              ],
            ),
          );
        },
      );
    });
  }

  void _showCreateFolderBottomSheet({void Function()? onDismiss}) async {
    await showRoundedBottomSheet(
        context: context,
        title: "フォルダー作成",
        useRootNavigator: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("暗記カードのフォルダーを作成します。"),
            const SizedBox(height: 16),
            TextFormFieldBottomSheet(
              formLabel: "フォルダー名",
              onDone: (text) {
                MemorizeCardFolderProvider().use((provider) async {
                  await provider.insert(MemorizeCardFolder(title: text));
                  _popRoot();
                });
              },
            ),
          ],
        ));
    onDismiss?.call();
  }

  void _popRoot() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
