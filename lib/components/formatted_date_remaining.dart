import 'package:flutter/material.dart';
import 'package:submon/utils/ui.dart';

class FormattedDateRemaining extends StatelessWidget {
  const FormattedDateRemaining(this.diff, {Key? key, this.weekView = false, this.numberSize = 36}) : super(key: key);

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
                  color: getRemainingDateColor(diff.inHours))),
          TextSpan(
              text: getRemainingString(diff, weekView)[1],
              style: const TextStyle(fontSize: 18))
        ]),
      ),
    );
  }
}
