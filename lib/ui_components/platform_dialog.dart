import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool? barrierDismissible,
}) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      // for iOS / macOS
      return showCupertinoDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible ?? false,
        builder: builder,
      );

    default:
      // for Android / Windows and others
      return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible ?? true,
        builder: builder,
      );
  }
}

class PlatformAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  const PlatformAlertDialog({
    Key? key,
    this.title,
    this.content,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // for iOS / macOS
        return CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actions,
        );

      default:
        // for Android / Windows and others
        return AlertDialog(
          title: title,
          content: content,
          actions: actions,
        );
    }
  }
}

class PlatformTextButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const PlatformTextButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // for iOS / macOS
        return CupertinoButton(
          onPressed: onPressed,
          child: child,
        );

      default:
        // for Android / Windows and others
        return TextButton(
          onPressed: onPressed,
          child: child,
        );
    }
  }
}
