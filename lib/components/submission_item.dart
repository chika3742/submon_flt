import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:material_symbols_icons/material_symbols_icons.dart";

import "../drift_db/db.dart";
import "../ui_core/theme_extension.dart";
import "remaining_time.dart";

class SubmissionItem extends StatelessWidget {
  const SubmissionItem(this.item, {super.key, required this.action});

  final Submission item;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: action,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      // remaining time
                      CustomPaint(
                        painter: RemainingTimePainter(strokeColor: Theme.of(context).colorScheme.inversePrimary),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 70),
                          child: RemainingTime(
                            item.due.difference(now),
                            inkBorderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 16),

                      // due date text
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "${item.due.month}/", style: TextStyle(fontSize: 16)),
                            TextSpan(text: item.due.day.toString().padLeft(2, "0"), style: TextStyle(fontSize: 20)),
                            TextSpan(text: DateFormat("(E)").format(item.due), style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        style: TextStyle(
                          color: getDueDateTextColor(context),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    child: Text(item.title, style: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  visualDensity: VisualDensity.comfortable,
                  icon: Icon(
                    Symbols.star,
                    fill: item.important ? 1 : 0,
                    color: item.important ? Theme.of(context).extension<SubmonThemeExtension>()!.starColor : Colors.black.withOpacity(0.6),
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  visualDensity: VisualDensity.comfortable,
                  icon: Icon(
                    Symbols.check,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color? getDueDateTextColor(BuildContext context) {
    if (item.due.isBefore(DateTime.now())) {
      return Theme.of(context).extension<SubmonThemeExtension>()!.overdueTextColor;
    }
    return null;
  }
}

class RemainingTimePainter extends CustomPainter {
  const RemainingTimePainter({required this.strokeColor});

  final Color strokeColor;
  final borderRadius = 12.0;
  final strokeWidth = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - borderRadius, size.height)
      ..relativeArcToPoint(Offset(borderRadius, -borderRadius), radius: Radius.circular(borderRadius), clockwise: false)
      ..lineTo(size.width, 0)
    ;

    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
    ;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
