import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:submon/utils/ui.dart';

import '../../main.dart';

class CameraPreviewPage extends StatefulWidget {
  const CameraPreviewPage({Key? key}) : super(key: key);

  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  XFile? _file;
  bool taking = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    initCamera();
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
        appBar: AppBar(
          title: const Text('カメラ入力'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  height: _file != null ? 80 : 0,
                  duration: const Duration(milliseconds: 300),
                ),
                Flexible(
                  child: CameraPreview(
                    _controller!,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: _file == null,
                  child: CameraTakeButton(
                    disabled: taking,
                    onPressed: () async {
                      setState(() {
                        taking = true;
                      });
                      var timer = Timer(const Duration(seconds: 5), () async {
                        showSnackBar(
                            context,
                            "撮影がタイムアウトしました。再度お試しください。\n"
                            "※これは認知済みのバグです。ライブラリ側の不具合のため、修正に時間を要します。",
                            duration: const Duration(seconds: 8));
                        await _controller!.dispose();
                        setState(() {
                          _controller = null;
                          taking = false;
                        });
                        initCamera();
                      });
                      try {
                        _file = await _controller!.takePicture();
                      } catch (e) {
                        showSnackBar(context, "エラーが発生しました");
                      }

                      timer.cancel();
                      setState(() {
                        taking = false;
                      });
                      _controller!.pausePreview();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
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
  var hovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: hovered || widget.disabled ? 0.5 : 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            hovered = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            hovered = false;
          });
        },
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
