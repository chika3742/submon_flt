import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:material_symbols_icons/material_symbols_icons.dart";

import "../i18n/strings.g.dart";
import "../routes.dart";

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.child});

  final Widget child;

  final navigationBarDestinations = <Widget>[
    NavigationDestination(
      icon: Icon(Symbols.checklist, grade: 200),
      label: tr.pages.submissions,
    ),
    NavigationDestination(
      icon: Icon(Symbols.task, grade: 200),
      label: tr.pages.digestives,
    ),
    NavigationDestination(
      icon: Icon(Symbols.table_chart, grade: 200),
      label: tr.pages.timetable,
    ),
    NavigationDestination(
      icon: Icon(Symbols.more_horiz, grade: 200),
      label: tr.pages.more,
    ),
  ];

  int getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith("/submissions")) {
      return 0;
    }
    if (location.startsWith("/digestives")) {
      return 1;
    }
    if (location.startsWith("/timetable")) {
      return 2;
    }
    if (location.startsWith("/more")) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: navigationBarDestinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              SubmissionListScreenRoute().go(context);
            case 1:
              DigestiveListScreenRoute().go(context);
            case 2:
              TimetableScreenRoute().go(context);
            case 3:
              MoreScreenRoute().go(context);
          }
        },
      ),
    );
  }
}
