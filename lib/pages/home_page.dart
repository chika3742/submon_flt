import "dart:async";
import "dart:io";

import "package:animations/animations.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";

import "../browser.dart";
import "../core/pref_key.dart";
import "../events.dart";
import "../fade_through_page_route.dart";
import "../isar_db/isar_provider.dart";
import "../main.dart";
import "../providers/data_sync_service.dart";
import "../providers/firestore_providers.dart";
import "../src/pigeons.g.dart";
import "../ui_components/hidable_progress_indicator.dart";
import "../utils/ad_unit_ids.dart";
import "../utils/ui.dart";
import "../utils/utils.dart";
import "home_tabs/tab_digestive_list.dart";
import "home_tabs/tab_others.dart";
import "home_tabs/tab_submissions.dart";
import "home_tabs/tab_timetable_2.dart";
import "settings/timetable.dart";
import "submission_create_page.dart";
import "timetable_table_view_page.dart";

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const routeName = "/";

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription? hideAdListener;
  StreamSubscription? switchBottomNavListener;

  var tabIndex = 0;
  var _hideAd = false;

  BannerAd? bannerAd;

  List<ActionItem> _buildAction(String path) => switch (path) {
        "digestive" => [
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
        "timetable" => [
            ActionItem(Icons.table_view, "テーブルビュー", () async {
              await Navigator.pushNamed(
                  context, TimetableTableViewPage.routeName);
            }),
            ActionItem(Icons.settings, "設定", () async {
              await Navigator.pushNamed(
                  context, TimetableSettingsPage.routeName);
              eventBus.fire(TimetableListChanged());
            }),
          ],
        _ => [],
      };

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
          final showTimetable = ref.readPref(PrefKey.showTimetableMenu);
          final paths = [
            "home",
            "digestive",
            if (showTimetable) "timetable",
            "more",
          ];
          final index = paths.indexOf(event.path);
          if (index != -1) {
            _onBottomNavTap(index, event.path);
          } else {
            showSnackBar(context, "この機能は無効化されています。カスタマイズ設定から有効化してください。");
          }
          timer.cancel();
        }
      });
    });

    fetchData();
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
    final showTimetableMenu = ref.watchPref(PrefKey.showTimetableMenu);

    final bottomNavItems = [
      const BottomNavItem(
        "home",
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "提出物",
        ),
      ),
      const BottomNavItem(
        "digestive",
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: "Digestive",
        ),
      ),
      if (showTimetableMenu)
        const BottomNavItem(
          "timetable",
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart_outlined),
            label: "時間割表",
          ),
        ),
      const BottomNavItem(
        "more",
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: "その他",
        ),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(bottomNavItems[tabIndex].item.label!),
        actions: _buildAction(bottomNavItems[tabIndex].path)
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
          HidableLinearProgressIndicator(
            show: ref.watch(dataSyncServiceProvider).isLoading,
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(
        bottomNavItems[tabIndex].path,
      ),
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
            items: bottomNavItems.map((e) => e.item).toList(),
            onTap: (index) =>
                _onBottomNavTap(index, bottomNavItems[index].path),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(String currentPath) {
    switch (currentPath) {
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

  void _onBottomNavTap(int index, String path) {
    if (index < 0) return;
    if (tabIndex == index) {
      eventBus.fire(BottomNavDoubleClickEvent(index));
      return;
    }
    setState(() {
      tabIndex = index;
    });
    _navigatorKey.currentState?.pushReplacementNamed(path);
    FirebaseAnalytics.instance
        .logScreenView(screenName: "/tab/$path");
  }

  Future<void> fetchData() async {
    final userConfigNotifier =
        ref.read(firestoreUserConfigProvider.notifier);
    await ref.read(dataSyncServiceProvider.notifier).fetchData();

    final syncState = ref.read(dataSyncServiceProvider);
    if (syncState case AsyncError(:final error, :final stackTrace)) {
      _handleSyncError(error, stackTrace);
    } else if (mounted) {
      _navigatorKey.currentState?.pushReplacementNamed("home");
      userConfigNotifier.setLastAppOpened();
    }
  }

  void _handleSyncError(Object error, StackTrace stackTrace) {
    if (error is FirebaseException) {
      handleFirebaseError(error, stackTrace, context, "データの取得に失敗しました。");
    } else if (error is SchemaVersionMismatchException) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      debugPrint(error.toString());
      if (!mounted) return;
      showSimpleDialog(
          context, "エラー", "Submonを最新版にアップデートしてください。\n\n(${error.toString()})",
          allowCancel: false,
          showCancel: true,
          cancelText: "ログアウト", onCancelPressed: () {
        FirebaseAuth.instance.signOut();
        backToWelcomePage(context);
      }, onOKPressed: () {
        Browser.openStoreListing();
        SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      });
    } else {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      if (!mounted) return;
      showSnackBar(context, "エラーが発生しました");
    }
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

  const BottomNavItem(this.path, this.item);
}
