import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submon/components/hidable_progress_indicator.dart';
import 'package:submon/db/firestore.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/pages/home_tabs/tab_memorize_card.dart';
import 'package:submon/pages/home_tabs/tab_others.dart';
import 'package:submon/pages/home_tabs/tab_submissions.dart';
import 'package:submon/pages/home_tabs/tab_timetable.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/utils/firestore.dart';
import 'package:submon/utils/ui.dart';

import '../fade_through_page_route.dart';
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  var tabIndex = 0;
  var _loading = false;

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

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
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
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: tabIndex == 0
          ? OpenContainer<int>(
              useRootNavigator: true,
              closedElevation: 8,
              closedShape: const CircleBorder(),
              closedColor: Theme.of(context).canvasColor,
              closedBuilder: (context, callback) => FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: callback,
              ),
              openBuilder: (context, callback) {
                return const SubmissionCreatePage();
              },
              onClosed: (result) {
                if (result != null) eventBus.fire(SubmissionInserted(result));
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        items: _bottomNavigationItems(),
        onTap: onBottomNavTap,
      ),
    );
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

  void initDynamicLinks() {
    FirebaseDynamicLinks.instance.getInitialLink().then((linkData) {
      if (linkData != null) handleDynamicLink(linkData.link);
    });
    FirebaseDynamicLinks.instance.onLink.listen((linkData) async {
      handleDynamicLink(linkData.link);
    });
  }

  void handleDynamicLink(Uri url) async {
    var auth = FirebaseAuth.instance;
    var code = url.queryParameters["oobCode"];
    if (code == null) return;

    showLoadingModal(context);

    ActionCodeInfo codeInfo;
    try {
      codeInfo = await auth.checkActionCode(code);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      switch (e.code) {
        case "invalid-action-code":
        case "firebase_auth/invalid-action-code":
          showSnackBar(context, "このリンクは無効です。期限が切れたか、形式が正しくありません。");
          break;
        default:
          handleAuthError(e, context);
          break;
      }
      return;
    }

    try {
      if (auth.isSignInWithEmailLink(url.toString())) {
        final pref = SharedPrefs(await SharedPreferences.getInstance());
        final email = pref.linkSignInEmail;
        if (email != null) {
          var result = await auth.signInWithEmailLink(
              email: email, emailLink: url.toString());
          Navigator.of(context)
              .pushNamed("/signIn", arguments: {"initialCred": result});
        } else {
          showSimpleDialog(
              context, "エラー", "メールアドレスが保存されていません。再度この端末でメールを送信してください。");
        }
      } else if (codeInfo.operation ==
          ActionCodeInfoOperation.verifyAndChangeEmail) {
        await auth.applyActionCode(code);
        await auth.signOut();
        showSnackBar(context, "メールアドレスの変更が完了しました。再度ログインが必要となります。");
        Navigator.pushNamed(context, "/signIn");
      }
    } on FirebaseAuthException catch (e) {
      handleAuthError(e, context);
    }
    Navigator.pop(context);
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
}

class ActionItem {
  ActionItem(this.icon, this.title, this.onPressed);

  final IconData icon;
  final String title;
  final void Function()? onPressed;
}
