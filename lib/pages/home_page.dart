import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
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
  var tabIndex = 0;

  static const _bottomNavigationItems = [
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

  var pages = [
    const TabSubmissions(),
    const TabTimetable(),
    const TabMemorizeCard(),
    const TabOthers(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submon"),
      ),
      body: SafeArea(
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) {
            return FadeThroughPageRoute(pages.first);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        items: _bottomNavigationItems,
        onTap: onBottomNavTap,
      ),
    );
  }

  void onBottomNavTap(int index) {
    if (tabIndex == index) {
      eventBus.fire(BottomNavDoubleClickEvent(index));
      return;
    }
    _navigatorKey.currentState?.push(FadeThroughPageRoute(pages[index]));
    setState(() {
      tabIndex = index;
    });
  }
}
