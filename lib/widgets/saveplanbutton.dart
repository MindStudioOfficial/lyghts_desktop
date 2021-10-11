import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class SavePlanButton extends StatelessWidget {
  final Function() onPressed;
  final bool unsaved;
  const SavePlanButton({Key? key, required this.onPressed, required this.unsaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: Stack(
        children: [
          Center(
            child: Container(
              color: appOverlayColor,
              child: IconButton(
                icon: const Icon(
                  Icons.save_sharp,
                  size: 25,
                  color: Colors.white,
                ),
                onPressed: () {
                  onPressed();
                },
              ),
            ),
          ),
          if (unsaved)
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.circle_sharp,
                color: unsavedChangesColor,
                size: 10,
              ),
            ),
        ],
      ),
    );
  }
}
