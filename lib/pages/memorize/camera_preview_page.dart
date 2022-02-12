import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:submon/utils/card_side_builder.dart';
import 'package:submon/utils/ui.dart';

import '../../main.dart';

class CameraPreviewPage extends StatefulWidget {
  const CameraPreviewPage({Key? key}) : super(key: key);

  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _controller;
  AnimationController? _animationController;
  CurvedAnimation? _animation;
  XFile? _file;
  bool _taking = false;
  CardSide _currentCardSide = CardSide.front;
  bool _pickingMode = false;
  bool _editMode = false;
  final _panelKey = GlobalKey();
  final _editingController = TextEditingController();
  final _builder = CardSideBuilder();

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    initCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: Tween(begin: 0.0, end: 1.0).animate(_animationController!),
      curve: Curves.easeOutQuint,
      reverseCurve: Curves.easeInQuint,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('カメラ入力'),
        ),
        body: const Center(
          child: Text('Please wait...'),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('カメラ入力'),
          actions: [
            IconButton(
                icon: const Icon(Icons.info),
                onPressed: showAboutTextRecognizing),
            if (_pickingMode && !_editMode)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _builder.clear(_currentCardSide);
                  });
                },
              )
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (_pickingMode) {
              setState(() {
                _pickingMode = false;
                _editMode = false;
                _taking = false;
                _controller?.resumePreview();
              });
              return false;
            }
            return true;
          },
          child: Stack(
            children: [
              CameraPreview(
                _controller!,
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
                offset: Offset(0, _pickingMode ? 0 : -1),
                child: IntrinsicHeight(
                  key: _panelKey,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: 400 - (100 + (_animation!.value * 100).toInt()),
                        child: _buildSideResultView(
                            CardSide.front, _builder.toStringFront()),
                      ),
                      Flexible(
                        flex: 100 + (_animation!.value * 400).toInt(),
                        child: _buildSideResultView(
                            CardSide.back, _builder.toStringBack()),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_pickingMode)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CameraTakeButton(
                      disabled: _taking,
                      onPressed: takeImage,
                    ),
                  ),
                )
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSideResultView(CardSide side, String sideText) {
    // view of text or text form field
    Widget buildResultView() {
      if (_editMode && side == _currentCardSide) {
        return TextFormField(
          controller: _editingController,
          autofocus: true,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            labelText: 'テキスト',
          ),
          onFieldSubmitted: (str) {
            setState(() {
              _builder.clear(side);
              _builder.append(side, WordFragment(str));
              _editingController.clear();
              _editMode = false;
            });
          },
        );
      } else {
        return Text(
          sideText == "" ? "なぞって選択" : sideText,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      }
    }

    // view of inside card
    Widget buildInCard() {
      if (_editMode && side != _currentCardSide) {
        return InkWell(
          onTap: () {
            setState(() {
              _builder.clear(_currentCardSide);
              _builder.append(
                  _currentCardSide, WordFragment(_editingController.text));
              _editingController.clear();
              _editMode = false;
            });
          },
          child: const Center(child: Icon(Icons.check, size: 28)),
        );
      } else {
        return InkWell(
          key: ValueKey(side),
          onTap: () {
            if (_currentCardSide != side) {
              setState(() {
                if (side == CardSide.front) {
                  _animationController!.reverse();
                  _currentCardSide = CardSide.front;
                } else {
                  _animationController!.forward();
                  _currentCardSide = CardSide.back;
                }
              });
            } else {
              setState(() {
                _editingController.text = sideText;
                _editMode = true;
              });
            }
          },
          child: Row(
            children: [
              Container(
                color:
                    side == CardSide.front ? Colors.lightBlue : Colors.orange,
                width: 6,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(side == CardSide.front ? "表" : "裏",
                        style: const TextStyle(fontSize: 16)),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: buildResultView(),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: side == _currentCardSide || _editMode ? 1.0 : 0.8,
      child: Card(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: buildInCard(),
        ),
      ),
    );
  }

  void takeImage() async {
    setState(() {
      _taking = true;
    });
    var timer = Timer(const Duration(seconds: 5), () async {
      showSnackBar(
          context,
          "撮影がタイムアウトしました。アプリを再起動し、再度お試しください。\n"
          "※これは認知済みのバグです。ライブラリ側の不具合のため、修正に時間を要します。",
          duration: const Duration(seconds: 8));
      await _controller!.dispose();
      setState(() {
        _controller = null;
        _taking = false;
      });
      initCamera();
    });
    try {
      _file = await _controller!.takePicture();
      _controller!.pausePreview();
      setState(() {
        _pickingMode = true;
      });
      recognizeText();
    } catch (e) {
      showSnackBar(context, "エラーが発生しました");
    } finally {
      timer.cancel();
      setState(() {
        _taking = false;
      });
    }
  }

  void recognizeText() async {
    var result = await FirebaseFunctions.instanceFor(region: "asia-northeast1")
        .httpsCallable("recognizeText")({});

    print(result.data);
  }

  void showAboutTextRecognizing() {
    showSimpleDialog(
        context,
        "プライバシーポリシー",
        "是非最後までお読みください。\n\n本機能では、Google LLC(以下「Google」) の提供する Cloud Vision API を利用してOCR(文字認識)を行っています。\n\n"
            "このAPIでは、画像をGoogleに送信することで、Googleのサーバーで画像処理をして認識された文字を取得しています。\n\n"
            "送信された画像はGoogleのサーバーのメモリ内でのみ処理され、処理後はすぐに削除されます。画像がGoogleサーバーに蓄積されることはありません。ご安心ください。\n\n"
            "また、本アプリで撮影した画像は上記の目的以外には使用しません。");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_controller != null && _controller!.value.isInitialized) {
      if (state == AppLifecycleState.inactive) {
        _controller!.dispose();
      } else if (state == AppLifecycleState.resumed) {
        initCamera();
      }
    }
  }

  void initCamera() async {
    _controller =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    await _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }
}

class CameraTakeButton extends StatefulWidget {
  const CameraTakeButton({Key? key, this.onPressed, this.disabled = false})
      : super(key: key);

  final void Function()? onPressed;
  final bool disabled;

  @override
  State<CameraTakeButton> createState() => _CameraTakeButtonState();
}

class _CameraTakeButtonState extends State<CameraTakeButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.disabled ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      child: GestureDetector(
        onTap: !widget.disabled
            ? () {
                widget.onPressed?.call();
                Feedback.forTap(context);
              }
            : null,
        child: SizedBox(
          width: 70,
          height: 70,
          child: CustomPaint(
            painter: CameraTakeButtonPainter(),
          ),
        ),
      ),
    );
  }
}

class CameraTakeButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
    paint.color = Colors.black;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), (size.width / 2) - 3, paint);
    paint.color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), (size.width / 2) - 6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum CardSide { front, back }
