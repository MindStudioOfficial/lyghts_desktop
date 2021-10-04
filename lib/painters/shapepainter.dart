import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:vector_math/vector_math.dart' as vm;

class ShapePainter extends CustomPainter {
  double angle;
  Color? outline;
  Color? fill;
  Size shapeSize;
  ShapeType type;
  ShapePainter({
    required this.angle,
    required this.shapeSize,
    required this.type,
    this.fill = Colors.red,
    this.outline = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = outline ?? setElementShapeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fillPaint = Paint()
      ..color = fill ?? setElementShapeColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(vm.radians(-angle));
    switch (type) {
      case ShapeType.circle:
        canvas.drawCircle(Offset.zero, shapeSize.width / 2, fillPaint);
        canvas.drawCircle(Offset.zero, shapeSize.width / 2, outlinePaint);
        break;
      case ShapeType.rectangle:
        canvas.drawRect(
            Rect.fromLTWH(-shapeSize.width / 2, -shapeSize.height / 2, shapeSize.width, shapeSize.height), fillPaint);
        canvas.drawRect(Rect.fromLTWH(-shapeSize.width / 2, -shapeSize.height / 2, shapeSize.width, shapeSize.height),
            outlinePaint);
        break;
      case ShapeType.square:
        canvas.drawRect(
            Rect.fromLTWH(-shapeSize.width / 2, -shapeSize.width / 2, shapeSize.width, shapeSize.width), fillPaint);
        canvas.drawRect(
            Rect.fromLTWH(-shapeSize.width / 2, -shapeSize.width / 2, shapeSize.width, shapeSize.width), outlinePaint);
        break;
      default:
        break;
    }
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
