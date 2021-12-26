import 'package:flutter/material.dart';
import 'package:submon/events.dart';
import 'package:submon/utils/ui.dart';

class TabMemorizeCard extends StatefulWidget {
  const TabMemorizeCard({Key? key}) : super(key: key);

  @override
  _TabMemorizeCardState createState() => _TabMemorizeCardState();
}

class _TabMemorizeCardState extends State<TabMemorizeCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _animController;

  final ends = [0.7, 0.8, 0.9, 1.0];

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, value: 0, duration: const Duration(milliseconds: 500));

    _animController?.forward();

    eventBus.on<MemorizeCardAddButtonPressed>().listen((event) {
      showMemorizeCardAddSheet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            _buildMemorizeItem(
                "assets/img/memorize_1.webp", "カードを見る", 1, () {}),
            _buildMemorizeItem(
                "assets/img/memorize_2.webp", "カードで確認", 2, () {}),
            _buildMemorizeItem("assets/img/memorize_3.webp", "結果を確認", 3, () {}),
            _buildMemorizeItem("assets/img/memorize_4.webp", "カード作成", 4, () {
              eventBus.fire(MemorizeCardAddButtonPressed());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMemorizeItem(
      String imageAsset, String title, int index, void Function() onTap) {
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
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0x99000000),
                  offset: Offset(2, 2),
                  blurRadius: 4.0)
            ], borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Material(
                child: Ink.image(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: onTap,
                    child: Stack(alignment: Alignment.center, children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 8)
                                ]),
                          ),
                        ),
                      ),
                    ]),
                  ),
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
            ListTile(
              title: const Text('カメラ入力でカード追加'),
              leading: const Icon(Icons.camera_alt),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed("/memorize/camera");
              },
            ),
            ListTile(
              title: Text('フォルダーの追加'),
              leading: Icon(Icons.folder),
            ),
          ],
        ));
  }
}
