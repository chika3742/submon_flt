import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class GapedColumn extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  const GapedColumn({
    super.key,
    required this.children,
    this.gap = 0.0,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      children: children
          .mapIndexed((index, e) =>
              [e, if (index != children.length - 1) SizedBox(height: gap)])
          .flattened
          .toList(),
    );
  }
}
