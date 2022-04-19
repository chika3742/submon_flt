import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({Key? key, required this.initialColor})
      : super(key: key);

  final Color initialColor;

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  static final colors = [
    Colors.white,
    Colors.pink,
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
  ];
  Color selectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("カラーの選択"),
      content: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: _colorsToPaints(),
      ),
      actions: [
        TextButton(
          child: const Text("キャンセル"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context, selectedColor);
          },
        ),
      ],
    );
  }

  List<Widget> _colorsToPaints() => colors.map((e) {
        return GestureDetector(
          child: AnimatedContainer(
            curve: Curves.easeOutQuint,
            duration: const Duration(milliseconds: 300),
            transform: Transform.scale(
              scale: selectedColor.value == e.value ? 1.3 : 1.0,
            ).transform,
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x99000000),
                      blurRadius: selectedColor.value == e.value ? 4 : 1)
                ]),
            child: Stack(
              children: [
                CustomPaint(
                  painter: _ColorPainter(e),
                  size: const Size(30, 30),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Visibility(
                    visible: selectedColor.value == e.value,
                    child: Icon(
                      Icons.check,
                      color: e.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Feedback.forTap(context);
            setState(() {
              selectedColor = e;
            });
          },
        );
      }).toList();
}

class _ColorPainter extends CustomPainter {
  _ColorPainter(this.color);

  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var outlinePaint = Paint()
      ..isAntiAlias = true
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    var innerPaint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(15, 15), 15, innerPaint);
    canvas.drawCircle(const Offset(15, 15), 15, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
