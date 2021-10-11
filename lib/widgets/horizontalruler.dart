import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class HorizontalRuler extends StatefulWidget {
  final BoxConstraints constraints;
  final Offset canvasPos;
  final double canvasScale;
  final Size canvasSize;
  const HorizontalRuler({
    Key? key,
    required this.constraints,
    required this.canvasPos,
    required this.canvasScale,
    required this.canvasSize,
  }) : super(key: key);

  @override
  _HorizontalRulerState createState() => _HorizontalRulerState();
}

class _HorizontalRulerState extends State<HorizontalRuler> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.constraints.maxWidth,
      height: 30,
      color: rulerBackgroundColor,
      child: CustomPaint(
        size: Size(widget.constraints.maxWidth, 30),
        painter: RulerPainter(
          canvasPos: widget.canvasPos,
          canvasScale: widget.canvasScale,
          canvasSize: widget.canvasSize,
          constraints: widget.constraints,
        ),
      ),
    );
  }
}

class RulerPainter extends CustomPainter {
  Offset canvasPos;
  double canvasScale;
  Size canvasSize;
  BoxConstraints constraints;

  RulerPainter({
    required this.canvasPos,
    required this.canvasScale,
    required this.canvasSize,
    required this.constraints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(canvasPos.dx + 1000 + (canvasSize.width / 2), 0);
    canvas.scale(canvasScale, 1);
    Paint p = Paint()..color = rulerColor;
    Paint ap = Paint()..color = rulerColor.withOpacity(.5);

    for (int i = -(canvasSize.width / 2).round(); i <= canvasSize.width / 2; i++) {
      int j = i + (canvasSize.width / 2).round();
      if (j % 10 == 0) {
        canvas.drawLine(
          Offset(i.toDouble(), 5),
          Offset(i.toDouble(), size.height - (j % 100 == 0 ? 10 : 15)),
          j % 100 == 0 ? ap : p,
        );
        if (j % (canvasScale < .3 ? (canvasScale < 0.13 ? 500 : 200) : 100) == 0) {
          ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
            fontSize: 12.5,
            maxLines: 1,
            textAlign: TextAlign.left,
          ))
            ..pushStyle(ui.TextStyle(
              color: rulerColor,
              fontSize: 12.5,
            ))
            ..addText(j.toString());
          ui.Paragraph textParagraph = pb.build();
          textParagraph.layout(const ui.ParagraphConstraints(width: 100));
          canvas.scale(1 / canvasScale, 1);
          canvas.drawParagraph(textParagraph, Offset(i.toDouble() * canvasScale, size.height - 15));
          canvas.scale(canvasScale, 1);
        }
      } else {
        canvas.drawLine(
          Offset(i.toDouble(), 5),
          Offset(i.toDouble(), size.height - 22.5),
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
