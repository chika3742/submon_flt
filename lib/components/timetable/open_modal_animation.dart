import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class OpenModalAnimatedContainer extends StatelessWidget {
  OpenModalAnimatedContainer({
    Key? key,
    required this.context,
    required this.width,
    required this.height,
    this.tappable = true,
    required this.closedBuilder,
    required this.openBuilder,
  }) : super(key: key);

  final hideableKey = GlobalKey<_HideableState>();
  final _closedBuilderKey = GlobalKey();

  final BuildContext? context;
  final double? width;
  final double? height;
  final bool tappable;
  final WidgetBuilder? closedBuilder;
  final WidgetBuilder? openBuilder;

  @override
  Widget build(BuildContext context) {
    return _Hideable(
      key: hideableKey,
      child: GestureDetector(
        onTap: tappable ? openContainer : null,
        child: Builder(
          key: _closedBuilderKey,
          builder: (context) => closedBuilder!(context),
        ),
      ),
    );
  }

  void openContainer() {
    assert(context != null);
    var navigator = Navigator.of(context!, rootNavigator: true);
    navigator.push(_OpenModalAnimationRoute(
        width: width,
        height: height,
        closedBuilder: closedBuilder,
        openBuilder: openBuilder,
        hideableKey: hideableKey,
        navigatorContext: navigator.context,
        closedBuilderKey: _closedBuilderKey));
  }
}

class _Hideable extends StatefulWidget {
  const _Hideable({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  _HideableState createState() => _HideableState();
}

class _HideableState extends State<_Hideable> {
  Size? get placeholderSize => _placeholderSize;
  Size? _placeholderSize;

  set placeholderSize(Size? value) {
    if (_placeholderSize == value) {
      return;
    }
    setState(() {
      _placeholderSize = value;
    });
  }

  bool get isVisible => _visible;
  bool _visible = true;

  set isVisible(bool value) {
    if (_visible == value) {
      return;
    }
    setState(() {
      _visible = value;
    });
  }

  bool get isInTree => _placeholderSize == null;

  @override
  Widget build(BuildContext context) {
    if (_placeholderSize != null) {
      return SizedBox.fromSize(size: _placeholderSize);
    }
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: widget.child,
    );
  }
}

class _OpenModalAnimationRoute<T> extends ModalRoute<T> {
  _OpenModalAnimationRoute({
    required this.width,
    required this.height,
    required this.closedBuilder,
    required this.openBuilder,
    required this.hideableKey,
    required this.navigatorContext,
    required this.closedBuilderKey,
  });

  final double? width;
  final double? height;
  final WidgetBuilder? closedBuilder;
  final WidgetBuilder? openBuilder;
  final GlobalKey<_HideableState>? hideableKey;
  final GlobalKey? closedBuilderKey;
  final BuildContext? navigatorContext;

  final _rectTween = RectTween();

  void _takeMeasurements(bool delayForSourceRoute) {
    final RenderBox navigator = Navigator.of(
      navigatorContext!,
      rootNavigator: true,
    ).context.findRenderObject()! as RenderBox;

    _rectTween.end = Offset(32, navigator.size.height / 2 - height! / 2) &
        Size(navigator.size.width - 64, height!);

    void takeMeasurementsInSourceRoute([Duration? _]) {
      if (!navigator.attached || hideableKey!.currentContext == null) {
        return;
      }
      _rectTween.begin = _getRect(hideableKey!, navigator);

      hideableKey?.currentState?.isVisible = delayForSourceRoute;
    }

    if (delayForSourceRoute) {
      SchedulerBinding.instance
          .addPostFrameCallback(takeMeasurementsInSourceRoute);
    } else {
      takeMeasurementsInSourceRoute();
    }
  }

  Rect _getRect(GlobalKey key, RenderBox ancestor) {
    final RenderBox render =
        key.currentContext!.findRenderObject()! as RenderBox;
    return MatrixUtils.transformRect(
      render.getTransformTo(ancestor),
      Offset.zero & render.size,
    );
  }

  @override
  TickerFuture didPush() {
    _takeMeasurements(false);

    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    _takeMeasurements(true);
    return super.didPop(result);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped);

    // final closeOpacityTween = Tween(begin: 1.0, end: 0.0);
    final openOpacityTween = Tween(begin: 0.0, end: 1.0);

    return Align(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final rect = _rectTween.evaluate(curvedAnimation);
          return Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(rect!.left, rect.top),
              child: SizedBox(
                width: rect.width,
                height: rect.height,
                child: Opacity(
                  opacity: openOpacityTween.evaluate(animation),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        // FittedBox(
                        //   fit: BoxFit.fitWidth,
                        //   alignment: Alignment.topLeft,
                        //   child: Opacity(
                        //     opacity: closeOpacityTween.evaluate(animation),
                        //     child: SizedBox(
                        //       width: _rectTween.begin!.width,
                        //       height: _rectTween.begin!.height,
                        //       child: Builder(
                        //         key: closedBuilderKey,
                        //         builder: (context) => closedBuilder!(context),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        FittedBox(
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: _rectTween.end!.width,
                            height: _rectTween.end!.height,
                            child: Builder(
                              builder: (context) => openBuilder!(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Color? get barrierColor => Colors.black54.withOpacity(0.5);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
