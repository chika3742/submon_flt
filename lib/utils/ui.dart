import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

Color getRemainingDateColor(int remainingHours) {
  if (remainingHours < 0) {
    return Colors.red;
  } else if (0 <= remainingHours && remainingHours <= 2 * 24) {
    return Colors.orange;
  } else {
    return Colors.green;
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
    content: Text(text),
    duration: duration,
    action: action,
    dismissDirection: DismissDirection.horizontal,
  ));
}

Future<T?> showSimpleDialog<T>(
  BuildContext context,
  String title,
  String message, {
  Function? onOKPressed,
  Function? onCancelPressed,
  String okText = "OK",
  String cancelText = "キャンセル",
  bool allowCancel = true,
  bool showCancel = false,
}) {
  return showPlatformDialog<T>(
      context: context,
      barrierDismissible: allowCancel,
      builder: (context) {
        return PlatformAlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message, style: const TextStyle(fontSize: 16)),
          ),
          actions: [
            if (showCancel)
              PlatformTextButton(
                child: Text(cancelText),
                onPressed: () {
                  onCancelPressed?.call();
                  Navigator.pop(context, false);
                },
              ),
            PlatformTextButton(
              child: Text(okText),
              onPressed: () {
                onOKPressed?.call();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      });
}

void showLoadingModal(BuildContext context) {
  showModal(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });
}

void showSelectSheet(BuildContext context, String title, String message,
    List<SelectSheetAction> actions) {
  if (Platform.isIOS || Platform.isMacOS) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(title),
            message: Text(message),
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
            const SizedBox(height: 8),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(message),
            ),
            const SizedBox(height: 8),
            ...actions
                .map((e) => ListTile(
                      title: Text(e.title),
                      onTap: e.onPressed,
                    ))
                .toList(),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class SelectSheetAction {
  final String title;
  final void Function() onPressed;

  SelectSheetAction(this.title, this.onPressed);
}

Future<T?> showRoundedBottomSheet<T>({
  BuildContext? context,
  String? title,
  Widget? child,
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<T>(
    context: context!,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8))),
    builder: (ctx) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            )
          ],
        ),
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
        TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(widget.formLabel),
            errorText: _fieldError,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Spacer(),
            IconButton(
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
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
      ],
    );
  }
}
