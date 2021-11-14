import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';

class FadeThroughPageRoute extends PageRoute {
  FadeThroughPageRoute(this.page, {this.arguments});

  Widget page;
  Object? arguments;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return page;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }

  @override
  RouteSettings get settings => RouteSettings(arguments: arguments);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}