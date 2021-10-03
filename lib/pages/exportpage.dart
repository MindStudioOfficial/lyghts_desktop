import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:lomp_desktop/utils.dart';

class ExportPage extends StatefulWidget {
  final ScreenshotController screenshotController;
  final Plan? selectedPlan;
  const ExportPage({Key? key, required this.screenshotController, required this.selectedPlan}) : super(key: key);

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
    return FutureBuilder<Image>(
      future: captureCanvas(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Expanded(child: snapshot.data!),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${imageSize.width.toInt()} × ${imageSize.height.toInt()}",
                      style: defaultTextStyle,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        getDownloadsDirectory().then((imageDir) {
                          String path = imageDir?.path ?? "";
                          if (widget.selectedPlan != null) {
                            File imageFile = File(
                                '$path/${DateTime.now().toDateTimeShortString()}_${widget.selectedPlan!.name.toLowerCase().replaceAll("  ", " ").replaceAll(" ", "_")}.png');
                            int i = 1;
                            while (imageFile.existsSync()) {
                              imageFile = File(
                                  '$path/${DateTime.now().toDateTimeShortString()}_${widget.selectedPlan!.name.toLowerCase().replaceAll("  ", " ").replaceAll(" ", "_")}_$i.png');
                              i++;
                            }
                            if (imageData != null) {
                              imageFile.writeAsBytes(imageData!);
                            }
                          }
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
                  ),
                ],
              ),
            ],
          );
        }
        return Center(
          child: Text(
            "No Plan Selected",
            style: waterMarcTextStyle,
          ),
        );
      },
    );
  }
}
