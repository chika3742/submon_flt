import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:submon/ui_components/platform_dialog.dart';

import '../pages/home_page.dart';
import '../pages/welcome_page.dart';

String getWeekdayString(int weekday) {
  var weekdays = ["月", "火", "水", "木", "金", "土", "日"];
  return weekdays[weekday];
}

List<String> getRemainingString(Duration diff, bool weekView) {
  if (diff.inDays == 0) {
    return "${diff.inHours} 時間".split(" ");
  } else if (diff.inDays < 7 || !weekView) {
    return "${diff.inDays} 日".split(" ");
  } else if (diff.inDays < 28) {
    return "${(diff.inDays / 7).floor()} 週間".split(" ");
  } else {
    return "${(diff.inDays / 28).floor()} ヶ月".split(" ");
  }
}

String getUnsetOrString(String? string, bool loading) {
  if (loading) {
    return "Loading...";
  }
  if (string == null) {
    return "未設定";
  }
  return string;
}

Color getRemainingDateColor(BuildContext context, int remainingHours) {
  var dark = Theme.of(context).brightness == Brightness.dark;
  if (remainingHours < 0) {
    return dark ? Colors.redAccent.shade200 : Colors.redAccent;
  } else if (0 <= remainingHours && remainingHours <= 2 * 24) {
    return dark ? Colors.orange : Colors.orange.shade600;
  } else {
    return dark ? Colors.green.shade300 : Colors.green;
  }
}

ActionPane createDeleteActionPane(
    void Function(BuildContext context) onPressed) {
  return ActionPane(
    motion: const BehindMotion(),
    extentRatio: 0.2,
    children: [
      SlidableAction(
        onPressed: onPressed,
        icon: Icons.delete,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      )
    ],
  );
}

extension BlendToCardColor on Color {
  Color blendedToCardColor(BuildContext context) {
    return Color.alphaBlend(this, Theme.of(context).cardColor);
  }
}

void showSnackBar(BuildContext context, String text,
    {Duration duration = const Duration(seconds: 5), SnackBarAction? action}) {
  ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.surface)),
    duration: duration,
    action: action,
    dismissDirection: DismissDirection.horizontal,
  ));
}

void showMaterialBanner(BuildContext context,
    {required Widget content, required List<Widget> actions}) {
  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
    content: content,
    actions: actions,
  ));
}

void hideMaterialBanner(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
}

Future<T?> showSimpleDialog<T>(
  BuildContext context,
  String title,
  String message, {
  Function? onOKPressed,
  Function? onCancelPressed,
  String okText = "OK",
  String cancelText = "キャンセル",
  bool? allowCancel,
  bool showCancel = false,
  bool reverseOkCancelOrderOnApple = false,
}) {
  return showPlatformDialog<T>(
      context: context,
      barrierDismissible: allowCancel,
      builder: (context) {
        var actions = [
          if (showCancel)
            PlatformTextButton(
              child: Text(cancelText,
                  style: const TextStyle(fontFamily: "Murecho")),
              onPressed: () {
                Navigator.pop(context, false);
                onCancelPressed?.call();
              },
            ),
          PlatformTextButton(
            child: Text(okText, style: const TextStyle(fontFamily: "Murecho")),
            onPressed: () {
              Navigator.pop(context, true);
              onOKPressed?.call();
            },
          ),
        ];

        return PlatformAlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
          ),
          actions: reverseOkCancelOrderOnApple && !kIsWeb && Platform.isIOS
              ? actions.reversed.toList()
              : actions,
        );
      });
}

void showLoadingModal(BuildContext context) {
  showModal(
      context: context,
      builder: (context) {
        return WillPopScope(
          child: const Center(child: CircularProgressIndicator()),
          onWillPop: () async {
            return false;
          },
        );
      });
}

void showSelectSheet(
    {required BuildContext context,
    String? title,
    String? message,
    required List<SelectSheetAction> actions}) {
  var platform = Theme.of(context).platform;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: title != null
                ? Text(title, style: Theme.of(context).textTheme.titleLarge)
                : null,
            message: message != null
                ? Text(message, style: Theme.of(context).textTheme.bodyLarge)
                : null,
            actions: actions
                .map((e) => CupertinoActionSheetAction(
                    onPressed: e.onPressed, child: Text(e.title)))
                .toList(),
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("キャンセル")),
          );
        });
  } else {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            const SizedBox(height: 16),
            if (title != null)
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (message != null) const SizedBox(height: 16),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:
                    Text(message, style: Theme.of(context).textTheme.bodyLarge),
              ),
            const SizedBox(height: 16),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(actions[0].title),
                  onPressed: actions[0].onPressed,
                ),
                OutlinedButton(
                  child: Text(actions[1].title),
                  onPressed: actions[1].onPressed,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}

void backToWelcomePage(BuildContext context) {
  var navigatorState = Navigator.of(context, rootNavigator: true);
  navigatorState.popUntil(ModalRoute.withName(HomePage.routeName));
  navigatorState.pushReplacementNamed(WelcomePage.routeName);
}

class SelectSheetAction {
  final String title;
  final void Function() onPressed;

  SelectSheetAction(this.title, this.onPressed);
}

Future<T?> showRoundedBottomSheet<T>({
  required Widget child,
  required BuildContext context,
  String? title,
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8))),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  borderRadius: BorderRadius.circular(8)),
            ),
            if (title != null)
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );
    },
  );
}

Future<T?> showRoundedDraggableBottomSheet<T>({
  required BuildContext context,
  String? title,
  required Widget Function(
          BuildContext context, ScrollController scrollController)
      builder,
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8))),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        snap: true,
        initialChildSize: 0.4,
        maxChildSize: 0.7,
        snapSizes: const [0.4],
        builder: (context, controller) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      borderRadius: BorderRadius.circular(8)),
                ),
                Text(title!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                builder(context, controller),
              ],
            ),
          );
        },
      );
    },
  );
}

class TextFormFieldBottomSheet extends StatefulWidget {
  const TextFormFieldBottomSheet(
      {Key? key, required this.formLabel, this.initialText, this.onDone})
      : super(key: key);

  final String formLabel;
  final String? initialText;
  final void Function(String text)? onDone;

  @override
  _TextFormFieldBottomSheetState createState() =>
      _TextFormFieldBottomSheetState();
}

class _TextFormFieldBottomSheetState extends State<TextFormFieldBottomSheet> {
  final _controller = TextEditingController();
  String? _fieldError;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) _controller.text = widget.initialText!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(widget.formLabel),
              errorText: _fieldError,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 16),
            child: IconButton(
              icon: const Icon(Icons.check),
              splashRadius: 24,
              onPressed: () {
                if (_controller.text.isEmpty) {
                  setState(() {
                    _fieldError = "入力してください";
                  });
                } else {
                  setState(() {
                    _fieldError = null;
                  });

                  widget.onDone?.call(_controller.text);
                }
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
      ],
    );
  }
}
