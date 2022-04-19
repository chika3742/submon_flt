import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:submon/components/list_tile.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/db/timetable_custom_subject.dart';
import 'package:submon/events.dart';
import 'package:submon/pages/timetable_edit_page.dart';
import 'package:submon/shared_axis_page_route.dart';
import 'package:submon/utils/ui.dart';

class TimetableSubjectSelectPage extends StatefulWidget {
  const TimetableSubjectSelectPage(this.weekday, this.index, {Key? key})
      : super(key: key);

  final int weekday;
  final int index;

  @override
  _TimetableSubjectSelectPageState createState() =>
      _TimetableSubjectSelectPageState();
}

class _TimetableSubjectSelectPageState
    extends State<TimetableSubjectSelectPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  var _showFab = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${getWeekdayString(widget.weekday)}曜日 ${widget.index}時間目"),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: _showFab
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showRoundedBottomSheet(
                  context: context,
                  title: "教科作成",
                  child: const CreateSubjectBottomSheet(),
                );
              },
            )
          : null,
      body: WillPopScope(
        onWillPop: () async {
          if (_navigatorKey.currentState!.canPop()) {
            _navigatorKey.currentState!.pop();
            setState(() {
              _showFab = false;
            });
            return false;
          } else {
            return true;
          }
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: "/timetable/edit/select",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "/timetable/edit/select":
                return SharedAxisPageRoute(
                    _CategoryPage(navigatorKey: _navigatorKey));
              case "/timetable/edit/select/list":
                if ((settings.arguments as Map)["category"] ==
                    _Category.custom) {
                  setState(() {
                    _showFab = true;
                  });
                }
                return SharedAxisPageRoute(
                    _ListPage((settings.arguments as Map)["category"]));
            }
          },
        ),
      ),
    );
  }
}

class CreateSubjectBottomSheet extends StatefulWidget {
  const CreateSubjectBottomSheet({Key? key}) : super(key: key);

  @override
  _CreateSubjectBottomSheetState createState() =>
      _CreateSubjectBottomSheetState();
}

class _CreateSubjectBottomSheetState extends State<CreateSubjectBottomSheet> {
  final _controller = TextEditingController();
  String? _fieldError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: const Text('教科名'),
              errorText: _fieldError,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.check),
                splashRadius: 24,
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    setState(() {
                      _fieldError = "入力してください";
                    });
                  } else {
                    setState(() {
                      _fieldError = null;
                    });
                    TimetableCustomSubjectProvider().use((provider) async {
                      var data = await provider.insert(
                          TimetableCustomSubject(title: _controller.text));
                      eventBus.fire(TimetableCustomSubjectInserted(data));
                      Navigator.pop(context);
                    });
                  }
                },
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}

class _CategoryPage extends StatefulWidget {
  const _CategoryPage({Key? key, this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<_CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<_CategoryPage> {
  var _historyList = <String>[];
  var animatedListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    SharedPrefs.use((prefs) {
      setState(() {
        _historyList = prefs.timetableHistory;
      });
      var i = 0;
      for (var _ in _historyList) {
        animatedListKey.currentState?.insertItem(i, duration: Duration.zero);
        i++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: [
          SimpleListTile(
              title: "選択を解除する",
              leadingIcon: const Icon(Icons.clear),
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(FieldValue.unselect);
              }),
          if (_historyList.isNotEmpty) const CategoryListTile("最近選択した科目"),
          AnimatedList(
            key: animatedListKey,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, pos, anim) {
              var item = _historyList[pos];
              return SizeTransition(
                sizeFactor: Tween(begin: 0.0, end: 1.0)
                    .chain(CurveTween(curve: Curves.fastOutSlowIn))
                    .animate(anim),
                child: buildHistoryItem(item, pos),
              );
            },
          ),
          const CategoryListTile("カテゴリー"),
          ..._Category.values
              .map((e) => SimpleListTile(
                  title: e.toJPString(),
                  onTap: () {
                    widget.navigatorKey?.currentState
                        ?.pushNamed("/timetable/edit/select/list", arguments: {
                      "category": e,
                    });
                  }))
              .toList()
        ],
      ),
    );
  }

  Widget buildHistoryItem(String item, int pos) {
    return Slidable(
      key: ValueKey(item),
      child: SimpleListTile(
        title: item,
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop(item);
        },
      ),
      endActionPane: createDeleteActionPane((context) {
        SharedPrefs.use((prefs) {
          prefs.timetableHistory = prefs.timetableHistory..remove(item);
          _historyList = prefs.timetableHistory;
          animatedListKey.currentState?.removeItem(pos, (context, animation) {
            return SizeTransition(
              sizeFactor: Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.fastOutSlowIn.flipped))
                  .animate(animation),
              child: buildHistoryItem(item, pos),
            );
          });
        });
      }),
    );
  }
}

class _ListPage extends StatefulWidget {
  const _ListPage(this.category, {Key? key}) : super(key: key);

  final _Category category;

  @override
  State<_ListPage> createState() => _ListPageState();

  static var japanese = [
    "国語",
    "国語Ⅰ",
    "国語Ⅱ",
    "国語総合",
    "国語表現",
    "国語表現Ⅰ",
    "国語表現Ⅱ",
    "現代文",
    "現代文A",
    "現代文B",
    "現代国語",
    "古典",
    "古典A",
    "古典B",
    "漢文",
    "古文",
    "作文",
    "小論文",
    "読書",
    "書写",
    "書道",
  ];

  static var math = [
    "数学",
    "数学A",
    "数学B",
    "数学C",
    "数学Ⅰ",
    "数学Ⅱ",
    "数学Ⅲ",
    "算数",
    "数学基礎",
    "数学活用",
    "数学演習1",
    "数学演習2",
  ];

  static var science = [
    "理科",
    "理科基礎",
    "理科総合",
    "理科総合A",
    "理科総合B",
    "理数",
    "理数Ⅰ",
    "理数Ⅱ",
    "理数化学",
    "理数生物",
    "理数物理",
    "生物",
    "生物基礎",
    "生物Ⅰ",
    "生物Ⅱ",
    "物理",
    "物理基礎",
    "物理Ⅰ",
    "物理Ⅱ",
    "化学",
    "化学基礎",
    "化学Ⅰ",
    "化学Ⅱ",
    "地学",
    "地学基礎",
    "地学Ⅰ",
    "地学Ⅱ",
    "実験",
    "課題研究",
    "科学と人間生活",
  ];

  static var social = [
    "社会",
    "現代社会",
    "歴史",
    "日本史",
    "日本史A",
    "日本史B",
    "世界史",
    "世界史A",
    "世界史B",
    "地理",
    "地理A",
    "地理B",
    "公民",
    "政治",
    "経済",
    "政治経済",
    "地歴",
    "地理歴史",
    "日本地理",
    "世界地理",
    "倫理",
  ];

  static var english = [
    "英語",
    "英語1",
    "英語2",
    "英語Ⅰ",
    "英語Ⅱ",
    "英語表現",
    "英語表現Ⅰ",
    "英語表現Ⅱ",
    "英語会話",
    "オーラル・コミュニケーション",
    "ライティング",
    "リーディング",
    "リスニング",
    "グラマー",
    "コミュニケーション英語基礎",
    "コミュニケーション英語Ⅰ",
    "コミュニケーション英語Ⅱ",
    "コミュニケーション英語Ⅲ",
  ];

  static var others = [
    "体育",
    "音楽",
    "美術",
    "保健",
    "保健体育",
    "家政",
    "家庭",
    "家庭基礎",
    "家庭総合",
    "図画",
    "図画工作",
    "器楽合奏",
    "技術",
    "技術家庭",
    "芸術",
    "工芸",
    "工作",
    "商業",
    "農業",
    "工業",
    "水産",
    "情報",
    "情報実習",
    "情報処理",
    "情報の科学",
    "宗教",
    "福祉",
    "奉仕",
    "看護",
    "道徳",
    "天文学",
    "生活デザイン",
    "社会と情報",
    "HR",
    "LHR",
    "自習",
    "部活",
    "クラブ",
    "学活",
    "生活",
    "総合",
    "外国語",
    "外国語1",
    "外国語2",
  ];
}

class _ListPageState extends State<_ListPage> {
  final _animatedListKey = GlobalKey<AnimatedListState>();
  StreamSubscription? insertedSubscription;
  List<String> subjects = [];
  List<TimetableCustomSubject> customSubjects = [];

  @override
  void initState() {
    super.initState();
    if (widget.category != _Category.custom) {
      subjects = _getSubjects();
    } else {
      TimetableCustomSubjectProvider().use((provider) async {
        final list = await provider.getAll();
        setState(() {
          customSubjects = list;
        });
        var i = 0;
        for (var _ in customSubjects) {
          _animatedListKey.currentState?.insertItem(i);
          i++;
        }
      });

      insertedSubscription =
          eventBus.on<TimetableCustomSubjectInserted>().listen((event) {
        setState(() {
          customSubjects.add(event.data);
        });
        _animatedListKey.currentState?.insertItem(customSubjects.length - 1);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    insertedSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          _buildListView(),
          if (customSubjects.isEmpty && subjects.isEmpty)
            const Center(
              child: Text('教科がありません'),
            ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    if (widget.category != _Category.custom) {
      return ListView(
        children: [
          CategoryListTile(widget.category.toJPString()),
          ...subjects.map((e) {
            return SimpleListTile(
                title: e,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop(e);
                });
          }).toList()
        ],
      );
    } else {
      return AnimatedOpacity(
        opacity: customSubjects.isNotEmpty ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryListTile(widget.category.toJPString()),
            Expanded(
              child: AnimatedList(
                key: _animatedListKey,
                initialItemCount: customSubjects.length,
                itemBuilder: (context, pos, anim) {
                  var item = customSubjects[pos];
                  return SizeTransition(
                    sizeFactor: Tween(begin: 0.0, end: 1.0)
                        .chain(CurveTween(curve: Curves.fastOutSlowIn))
                        .animate(anim),
                    child: _buildItem(item, pos),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildItem(TimetableCustomSubject item, int index) {
    return Slidable(
      key: ValueKey(item.id),
      child: SimpleListTile(
          title: item.title,
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop(item.title);
          }),
      endActionPane: createDeleteActionPane((ctx) {
        TimetableCustomSubjectProvider().use((provider) async {
          await provider.delete(item.id!);
        });
        setState(() {
          customSubjects.removeWhere((element) => element.id == item.id);
        });
        _animatedListKey.currentState?.removeItem(index, (context, animation) {
          return SizeTransition(
            sizeFactor: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.fastOutSlowIn.flipped))
                .animate(animation),
            child: _buildItem(item, index),
          );
        });
      }),
    );
  }

  List<String> _getSubjects() {
    switch (widget.category) {
      case _Category.japanese:
        return _ListPage.japanese;
      case _Category.math:
        return _ListPage.math;
      case _Category.science:
        return _ListPage.science;
      case _Category.social:
        return _ListPage.social;
      case _Category.english:
        return _ListPage.english;
      case _Category.others:
        return _ListPage.others;
      case _Category.custom:
        return [];
    }
  }
}

enum _Category { japanese, math, science, social, english, others, custom }

extension on _Category {
  String toJPString() {
    switch (this) {
      case _Category.japanese:
        return "国語系";
      case _Category.math:
        return "数学系";
      case _Category.science:
        return "理科系";
      case _Category.social:
        return "社会系";
      case _Category.english:
        return "英語系";
      case _Category.others:
        return "その他";
      case _Category.custom:
        return "カスタム";
    }
  }
}
