import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class CustomTooltip extends StatelessWidget {
  final String text;
  final Widget child;
  const CustomTooltip(
    this.text, {
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: text,
      child: child,
      textStyle: toolTipTextStyle,
      decoration: toolTipDecoration,
    );
  }
}
