import 'dart:io';
import 'dart:typed_data';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:uuid/uuid.dart';

class NewPlanDialog extends StatefulWidget {
  final Function(Plan plan) onNewPlan;
  const NewPlanDialog({
    Key? key,
    required this.onNewPlan,
  }) : super(key: key);

  @override
  State<NewPlanDialog> createState() => _NewPlanDialogState();
}

class _NewPlanDialogState extends State<NewPlanDialog> {
  Uint8List? selectedImageData;
  TextEditingController newPlanNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: appBackgroundAccentColor,
      title: Center(
        child: Text(
          "Create New Plan",
          style: defaultTextStyle.copyWith(fontSize: 25),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: newPlanNameController,
              style: textFieldStyle,
              decoration: defaultTextFieldDecoration.copyWith(hintText: "Plan Name"),
            ),
          ),
          TextButton(
            onPressed: () {
              final imageFile = OpenFilePicker()
                ..filterSpecification = {
                  'Image File': '*.png;*.jpg;*.jpeg;*.gif;*.webp;*.bmp',
                }
                ..defaultExtension = 'png'
                ..defaultFilterIndex = 0
                ..title = "Select an image";
              File? result = imageFile.getFile();
              if (result == null) return;

              setState(() {
                selectedImageData = result.readAsBytesSync();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pick Image",
                style: defaultTextStyle.copyWith(fontSize: 25),
              ),
            ),
          ),
          if (selectedImageData != null)
            SizedBox(
              width: 300,
              height: 200,
              child: Image.memory(selectedImageData!),
            ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () {
            if (newPlanNameController.text.isEmpty) return;
            if (selectedImageData == null) return;
            decodeImageFromList(selectedImageData!).then((image) {
              Uuid uuid = const Uuid();
              widget.onNewPlan(
                Plan(
                  name: newPlanNameController.text,
                  size: Size(image.width.toDouble(), image.height.toDouble()),
                  backgroundImage: selectedImageData,
                  createdAt: DateTime.now(),
                  lastUpdatedAt: DateTime.now(),
                  setElements: [],
                  setLayers: [],
                  uuid: uuid.v4(),
                ),
              );
              Navigator.pop(context);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Save",
              style: defaultTextStyle.copyWith(fontSize: 25),
            ),
          ),
          style: iconTextButtonStyle,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cancel",
              style: defaultTextStyle.copyWith(fontSize: 25),
            ),
          ),
          style: iconTextButtonStyle,
        ),
      ],
    );
  }
}
