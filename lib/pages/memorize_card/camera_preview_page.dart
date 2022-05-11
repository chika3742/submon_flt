import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:submon/db/memorize_card.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/method_channel/main.dart';
import 'package:submon/utils/card_side_builder.dart';
import 'package:submon/utils/point.dart';
import 'package:submon/utils/text_recognized_candidate_painter.dart';
import 'package:submon/utils/ui.dart';

import '../../main.dart';

const policyDialogTitle = "プライバシーポリシー";
const policyDialogContent = "是非最後までお読みください。\n\n"
    "本機能では、Google LLC(以下「Google」) の提供する Cloud Vision API を利用してOCR(文字認識)を行っています。\n"
    "このAPIでは、画像をGoogleに送信することで、Googleのサーバーで画像処理をして認識された文字を取得しています。\n\n"
    "送信された画像はGoogleのサーバーのメモリ内でのみ処理され、処理後はすぐに削除されます。"
    "画像がGoogleサーバーに蓄積されることはなく、文字認識等のトレーニングに利用されることもありません。ご安心ください。\n\n"
    "また、本アプリで撮影した画像は上記の目的以外には使用しません。";
const tempImgDirName = "tempImg";

class CameraPreviewPage extends StatefulWidget {
  CameraPreviewPage({Key? key, required dynamic arguments})
      : folderId = arguments["folderId"],
        super(key: key);

  final int folderId;

  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? _controller;
  AnimationController? _switchAnimationController;
  Animation<int>? _switchAnimation;
  AnimationController? _radarAnimationController;
  Animation<RelativeRect>? _radarAnimation;
  AnimationController? _focusAnimationController;
  ui.Image? _image;
  String? _imagePath;
  List<TextElement>? _recognizingResult;
  bool _taking = false;
  bool _recognizingText = false;
  CardSide _currentCardSide = CardSide.front;
  bool _isPickingMode = false;
  bool _hideResultPanel = false;
  bool _isEditMode = false;
  bool _autoInsertSpace = false;
  Offset _focusPoint = Offset.zero;
  bool _isFocusing = false;
  Timer? _focusTimer;
  FlashMode _flashMode = FlashMode.auto;

  final _panelKey = GlobalKey();
  final _cameraPreviewKey = GlobalKey();
  final _imageKey = GlobalKey();
  final _editingController = TextEditingController();
  final _builder = CardSideBuilder();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _switchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _switchAnimation = IntTween(begin: 100, end: 300).animate(CurvedAnimation(
      parent: _switchAnimationController!,
      curve: Curves.easeOutQuint,
      reverseCurve: Curves.easeInQuint,
    ))
      ..addListener(() {
        setState(() {});
      });

    _radarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _focusAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // deviceCameraUIShouldBeUsed
    _checkShouldTakePictureNative();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    if (_imagePath != null) {
      File(_imagePath!).delete();
      _imagePath = null;
    }
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    var begin =
        RelativeRect.fromLTRB(-4, 0, MediaQuery.of(context).size.width, 0);
    var end =
        RelativeRect.fromLTRB(MediaQuery.of(context).size.width, 0, -4, 0);
    _radarAnimation ??= TweenSequence([
      TweenSequenceItem(
          tween: RelativeRectTween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeOutSine)),
          weight: 1),
      TweenSequenceItem(tween: ConstantTween(end), weight: 0.5),
      TweenSequenceItem(
          tween: RelativeRectTween(begin: end, end: begin)
              .chain(CurveTween(curve: Curves.easeOutSine)),
          weight: 1),
      TweenSequenceItem(tween: ConstantTween(begin), weight: 0.5),
    ]).animate(_radarAnimationController!);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('カメラ入力'),
        actions: [
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: showAboutTextRecognizing),
          if (!_isPickingMode)
            IconButton(
              icon: Icon(getFlashIcon()),
              onPressed: () {
                setState(() {
                  _flashMode = getNextFlashMode();
                  _controller?.setFlashMode(_flashMode);
                });
              },
            ),
          if (_isPickingMode && !_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _builder.get(_currentCardSide).isNotEmpty
                  ? () {
                      setState(() {
                        _builder.clear(_currentCardSide);
                      });
                    }
                  : null,
            ),
          if (_isPickingMode && !_isEditMode)
            PopupMenuButton(
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: ListTile(
                      title: const Text("単語の後にスペースを挿入"),
                      trailing: Checkbox(
                        value: _autoInsertSpace,
                        onChanged: (v) {
                          setState(() {
                            _autoInsertSpace = !_autoInsertSpace;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      title: Text("スペースを挿入"),
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    setState(() {
                      _autoInsertSpace = !_autoInsertSpace;
                    });
                    break;
                  case 1:
                    setState(() {
                      _builder.append(_currentCardSide, TextElement(" "));
                    });
                    break;
                }
              },
            ),
        ],
      ),
      floatingActionButton: _isPickingMode && !_hideResultPanel
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.check),
              label: const Text('作成'),
              onPressed: _builder.toStringFront() != "" &&
                      _builder.toStringBack() != ""
                  ? () {
                      MemorizeCardProvider().use((provider) async {
                        await provider.insert(MemorizeCard(
                          front: _builder.toStringFront(),
                          back: _builder.toStringBack(),
                          folderId: widget.folderId,
                        ));
                        setState(() {
                          _builder.clearAll();
                          _switchAnimationController!.reverse();
                          _currentCardSide = CardSide.front;
                        });
                        showSnackBar(context, "作成しました。");
                      });
                    }
                  : null,
            )
          : null,
      body: WillPopScope(
        onWillPop: () async {
          if (_isEditMode) {
            setState(() {
              _isEditMode = false;
            });
            return false;
          }
          if (_isPickingMode) {
            back();
            return false;
          }
          return true;
        },
        child: Stack(
          children: [
            SizedBox.expand(
              child: Container(
                color: Colors.black,
              ),
            ),

            // Preview
            if (_controller != null && _controller!.value.isInitialized)
              GestureDetector(
                key: _cameraPreviewKey,
                onTapUp: (details) async {
                  _focusTimer?.cancel();

                  var size = _cameraPreviewKey.currentContext!.size!;
                  _controller?.setFocusMode(FocusMode.locked);
                  _controller?.setFocusPoint(details.localPosition
                      .scale(1 / size.width, 1 / size.height));

                  _focusTimer = Timer(const Duration(seconds: 5), () {
                    _controller?.setFocusMode(FocusMode.auto);
                  });

                  setState(() {
                    _isFocusing = true;
                    _focusPoint = details.localPosition;
                  });
                  await _focusAnimationController?.forward();
                  _focusAnimationController?.reset();
                  setState(() {
                    _isFocusing = false;
                  });
                },
                child: CameraPreview(
                  _controller!,
                ),
              ),

            // focus indicator
            if (_isFocusing)
              Positioned(
                left: _focusPoint.dx - 20,
                top: _focusPoint.dy - 20,
                child: ScaleTransition(
                  scale: TweenSequence([
                    TweenSequenceItem(
                        tween: Tween(begin: 1.5, end: 1.0)
                            .chain(CurveTween(curve: Curves.easeOutQuint)),
                        weight: 1),
                    TweenSequenceItem(tween: ConstantTween(1.0), weight: 1),
                  ]).animate(_focusAnimationController!),
                  child: FadeTransition(
                    opacity: TweenSequence([
                      TweenSequenceItem(
                          tween: Tween(begin: 0.0, end: 1.0), weight: 1.0),
                      TweenSequenceItem(tween: ConstantTween(1.0), weight: 2.0),
                      TweenSequenceItem(
                          tween: Tween(begin: 1.0, end: 0.0), weight: 1.0),
                    ]).animate(_focusAnimationController!),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),

            // image preview
            if (_image != null && _imagePath != null)
              SizedBox.expand(
                child: GestureDetector(
                  onPanUpdate: (details) => onSelectText(details.localPosition),
                  onTapDown: (details) {
                    onSelectText(details.localPosition);
                    setState(() {
                      _hideResultPanel = true;
                    });
                  },
                  onPanStart: (details) => setState(() {
                    _hideResultPanel = true;
                  }),
                  onPanEnd: (e) {
                    setState(() {
                      _hideResultPanel = false;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      _hideResultPanel = false;
                    });
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(_imagePath!),
                          key: _imageKey, alignment: Alignment.topCenter),
                      CustomPaint(
                        painter: TextRecognizedCandidatePainter(
                            _recognizingResult,
                            Size(_image!.width.toDouble(),
                                _image!.height.toDouble()),
                            _currentCardSide == CardSide.front
                                ? _builder.front
                                : _builder.back),
                        isComplex: true,
                      ),
                    ],
                  ),
                ),
              ),

            // result panel
            AnimatedSlide(
              key: const ValueKey(0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuint,
              offset: Offset(
                  0,
                  (_isPickingMode && !_hideResultPanel) || _isEditMode
                      ? 0
                      : -1),
              child: IntrinsicHeight(
                key: _panelKey,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 400 - _switchAnimation!.value,
                      child: _buildSideResultView(
                          CardSide.front, _builder.toStringFront()),
                    ),
                    Flexible(
                      flex: _switchAnimation!.value,
                      child: _buildSideResultView(
                          CardSide.back, _builder.toStringBack()),
                    ),
                  ],
                ),
              ),
            ),

            // loading display
            SizedBox.expand(
              child: IgnorePointer(
                ignoring: !_recognizingText,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuint,
                  opacity: _recognizingText ? 1 : 0,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                      PositionedTransition(
                        rect: _radarAnimation!,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                      const Center(
                        child: Text('テキストを探しています…',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // take picture button
            if (!_isPickingMode &&
                _controller != null &&
                _controller!.value.isInitialized)
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

  Widget _buildSideResultView(CardSide side, String sideText) {
    // view of text or text form field
    Widget buildResultView() {
      if (_isEditMode && side == _currentCardSide) {
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
              _builder.append(side, TextElement(str));
              _editingController.clear();
              _isEditMode = false;
            });
          },
        );
      } else {
        return Text(
          sideText == "" ? "なぞって選択" : sideText,
          style: TextStyle(
              fontSize: 22,
              fontWeight: sideText != "" ? FontWeight.bold : FontWeight.normal),
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      }
    }

    // view of inside card
    Widget buildInCard() {
      if (_isEditMode && side != _currentCardSide) {
        return InkWell(
          onTap: () {
            setState(() {
              _builder.clear(_currentCardSide);
              _builder.append(
                  _currentCardSide, TextElement(_editingController.text));
              _editingController.clear();
              _isEditMode = false;
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
                  _switchAnimationController!.reverse();
                  _currentCardSide = CardSide.front;
                } else {
                  _switchAnimationController!.forward();
                  _currentCardSide = CardSide.back;
                }
              });
            } else {
              setState(() {
                _editingController.text = sideText;
                _isEditMode = true;
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
      opacity: side == _currentCardSide || _isEditMode ? 1.0 : 0.8,
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
    var timer = Timer(const Duration(seconds: 10), () async {
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
      var imageFile = await _controller!.takePicture();
      setState(() {
        _isPickingMode = true;
      });
      recognizeText(imageFile);
    } catch (e) {
      showSnackBar(context, "エラーが発生しました");
    } finally {
      timer.cancel();
      setState(() {
        _taking = false;
      });
    }
  }

  void _checkShouldTakePictureNative() async {
    SharedPrefs.use((prefs) async {
      if (prefs.isDeviceCameraUIShouldBeUsed) {
        var result = await takePictureNative();
        if (result != null) {
          setState(() {
            _isPickingMode = true;
          });
          recognizeText(XFile(result));
        } else {
          Navigator.pop(context);
        }
      } else {
        initCamera();
      }
    });
  }

  void recognizeText(XFile imageFile) async {
    setState(() {
      _recognizingText = true;
    });
    _radarAnimationController?.repeat();

    var tempDirPath =
        p.join((await getTemporaryDirectory()).path, tempImgDirName);
    await Directory(tempDirPath).create(recursive: true);
    var newPath = (await File(imageFile.path)
            .rename(p.join(tempDirPath, p.basename(imageFile.path))))
        .path;

    setState(() {
      _imagePath = newPath;
    });

    var newFile = await FlutterExifRotation.rotateImage(path: newPath);
    var imageBytes = await newFile.readAsBytes();

    var decodedImage = await decodeImageFromList(imageBytes);

    setState(() {
      _image = decodedImage;
    });

    var functions = FirebaseFunctions.instanceFor(region: "asia-northeast1");

    try {
      var result = await functions.httpsCallable("recognizeText")({
        "image": {
          "content": base64Encode(imageBytes),
        },
        "features": [
          {
            "type": "DOCUMENT_TEXT_DETECTION",
          }
        ],
        "imageContext": {
          "languageHints": ["ja", "en"],
        }
      });

      setState(() {
        _recognizingResult = (result.data as List<dynamic>)
            .map((e) => TextElement.fromMap(Map.from(e)))
            .toList();

        if (_recognizingResult!.isEmpty) {
          showSimpleDialog(context, "エラー", "テキストが見つかりませんでした。",
              allowCancel: false, onOKPressed: () {
            back();
          });
        }
      });
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showSimpleDialog(
        context,
        "エラー",
        "テキスト認識に失敗しました。\n\n${e.toString()}",
        okText: "再試行",
        showCancel: true,
        onOKPressed: () {
          recognizeText(imageFile);
        },
        onCancelPressed: () {
          Navigator.pop(context);
        },
      );
    } finally {
      setState(() {
        _recognizingText = false;
      });
      Timer(const Duration(milliseconds: 300), () {
        _radarAnimationController!.reset();
      });
    }
  }

  void onSelectText(Offset pos) {
    for (var element in _recognizingResult!) {
      var scale = _image!.width / _imageKey.currentContext!.size!.width;
      if (PointUtils.isCircleTouchesToPolygon(
          pos.scale(scale, scale), 15, element.vertices!)) {
        setState(() {
          if (!_builder.get(_currentCardSide).contains(element)) {
            _builder.append(_currentCardSide, element);
            if (_autoInsertSpace) {
              _builder.append(_currentCardSide, TextElement(" "));
            }
          }
        });
      }
    }
  }

  void back() {
    if (_imagePath != null) {
      File(_imagePath!).delete();
      _imagePath = null;
    }
    setState(() {
      _isPickingMode = false;
      _isEditMode = false;
      _taking = false;
      _image = null;
      _recognizingResult = null;
      _builder.clearAll();
      _currentCardSide = CardSide.front;
    });
    _switchAnimationController?.reset();

    _checkShouldTakePictureNative();
  }

  void showAboutTextRecognizing() async {
    showSimpleDialog(
      context,
      policyDialogTitle,
      policyDialogContent,
    );
  }

  void initCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.veryHigh,
        enableAudio: false);
    await _controller!.initialize();
    await _controller!.setFlashMode(_flashMode);
    _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
    if (mounted) {
      setState(() {});
    }
  }

  IconData getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flash_on;
    }
  }

  FlashMode getNextFlashMode() {
    switch (_flashMode) {
      case FlashMode.off:
        return FlashMode.auto;
      case FlashMode.auto:
        return FlashMode.always;
      case FlashMode.always:
        return FlashMode.off;
      case FlashMode.torch:
        return FlashMode.off;
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
