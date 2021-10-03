import 'package:flutter/material.dart';
import 'package:lomp_desktop/config.dart';
import 'package:lomp_desktop/models.dart';

class WaterMarc extends StatelessWidget {
  final Alignment alignment;
  const WaterMarc({Key? key, required this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SizedBox(
          child: Text(
            appTitle,
            style: waterMarcTextStyle,
          ),
        ),
      ),
    );
  }
}
