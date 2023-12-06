import 'package:flutter/material.dart';

class HidableLinearProgressIndicator extends StatelessWidget {
  const HidableLinearProgressIndicator({super.key, required this.show});

  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      height: show ? 4 : 0,
      child: const LinearProgressIndicator(),
    );
  }
}
