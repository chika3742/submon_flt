import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:submon/events.dart';
import 'package:submon/pages/home_tabs/tab_memorize_card.dart';
import 'package:submon/pages/home_tabs/tab_others.dart';
import 'package:submon/pages/home_tabs/tab_submissions.dart';
import 'package:submon/pages/home_tabs/tab_timetable.dart';

import '../fade_through_page_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _eventBus = EventBus();
  var tabIndex = 0;

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

  @override
  void initState() {
    super.initState();
    pages = [
      TabSubmissions(_eventBus),
      const TabTimetable(),
      const TabMemorizeCard(),
      const TabOthers(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      key: const ObjectKey(0),
      appBar: PlatformAppBar(
        title: Text(_bottomNavigationItems()[tabIndex].label!),
      ),
      body: SafeArea(
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            return FadeThroughPageRoute(pages.first);
          },
        ),
      ),
      bottomNavBar: PlatformNavBar(
        currentIndex: tabIndex,
        items: _bottomNavigationItems(),
        itemChanged: onBottomNavTap,
      ),
    );
  }

  void onBottomNavTap(int index) {
    if (tabIndex == index) {
      _eventBus.fire(BottomNavDoubleClickEvent(index));
      return;
    }
    _navigatorKey.currentState?.pushReplacement(FadeThroughPageRoute(pages[index]));
    setState(() {
      tabIndex = index;
    });
  }
}
