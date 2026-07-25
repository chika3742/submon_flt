import "dart:developer";

import "package:flutter/material.dart" hide showDialog;
import "package:flutter/material.dart" as material;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "modals.g.dart";

@riverpod
GlobalKey<NavigatorState> navigatorKey(Ref ref) {
  return GlobalKey();
}

extension WidgetRefModalsExtension on WidgetRef {
  BuildContext get _context {
    final context = read(navigatorKeyProvider).currentContext;
    if (context == null) {
      throw StateError("Navigator key is not mounted.");
    }
    return context;
  }

  Future<T?> showDialog<T>(
    String title, {
    Widget? content,
    List<Widget> actions = const [],
  }) {
    if (!context.mounted) {
      log("showDialog was called after context is unmounted.",
          level: Level.WARNING.value);
      return Future.value(null);
    }
    return material.showDialog<T>(
      context: _context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: actions,
        );
      },
    );
  }

  Future<bool> showSimpleDialog(
      String title,
      String content, {
        bool showCancel = false,
      }) async {
    final result = await showDialog<bool>(
      title,
      content: Text(content),
      actions: [
        if (showCancel)
          TextButton(
            child: Text("キャンセル"),
            onPressed: () => context.pop(false),
          ),
        TextButton(
          child: Text("OK"),
          onPressed: () => context.pop(true),
        ),
      ],
    );
    return result == true;
  }
}
