import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:screenshot/screenshot.dart';
import 'package:lyghts_desktop/utils.dart';

class ExportPage extends StatefulWidget {
  final ScreenshotController screenshotController;
  final Plan? selectedPlan;
  const ExportPage({
    Key? key,
    required this.screenshotController,
    required this.selectedPlan,
  }) : super(key: key);

  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  Size imageSize = const Size(0, 0);

  List<int>? imageData;

  Future<Image> captureCanvas() async {
    Image i;

    Uint8List? imageBytes = await widget.screenshotController.capture(
      pixelRatio: 2,
      delay: const Duration(milliseconds: 10),
    );

    var decodedImage = await decodeImageFromList(imageBytes!);

    imageSize = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    i = Image.memory(imageBytes);
    imageData = imageBytes;
    return i;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedPlan != null) {
      return FutureBuilder<Image>(
        future: captureCanvas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(child: snapshot.data!),
                if (imageData != null && widget.selectedPlan != null)
                  ExportBar(imageData: imageData!, imageSize: imageSize, planName: widget.selectedPlan!.name),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: selectedIconColor,
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "No Plan Selected",
          style: waterMarcTextStyle,
        ),
      );
    }
  }
}

class ExportBar extends StatefulWidget {
  final List<int> imageData;
  final Size imageSize;
  final String planName;
  const ExportBar({Key? key, required this.imageData, required this.imageSize, required this.planName})
      : super(key: key);

  @override
  _ExportBarState createState() => _ExportBarState();
}

class _ExportBarState extends State<ExportBar> {
  ExportFormats exportFormat = ExportFormats.png;
  bool exporting = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${widget.imageSize.width.toInt()} × ${widget.imageSize.height.toInt()}",
            style: defaultTextStyle,
          ),
        ),
        const Spacer(),
        DropdownButton<ExportFormats>(
          value: exportFormat,
          icon: const Icon(Icons.expand_more_sharp),
          iconSize: 24,
          iconEnabledColor: selectedIconColor,
          iconDisabledColor: defaultIconColor,
          dropdownColor: appBackgroundAccentColor,
          items: <ExportFormats>[ExportFormats.png, ExportFormats.pdf]
              .map<DropdownMenuItem<ExportFormats>>((ExportFormats value) {
            return DropdownMenuItem<ExportFormats>(
              value: value,
              child: Text(
                value.toString().split(".").last.toUpperCase(),
                style: defaultTextStyle.copyWith(fontSize: 25),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              exportFormat = value ?? ExportFormats.png;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () async {
              setState(() {
                exporting = true;
              });
              switch (exportFormat) {
                case ExportFormats.png:
                  exportAsPng(widget.imageData, widget.planName).then((value) {
                    setState(() {
                      exporting = false;
                    });
                  });
                  break;
                case ExportFormats.pdf:
                  exportAsPdf(widget.imageData, widget.planName, widget.imageSize).then((value) {
                    setState(() {
                      exporting = false;
                    });
                  });
                  break;
              }
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
        ),
      ],
    );
  }
}
