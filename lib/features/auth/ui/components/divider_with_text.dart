import "package:flutter/material.dart";

class DividerWithText extends StatelessWidget {
  final Widget child;

  const DividerWithText({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Flexible(
          child: Divider(indent: 32),
        ),
        child,
        Flexible(
          child: Divider(endIndent: 32),
        ),
      ],
    );
  }
}
