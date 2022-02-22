import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math.dart';

class PointUtils {
  PointUtils._();

  static bool isPointInPolygon(Offset point, List<Offset> vertices) {
    var count = 0;

    for (var i = 0; i < vertices.length; i++) {
      var q = vertices[i];
      var r = vertices[(i + 1) % vertices.length];

      if (
          // 3点が上向き
          (q.dy <= point.dy) && (r.dy > point.dy)
              // 3点が下向き
              ||
              (q.dy > point.dy) && (r.dy <= point.dy)) {
        var intersectionX =
            q.dx + (point.dy - q.dy) * (r.dx - q.dx) / (r.dy - q.dy);
        if (point.dx < intersectionX) {
          count++;
        }
      }
    }

    return count % 2 == 1;
  }

  static bool isCircleTouchesToPolygon(
      Offset center, double radius, List<Offset> vertices) {
    for (var i = 0; i < vertices.length; i++) {
      if (isCircleTangentToLine(
          vertices[i], vertices[(i + 1) % vertices.length], center, radius)) {
        return true;
      }
    }
    return false;
  }

  static bool isCircleTangentToLine(
      Offset p, Offset q, Offset center, double radius) {
    var vpc = Vector2(p.dx, p.dy)..sub(Vector2(center.dx, center.dy));
    var vqc = Vector2(q.dx, q.dy)..sub(Vector2(center.dx, center.dy));
    var vpq = Vector2(p.dx, p.dy)..sub(Vector2(q.dx, q.dy));

    // 各端への距離が半径より小さい場合
    if (vpc.length < radius || vqc.length < radius) {
      return true;
    }

    // 線分上にある場合
    var dp = vpq.dot(vpc);
    var k = dp / pow(vpq.length, 2);
    if (k < 0 || k > 1) {
      return false;
    }

    return pow(vpc.length, 2) - pow(dp, 2) / pow(vpq.length, 2) <
        pow(radius, 2);
  }
}
