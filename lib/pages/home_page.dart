import "dart:async";
import "dart:io";

import "package:animations/animations.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";

import "../browser.dart";
import "../components/digestive_edit_bottom_sheet.dart";
import "../core/pref_key.dart";
import "../events.dart";
import "../fade_through_page_route.dart";
import "../features/auth/use_cases/sign_out_use_case.dart";
import "../isar_db/isar_digestive.dart";
import "../main.dart";
import "../providers/core_providers.dart";
import "../providers/data_sync_service.dart";
import "../providers/digestive_providers.dart";
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
  StreamSubscription? switchBottomNavListener;

  final _scrollControllers = {
    for (final path in ["home", "digestive", "more"])
      path: ScrollController(),
  };

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
            }),
          ],
        _ => [],
      };

  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!screenShotMode && ref.read(isAdEnabledProvider)) {
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

    switchBottomNavListener = eventBus.on<SwitchBottomNav>().listen((event) {
      Timer.periodic(const Duration(milliseconds: 25), (timer) {
        if (_navigatorKey.currentState != null && ref.read(isarProvider).hasValue) {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataSyncServiceProvider.notifier).fetchData();
    });
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    switchBottomNavListener?.cancel();
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showTimetableMenu = ref.watchPref(PrefKey.showTimetableMenu);

    final dataSyncState = ref.watch(dataSyncServiceProvider);

    ref.listen(dataSyncServiceProvider, (_, next) {
      if (next is AsyncError) {
        _handleSyncError(next.error, next.stackTrace);
      }
    });

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
                final controller = _scrollControllers[settings.name];
                if (controller != null) {
                  page = PrimaryScrollController(
                    controller: controller,
                    child: page,
                  );
                }
                return FadeThroughPageRoute(page);
              },
            ),
          ),
          HidableLinearProgressIndicator(
            show: dataSyncState is AsyncLoading,
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
            final result = await showRoundedBottomSheet<Digestive>(
              context: context,
              useRootNavigator: true,
              title: "Digestive単体作成 (提出物なし)",
              child: const DigestiveEditBottomSheet(
                submissionId: null,
              ),
            );

            if (result != null) {
              final repo = ref.read(digestiveRepositoryProvider);
              await repo.create(result);
              if (mounted) {
                showSnackBar(context, "作成しました");
              }
            }
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
      final controller = _scrollControllers[path];
      if (controller != null && controller.hasClients) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
        );
      }
      return;
    }
    setState(() {
      tabIndex = index;
    });
    _navigatorKey.currentState?.pushReplacementNamed(path);
    ref.read(analyticsProvider).logScreenView(screenName: "/tab/$path");
  }

  void _handleSyncError(Object error, StackTrace stackTrace) {
    final crashlytics = ref.read(crashlyticsProvider);

    switch (error) {
      case final FirebaseException e:
        crashlytics.recordError(e, stackTrace);
        if (!mounted) return;
        switch (e.code) {
          case "permission-denied":
            showFirestoreReadFailedDialog(
              context,
              "データの取得に失敗しました。",
              onSignOut: () async {
                await ref.read(signOutUseCaseProvider).execute();
              },
              onShowAnnouncements: () {
                Browser.openAnnouncements();
                SystemChannels.platform.invokeMethod("SystemNavigator.pop");
              },
            );
          default:
            showSnackBar(context, "データの取得に失敗しました。(${e.code})",
                duration: const Duration(seconds: 20));
        }
      case final SchemaVersionMismatchException e:
        crashlytics.recordError(e, stackTrace);
        debugPrint(e.toString());
        if (!mounted) return;
        showSimpleDialog(
            context, "エラー", "Submonを最新版にアップデートしてください。\n\n(${e.toString()})",
            allowCancel: false,
            showCancel: true,
            cancelText: "ログアウト", onCancelPressed: () async {
          await ref.read(signOutUseCaseProvider).execute();
        }, onOKPressed: () {
          Browser.openStoreListing();
          SystemChannels.platform.invokeMethod("SystemNavigator.pop");
        });
      default:
        crashlytics.recordError(error, stackTrace);
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
