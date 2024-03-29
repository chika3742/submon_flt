import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:submon/browser.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/isar_db/isar_provider.dart';
import 'package:submon/main.dart';
import 'package:submon/pages/home_tabs/tab_digestive_list.dart';
import 'package:submon/pages/home_tabs/tab_others.dart';
import 'package:submon/pages/home_tabs/tab_submissions.dart';
import 'package:submon/pages/settings/timetable.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/pages/timetable_table_view_page.dart';
import 'package:submon/src/pigeons.g.dart';
import 'package:submon/ui_components/hidable_progress_indicator.dart';
import 'package:submon/utils/firestore.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../fade_through_page_route.dart';
import '../utils/ad_unit_ids.dart';
import 'home_tabs/tab_timetable_2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = "/";

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription? hideAdListener;
  StreamSubscription? switchBottomNavListener;

  var tabIndex = 0;
  var _loading = false;
  var _hideAd = false;
  SharedPrefs? _prefs;

  BannerAd? bannerAd;

  List<BottomNavItem> get _bottomNavItems => [
        BottomNavItem(
          "home",
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "提出物",
          ),
        ),
        BottomNavItem(
          "digestive",
          const BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "Digestive",
          ),
        ),
        if (_prefs?.showTimetableMenu != false)
          BottomNavItem(
            "timetable",
            const BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_outlined),
              label: "時間割表",
            ),
          ),
        BottomNavItem(
          "more",
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "その他",
          ),
        ),
      ];

  List<List<ActionItem>> get actions => [
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
                    const Text(
                        "ダイジェスティブでは、提出物に取り掛かる時間と、何分続けるかをスケジュールすることができます。\n集中タイマーで重い腰を上げるのにも最適。"),
                    const SizedBox(height: 16),
                    Image.asset("assets/img/digestive_guide.jpg"),
                    const SizedBox(height: 16),
                    const Text(
                        "※Digestiveの通知は5分毎(サーバー時間)に行われます。例えば、28分にセットしていて「通知する時間」を5分前に設定していた場合、25分に通知されます。\n"
                            "また、ユーザー数が増えれば増えるほど、サーバー側の処理量が増え通知が遅れる可能性があります。対策を検討しています。")
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }),
    ],
    if (_prefs?.showTimetableMenu != false)
      [
        ActionItem(Icons.table_view, "テーブルビュー", () async {
          await Navigator.pushNamed(context, TimetableTableViewPage.routeName);
        }),
        ActionItem(Icons.settings, "設定", () async {
          await Navigator.pushNamed(context, TimetableSettingsPage.routeName);
          eventBus.fire(TimetableListChanged());
        }),
      ],
    [],
  ];

  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!screenShotMode && isAdEnabled) {
        AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
                MediaQuery.of(context).size.width.truncate())
            .then((adSize) async {
          if (Platform.isIOS) {
            await GeneralApi().requestIDFA();
          }
          setState(() {
            bannerAd = BannerAd(
              adUnitId: AdUnits.homeBottomBanner!,
              size: adSize!,
              request: const AdRequest(),
              listener: const BannerAdListener(),
            );
            bannerAd!.load();
          });
        });
      }
    });

    hideAdListener = eventBus.on<SetAdHidden>().listen((event) {
      setState(() {
        _hideAd = event.hidden;
      });
    });

    switchBottomNavListener = eventBus.on<SwitchBottomNav>().listen((event) {
      Timer.periodic(const Duration(milliseconds: 25), (timer) {
        if (_navigatorKey.currentState != null && IsarProvider.opening == false) {
          var index = _bottomNavItems.indexWhere((e) => e.path == event.path);
          if (index != -1) {
            onBottomNavTap(index);
          } else {
            showSnackBar(context, "この機能は無効化されています。カスタマイズ設定から有効化してください。");
          }
          timer.cancel();
        }
      });
    });

    fetchData();

    SharedPrefs.use((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });
  }

  @override
  void dispose() {
    hideAdListener?.cancel();
    bannerAd?.dispose();
    switchBottomNavListener?.cancel();
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
              initialRoute: "home",
              onGenerateRoute: (settings) {
                Widget page;
                switch (settings.name) {
                  case "home":
                    page = const TabSubmissions();
                    break;

                  case "digestive":
                    page = const TabDigestiveList();
                    break;

                  case "timetable":
                    page = const TabTimetable2();
                    break;

                  case "more":
                    page = const TabOthers();
                    break;

                  default:
                    page = const Center(child: Text("?"));
                }
                return FadeThroughPageRoute(page);
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
    switch (_bottomNavItems[tabIndex].path) {
      case "home":
        return OpenContainer<int>(
          useRootNavigator: true,
          closedElevation: 6,
          closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
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
            return const CreateSubmissionPage();
          },
          onClosed: (result) {
            if (result != null) eventBus.fire(SubmissionInserted(result));

            setState(() {
              _hideAd = false;
            });
          },
        );
      case "digestive":
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
    if (index < 0) return;
    if (tabIndex == index) {
      eventBus.fire(BottomNavDoubleClickEvent(index));
      return;
    }
    setState(() {
      tabIndex = index;
    });
    _navigatorKey.currentState
        ?.pushReplacementNamed(_bottomNavItems[index].path);
    FirebaseAnalytics.instance
        .logScreenView(screenName: "/tab/${_bottomNavItems[index].path}");
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
            ?.pushReplacementNamed(_bottomNavItems[tabIndex].path);
      }
    } on FirebaseException catch (e, stackTrace) {
      handleFirebaseError(e, stackTrace, context, "データの取得に失敗しました。");
    } on SchemaVersionMismatchException catch (e) {
      debugPrint(e.toString());
      showSimpleDialog(
          context, "エラー", "Submonを最新版にアップデートしてください。\n\n(${e.toString()})",
          allowCancel: false,
          showCancel: true,
          cancelText: "ログアウト", onCancelPressed: () {
        FirebaseAuth.instance.signOut();
        backToWelcomePage(context);
      }, onOKPressed: () {
        Browser.openStoreListing();
        SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      });
    } catch (e, stackTrace) {
      showSnackBar(context, "エラーが発生しました");
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }

    setState(() {
      _loading = false;
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
  final String path;
  final BottomNavigationBarItem item;

  BottomNavItem(this.path, this.item);
}
