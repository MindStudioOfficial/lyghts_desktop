import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Positionable extends StatelessWidget {
  final Widget child;
  Offset position;
  final Function(Offset position) onPosChanged;
  final bool movable;
  final bool zoomable;

  Positionable({
    Key? key,
    required this.child,
    required this.position,
    required this.onPosChanged,
    this.movable = false,
    this.zoomable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (movable) {
            position += details.delta;
            onPosChanged(position);
          }
        },
        child: child,
      ),
    );
  }
}
