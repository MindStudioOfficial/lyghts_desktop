import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';
import 'package:vector_math/vector_math.dart' as vm;

class LightPainter extends CustomPainter {
  double angle;
  double opening;
  double range;
  Color? color;
  bool fill;
  LightPainter({required this.angle, required this.opening, required this.range, this.color, this.fill = false});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? setElementPaintColor
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();

    canvas.translate(size.width / 2, size.height / 2);

    path.moveTo(0, 0);

    path.lineTo(range * cos(vm.radians(-angle - opening / 2)), range * sin(vm.radians(-angle - opening / 2)));
    final startAngle = vm.radians(-angle - opening / 2);
    final sweepAngle = vm.radians(opening);
    final rect = Rect.fromCircle(center: Offset.zero, radius: range);
    path.arcTo(rect, startAngle, sweepAngle, false);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) {
    return false;
  }
}
