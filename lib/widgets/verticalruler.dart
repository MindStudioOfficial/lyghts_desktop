import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class VerticalRuler extends StatefulWidget {
  final BoxConstraints constraints;
  final Offset canvasPos;
  final double canvasScale;
  final Size canvasSize;
  const VerticalRuler({
    Key? key,
    required this.constraints,
    required this.canvasPos,
    required this.canvasScale,
    required this.canvasSize,
  }) : super(key: key);

  @override
  _VerticalRulerState createState() => _VerticalRulerState();
}

class _VerticalRulerState extends State<VerticalRuler> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 300,
      top: 0,
      child: Container(
        width: 40,
        height: widget.constraints.maxHeight - 30,
        color: rulerBackgroundColor,
        child: CustomPaint(
          size: Size(40, widget.constraints.maxHeight - 30),
          painter: VRulerPainter(
            canvasPos: widget.canvasPos,
            canvasScale: widget.canvasScale,
            canvasSize: widget.canvasSize,
            constraints: widget.constraints,
          ),
        ),
      ),
    );
  }
}

class VRulerPainter extends CustomPainter {
  Offset canvasPos;
  double canvasScale;
  Size canvasSize;
  BoxConstraints constraints;

  VRulerPainter({
    required this.canvasPos,
    required this.canvasScale,
    required this.canvasSize,
    required this.constraints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, canvasPos.dy + 1000 + (canvasSize.height / 2));
    canvas.scale(1, canvasScale);
    Paint p = Paint()..color = rulerColor;
    Paint ap = Paint()
      ..color = rulerColor
      ..strokeWidth = 2;

    for (int i = -(canvasSize.height / 2).round(); i <= canvasSize.height / 2; i++) {
      int j = i + (canvasSize.height / 2).round();
      if (j % 10 == 0) {
        canvas.drawLine(
          Offset(5, i.toDouble()),
          Offset(size.width - (j % 100 == 0 ? 20 : 25), i.toDouble()),
          j % 100 == 0 ? ap : p,
        );
        if (j % (canvasScale < .3 ? (canvasScale < 0.13 ? 500 : 200) : 100) == 0) {
          ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
            fontSize: 12.5,
            maxLines: 5,
            textAlign: TextAlign.left,
          ))
            ..pushStyle(ui.TextStyle(
              color: rulerColor,
              fontSize: 12.5,
            ))
            ..addText(j.toString());
          ui.Paragraph textParagraph = pb.build();
          textParagraph.layout(const ui.ParagraphConstraints(width: 14));
          canvas.scale(1, 1 / canvasScale);
          canvas.drawParagraph(textParagraph, Offset(size.width - 15, i.toDouble() * canvasScale));
          canvas.scale(1, canvasScale);
        }
      } else {
        canvas.drawLine(
          Offset(5, i.toDouble()),
          Offset(size.width - 32.5, i.toDouble()),
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
