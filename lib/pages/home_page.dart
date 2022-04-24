import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:submon/components/hidable_progress_indicator.dart';
import 'package:submon/db/digestive.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/actions.dart';
import 'package:submon/method_channel/channels.dart';
import 'package:submon/method_channel/messaging.dart';
import 'package:submon/pages/home_tabs/tab_digestive_list.dart';
import 'package:submon/pages/home_tabs/tab_others.dart';
import 'package:submon/pages/home_tabs/tab_submissions.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/utils/firestore.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../fade_through_page_route.dart';
import 'home_tabs/tab_timetable_2.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription? linkListener;
  StreamSubscription? hideAdListener;

  var tabIndex = 0;
  var _loading = false;
  var _hideAd = false;

  BannerAd? bannerAd;

  List<BottomNavItem> _bottomNavItems = [];

  List<Widget> pages = [];

  List<List<ActionItem>> actions = [];

  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Application.globalKey = _scaffoldKey;

    MessagingPlugin.getToken().then((token) {
      FirestoreProvider.saveNotificationToken(token);
    });

    linkListener = eventBus.on<SignedInWithLink>().listen((_) {
      Navigator.of(context, rootNavigator: true)
          .popUntil((route) => !route.settings.name!.startsWith("/signIn"));
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.of(context).size.width.truncate())
          .then((adSize) {
        setState(() {
          bannerAd = BannerAd(
            adUnitId: getAdUnitId(AdUnit.homeBottomBanner)!,
            size: adSize!,
            request: const AdRequest(),
            listener: const BannerAdListener(),
          );
          bannerAd!.load();
        });
      });
    });

    hideAdListener = eventBus.on<SubmissionDetailPageOpened>().listen((event) {
      setState(() {
        _hideAd = event.opened;
      });
    });

    initMethodCallHandler();
    fetchData();

    SharedPrefs.use((prefs) {
      _bottomNavItems = [
        BottomNavItem(
          BottomNavItemId.home,
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "提出物",
          ),
        ),
        BottomNavItem(
          BottomNavItemId.digestive,
          const BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "Digestive",
          ),
        ),
        if (prefs.showTimetableMenu)
          BottomNavItem(
            BottomNavItemId.timetable,
            const BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_outlined),
              label: "時間割表",
            ),
          ),
        if (prefs.showMemorizeMenu)
          BottomNavItem(
            BottomNavItemId.memorizeCard,
            const BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "暗記カード",
            ),
          ),
        BottomNavItem(
          BottomNavItemId.others,
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "その他",
          ),
        )
      ];

      pages = [
        const TabSubmissions(),
        const TabDigestiveList(),
        if (prefs.showTimetableMenu) const TabTimetable2(),
        if (prefs.showMemorizeMenu)
          const Center(
            child: Text('Coming Soon...'),
          ),
        const TabOthers(),
      ];

      actions = [
        [],
        [
          ActionItem(Icons.help, "ヘルプ", () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Digestiveとは？"),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                            "提出物に取り掛かる時間と、何分続けるかをスケジュールすることができます。集中タイマーで重い腰を上げるのにも最適。")
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
        if (prefs.showTimetableMenu)
          [
            ActionItem(Icons.table_view, "テーブルビュー", () async {
              await Navigator.pushNamed(context, "/timetable/table-view");
            }),
            ActionItem(Icons.settings, "設定", () async {
              await Navigator.pushNamed(context, "/settings/timetable");
              eventBus.fire(TimetableListChanged());
            }),
          ],
        if (prefs.showMemorizeMenu) [],
        [],
      ];
    });
  }

  @override
  void dispose() {
    linkListener?.cancel();
    hideAdListener?.cancel();
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bottomNavItems.isEmpty) {
      return Container();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_bottomNavItems[tabIndex].item.label!),
        actions: actions[tabIndex]
            .map((e) => IconButton(
                  icon: Icon(e.icon),
                  onPressed: e.onPressed,
                  splashRadius: 24,
                ))
            .toList(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Navigator(
              key: _navigatorKey,
              onGenerateRoute: (settings) {
                return FadeThroughPageRoute(pages.first);
              },
            ),
          ),
          HidableLinearProgressIndicator(show: _loading),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (bannerAd != null)
            Visibility(
              visible: !_hideAd,
              child: Container(
                alignment: Alignment.center,
                width: bannerAd!.size.width.toDouble(),
                height: bannerAd!.size.height.toDouble(),
                child: AdWidget(
                  ad: bannerAd!,
                ),
              ),
            ),
          BottomNavigationBar(
            currentIndex: tabIndex,
            items: _bottomNavItems.map((e) => e.item).toList(),
            onTap: onBottomNavTap,
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    switch (_bottomNavItems[tabIndex].id) {
      case BottomNavItemId.home:
        return OpenContainer<int>(
          useRootNavigator: true,
          closedElevation: 8,
          closedShape: const CircleBorder(),
          closedColor: Theme.of(context).canvasColor,
          closedBuilder: (context, callback) => FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              callback();
              setState(() {
                _hideAd = true;
              });
            },
          ),
          openBuilder: (context, callback) {
            return const SubmissionCreatePage();
          },
          onClosed: (result) {
            if (result != null) eventBus.fire(SubmissionInserted(result));

            setState(() {
              _hideAd = false;
            });
          },
        );
      case BottomNavItemId.digestive:
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            eventBus.fire(DigestiveAddButtonPressed());
          },
        );
      // case BottomNavItemId.memorizeCard:
      //   return FloatingActionButton(
      //     child: const Icon(Icons.add),
      //     onPressed: () {
      //       eventBus.fire(MemorizeCardAddButtonPressed());
      //     },
      //   );
      default:
        return null;
    }
  }

  void onBottomNavTap(int index) {
    if (tabIndex == index) {
      eventBus.fire(BottomNavDoubleClickEvent(index));
      return;
    }
    setState(() {
      tabIndex = index;
    });
    _navigatorKey.currentState
        ?.pushReplacement(FadeThroughPageRoute(pages[index]));
  }

  void fetchData() async {
    if (userDoc == null) return;
    setState(() {
      _loading = true;
    });

    try {
      var result = await FirestoreProvider.fetchData();

      if (result) {
        _navigatorKey.currentState
            ?.pushReplacement(FadeThroughPageRoute(pages[tabIndex]));
      }
    } on FirebaseException catch (e, stackTrace) {
      handleFirebaseError(e, stackTrace, context, "データの取得に失敗しました。");
    } on SchemaVersionMismatchException catch (e) {
      debugPrint(e.toString());
      showSimpleDialog(
          context,
          "エラー",
          "Submonを最新版にアップデートしてください。\n\n(${e.toString()})",
          allowCancel: false,
          onOKPressed: () {
            SystemChannels.platform.invokeMethod("SystemNavigator.pop");
          }
      );
    } catch (e, stackTrace) {
      showSnackBar(context, "エラーが発生しました");
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }

    setState(() {
      _loading = false;
    });
  }

  void initMethodCallHandler() {
    // actions
    void createNew() async {
      var insertedId = await Navigator.of(context, rootNavigator: true)
          .pushNamed("/submission/create", arguments: {});
      if (insertedId != null) {
        eventBus.fire(SubmissionInserted(insertedId as int));
      }
    }

    void openSubmissionDetailPage(int id) {
      Navigator.of(context, rootNavigator: true)
          .pushNamed("/submission/detail", arguments: {"id": id});
    }

    void openFocusTimerPage(int digestiveId) {
      DigestiveProvider().use((provider) async {
        var digestive = await provider.get(digestiveId);
        if (digestive != null) {
          Navigator.of(context, rootNavigator: true)
              .pushNamed("/focus-timer", arguments: {"digestive": digestive});
        } else {
          showSnackBar(context, "このDigestiveはすでに削除されています");
        }
      });
    }

    // init
    getPendingAction().then((action) {
      if (action != null) {
        switch (action.actionName) {
          case "openCreateNewPage":
            createNew();
            break;
          case "openSubmissionDetailPage":
            openSubmissionDetailPage(action.arguments!["submissionId"]);
            break;
          case "openFocusTimerPage":
            openFocusTimerPage(action.arguments!["digestiveId"]);
            break;
        }
      }
    });

    const MethodChannel(Channels.action).setMethodCallHandler((call) async {
      switch (call.method) {
        case "openCreateNewPage":
          createNew();
          break;
        case "openSubmissionDetailPage":
          openSubmissionDetailPage(call.arguments["submissionId"]);
          break;
        case "openFocusTimerPage":
          openFocusTimerPage(call.arguments["digestiveId"]);
          break;
        default:
          return UnimplementedError();
      }
    });
  }
}

class ActionItem {
  ActionItem(this.icon, this.title, this.onPressed);

  final IconData icon;
  final String title;
  final void Function()? onPressed;
}

class BottomNavItem {
  final BottomNavItemId id;
  final BottomNavigationBarItem item;

  BottomNavItem(this.id, this.item);
}

enum BottomNavItemId {
  home,
  digestive,
  timetable,
  memorizeCard,
  others,
}