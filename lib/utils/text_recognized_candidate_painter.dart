import 'dart:math';

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

enum TripletOrientation {
  collinear,
  clockwise,
  counterClockwise,
}

bool _onSegment(Offset p, Offset q, Offset r) {
  if (q.dx <= max(p.dx, r.dx) &&
      q.dx >= min(p.dx, r.dx) &&
      q.dy <= max(p.dy, r.dy) &&
      q.dy >= min(p.dy, r.dy)) {
    return true;
  }
  return false;
}

TripletOrientation _orientation(Offset p, Offset q, Offset r) {
  double val = (q.dy - p.dy) * (r.dx - q.dx) - (q.dx - p.dx) * (r.dy - q.dy);
  if (val == 0) {
    return TripletOrientation.collinear;
  }
  return val > 0
      ? TripletOrientation.clockwise
      : TripletOrientation.counterClockwise;
}

bool doIntersect(Offset p1, Offset q1, Offset p2, Offset q2) {
  TripletOrientation o1 = _orientation(p1, q1, p2);
  TripletOrientation o2 = _orientation(p1, q1, q2);
  TripletOrientation o3 = _orientation(p2, q2, p1);
  TripletOrientation o4 = _orientation(p2, q2, q1);

  if (o1 != o2 && o3 != o4) {
    return true;
  }

  if (o1 == TripletOrientation.collinear && _onSegment(p1, p2, q1)) {
    return true;
  }

  if (o2 == TripletOrientation.collinear && _onSegment(p1, q2, q1)) {
    return true;
  }

  if (o3 == TripletOrientation.collinear && _onSegment(p2, p1, q2)) {
    return true;
  }

  if (o4 == TripletOrientation.collinear && _onSegment(p2, q1, q2)) {
    return true;
  }

  return false;
}

bool isInsideQuadrangle(List<Offset> vertices, Offset p) {
  var extreme = Offset(10000.0, p.dy);

  var count = 0;
  var i = 0;

  do {
    var next = (i + 1) % 4;
    if (doIntersect(vertices[i], vertices[next], p, extreme)) {
      if (_orientation(vertices[i], p, vertices[next]) ==
          TripletOrientation.collinear) {
        return _onSegment(vertices[i], p, vertices[next]);
      }
      count++;
    }

    i = next;
  } while (i != 0);

  return count % 2 == 1;
}
