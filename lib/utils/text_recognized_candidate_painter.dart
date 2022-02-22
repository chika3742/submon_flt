import 'package:flutter/material.dart';

class TextRecognizedCandidatePainter extends CustomPainter {
  TextRecognizedCandidatePainter(
      this.elements, this.imageSize, this.selectedElements);

  final List<TextElement>? elements;
  final Size imageSize;
  final Set<TextElement> selectedElements;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (elements != null) {
      var path1 = Path();
      var path2 = Path();

      var unselectedElements =
          elements!.where((element) => !selectedElements.contains(element));

      for (var element in unselectedElements) {
        var vertices = element.vertices!
            .map((e) => e.scale(size.width / imageSize.width,
                (size.width * (16 / 9)) / imageSize.height))
            .toList();
        path1.moveTo(vertices[0].dx, vertices[0].dy);
        for (int i = 1; i < vertices.length; i++) {
          path1.lineTo(vertices[i].dx, vertices[i].dy);
        }
        path1.lineTo(vertices[0].dx, vertices[0].dy);
      }

      for (var element in selectedElements) {
        if (element.vertices == null) continue;
        var vertices = element.vertices!
            .map((e) => e.scale(size.width / imageSize.width,
                (size.width * (16 / 9)) / imageSize.height))
            .toList();
        path2.moveTo(vertices[0].dx, vertices[0].dy);
        for (int i = 1; i < vertices.length; i++) {
          path2.lineTo(vertices[i].dx, vertices[i].dy);
        }
        path2.lineTo(vertices[0].dx, vertices[0].dy);
      }

      paint.color = Colors.green;
      canvas.drawPath(path1, paint);
      paint.color = Colors.orange;
      canvas.drawPath(path2, paint);
    }
  }

  @override
  bool shouldRepaint(TextRecognizedCandidatePainter oldDelegate) {
    return oldDelegate.elements != elements;
  }
}

class TextElement {
  String text;
  List<Offset>? vertices;

  TextElement(this.text, {this.vertices});

  static TextElement fromMap(Map<String, dynamic> map) {
    var vertices = (map["vertices"] as List).map((v) {
      var map = Map.from(v);
      return Offset((map["x"] as int).toDouble(), (map["y"] as int).toDouble());
    }).toList();
    return TextElement(map["text"], vertices: vertices);
  }

  static TextElement space() {
    return TextElement(" ");
  }

  @override
  String toString() {
    return "text: $text , vertices: $vertices";
  }
}