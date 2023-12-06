import 'package:flutter/material.dart';
import 'package:submon/utils/ui.dart';

class FormattedDateRemaining extends StatelessWidget {
  const FormattedDateRemaining(this.diff,
      {super.key, this.weekView = false, this.numberSize = 36});

  final bool weekView;
  final Duration diff;
  final double numberSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
              text: getRemainingString(diff, weekView)[0],
              style: TextStyle(
                  fontSize: numberSize,
                  fontWeight: FontWeight.bold,
                  color: getRemainingDateColor(context, diff.inHours))),
          const TextSpan(
            text: " ",
          ),
          TextSpan(
              text: getRemainingString(diff, weekView)[1],
              style: const TextStyle(fontSize: 18))
        ]),
      ),
    );
  }
}
