import 'dart:async';

import 'package:animations/animations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:submon/components/hidable_progress_indicator.dart';
import 'package:submon/db/firestore.dart';
import 'package:submon/events.dart';
import 'package:submon/main.dart';
import 'package:submon/method_channel/actions.dart';
import 'package:submon/method_channel/channels.dart';
import 'package:submon/method_channel/notification.dart';
import 'package:submon/pages/home_tabs/tab_memorize_card.dart';
import 'package:submon/pages/home_tabs/tab_others.dart';
import 'package:submon/pages/home_tabs/tab_submissions.dart';
import 'package:submon/pages/home_tabs/tab_timetable.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/utils/firestore.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../fade_through_page_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription? linkListener;
  var tabIndex = 0;
  var _loading = false;
  var _hideAd = false;

  BannerAd? bannerAd;

  List<BottomNavigationBarItem> _bottomNavigationItems() => const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "提出物",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart_outlined),
          label: "時間割表",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: "暗記カード",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: "その他",
        ),
      ];

  List<Widget> pages = [];

  List<List<ActionItem>> actions = [];

  final timetableKey = GlobalKey<TabTimetableState>();

  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    MyApp.globalKey = _scaffoldKey;

    linkListener = eventBus.on<SignedInWithLink>().listen((_) {
      Navigator.of(context, rootNavigator: true)
          .popUntil((route) => !route.settings.name!.startsWith("/signIn"));
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
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

    eventBus.on<SubmissionDetailPageOpened>().listen((event) {
      setState(() {
        _hideAd = event.opened;
      });
    });

    initMethodCallHandler();
    fetchData();
    pages = [
      const TabSubmissions(),
      TabTimetable(key: timetableKey),
      const TabMemorizeCard(),
      const TabOthers(),
    ];
    actions = [
      [],
      [
        ActionItem(Icons.settings, "設定", () async {
          await Navigator.pushNamed(context, "/settings/timetable");
          timetableKey.currentState?.getPref();
          var state = timetableKey.currentState?.tableKey.currentState;
          state?.getPref();
          state?.getTable();
        }),
        ActionItem(Icons.edit, "編集", () async {
          await Navigator.pushNamed(context, "/timetable/edit");
          timetableKey.currentState?.setState(() {
            timetableKey.currentState?.tableKey.currentState?.getTable();
          });
        }),
      ],
      [],
      [],
    ];
  }

  @override
  void dispose() {
    linkListener?.cancel();
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_bottomNavigationItems()[tabIndex].label!),
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
            items: _bottomNavigationItems(),
            onTap: onBottomNavTap,
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    switch (tabIndex) {
      case 0:
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
      case 2:
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            eventBus.fire(MemorizeCardAddButtonPressed());
          },
        );
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
    } catch (e, stackTrace) {
      showSnackBar(context, "エラーが発生しました");
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
    }

    setState(() {
      _loading = false;
    });
  }

  void initMethodCallHandler() {
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

    getPendingAction().then((action) {
      if (action != null) {
        switch (action.actionName) {
          case "openCreateNewPage":
            createNew();
            break;
          case "openSubmissionDetailPage":
            openSubmissionDetailPage(action.argument!);
            break;
        }
      }
    });

    const MethodChannel(Channels.actions).setMethodCallHandler((call) async {
      switch (call.method) {
        case "resetNotifications":
          NotificationMethodChannel.registerReminder();
          break;
        case "openCreateNewPage":
          createNew();
          break;
        case "openSubmissionDetailPage":
          openSubmissionDetailPage(call.arguments);
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
