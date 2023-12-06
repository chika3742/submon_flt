import 'package:flutter/material.dart';
import 'package:submon/utils/ui.dart';

class TappableCard extends StatelessWidget {
  const TappableCard({super.key, this.child, this.onTap, this.color});

  final _cardBorderRadius = 8.0;
  final Widget? child;
  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardBorderRadius)),
      color: color?.blendedToCardColor(context),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: child,
        ),
      ),
    );
  }
}
