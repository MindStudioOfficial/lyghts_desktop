import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:vector_math/vector_math.dart' as vm;

class CameraPainter extends CustomPainter {
  double angle;
  double focalLength;
  Color? color;
  bool fill;
  double crop;
  CameraPainter({required this.angle, this.focalLength = 35, this.color, this.crop = 1.5, this.fill = false});

  @override
  void paint(Canvas canvas, Size size) {
    double range = 300;
    double opening = vm.degrees(2 * atan(42 / (2 * focalLength)));

    final paint = Paint()
      ..color = color ?? setElementPaintColor
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(vm.radians(-angle - opening / 2));
    canvas.drawLine(const Offset(0, 0), Offset(range, 0), paint);
    canvas.rotate(vm.radians(opening));
    canvas.drawLine(const Offset(0, 0), Offset(range, 0), paint);
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
