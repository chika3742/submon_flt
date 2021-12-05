import 'package:flutter/material.dart';

class HidableLinearProgressIndicator extends StatelessWidget {
  const HidableLinearProgressIndicator({Key? key, required this.show})
      : super(key: key);

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
