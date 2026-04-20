import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:logging/logging.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "scaffold_messenger.g.dart";

@riverpod
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey(Ref ref) {
  return GlobalKey();
}

extension WidgetRefScaffoldMessengerExtension on WidgetRef {
  ScaffoldMessengerState get _messenger {
    final messenger = read(scaffoldMessengerKeyProvider).currentState;
    if (messenger == null) {
      throw StateError("ScaffoldMessenger key is not mounted.");
    }
    return messenger;
  }

  void showSnackBar(
    String message, {
    SnackBarAction? action,
    TextStyle? messageStyle,
    Duration duration = const Duration(seconds: 4),
    Color? color,
  }) {
    if (!context.mounted) {
      log("showSnackBar was called after context is unmounted.",
        level: Level.WARNING.value);
      return;
    }
    _messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message, style: messageStyle),
        behavior: .floating,
        action: action,
        duration: duration,
        backgroundColor: color,
      ));
  }

  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      messageStyle: TextStyle(
        fontWeight: .bold,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
      duration: const Duration(seconds: 12),
      color: Theme.of(context).colorScheme.errorContainer,
    );
  }
}
