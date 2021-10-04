import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class ResetTransformButton extends StatelessWidget {
  final Function() onPressed;
  const ResetTransformButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appOverlayColor,
      child: IconButton(
        icon: const Icon(
          Icons.zoom_out_map_sharp,
          size: 25,
          color: Colors.white,
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
