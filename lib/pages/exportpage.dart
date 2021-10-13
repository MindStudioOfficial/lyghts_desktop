import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/widgets/editcanvas.dart';
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
  double renderPixelRatio = 1;
  bool render = false;
  TextEditingController newImageWidthController = TextEditingController();
  TextEditingController newImageHeightController = TextEditingController();
  Size newImageSize = const Size(0, 0);

  @override
  void initState() {
    super.initState();
    if (widget.selectedPlan != null) {
      newImageSize = widget.selectedPlan!.size;
      newImageWidthController.text = newImageSize.width.toInt().toString();
      newImageHeightController.text = newImageSize.height.toInt().toString();
    }
  }

  @override
  void dispose() {
    newImageHeightController.dispose();
    newImageWidthController.dispose();
    super.dispose();
  }

  Future<bool> captureCanvas() async {
    Uint8List? imageBytes = await widget.screenshotController.capture(
      pixelRatio: renderPixelRatio,
      delay: const Duration(milliseconds: 10),
    );
    if (imageBytes != null) {
      var decodedImage = await decodeImageFromList(imageBytes);
      imageSize = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
      imageData = imageBytes;

      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.selectedPlan != null) {
          if (!render) {
            return Center(
              child: Container(
                color: appBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'w: ${widget.selectedPlan!.size.width.toInt()}px h: ${widget.selectedPlan!.size.height.toInt()}px',
                        style: defaultTextStyle.copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "x " + renderPixelRatio.toStringAsFixed(2).toString(),
                        style: defaultTextStyle.copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "w: ",
                            style: defaultTextStyle.copyWith(fontSize: 25),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: newImageWidthController,
                              decoration: defaultTextFieldDecoration,
                              style: textFieldStyle,
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    int? w = int.tryParse(value);
                                    if (w != null) {
                                      double newh = (w / widget.selectedPlan!.size.aspectRatio).roundToDouble();
                                      newImageSize = Size(w.toDouble(), newh);
                                      renderPixelRatio = w / widget.selectedPlan!.size.width;
                                      newImageHeightController.text = newh.round().toString();
                                    }
                                  }
                                });
                              },
                              inputFormatters: [
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  int? i = int.tryParse(newValue.text);
                                  if (i != null && i > 0 && i < 10000) {
                                    return newValue.copyWith(text: i.toString());
                                  }
                                  if (newValue.text.isEmpty) return newValue;
                                  return oldValue;
                                })
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "h: ",
                            style: defaultTextStyle.copyWith(fontSize: 25),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: newImageHeightController,
                              decoration: defaultTextFieldDecoration,
                              style: textFieldStyle,
                              onEditingComplete: () {},
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    int? h = int.tryParse(value);
                                    if (h != null) {
                                      double neww = (h * widget.selectedPlan!.size.aspectRatio).roundToDouble();
                                      newImageSize = Size(neww, h.toDouble());
                                      renderPixelRatio = h / widget.selectedPlan!.size.height;
                                      newImageWidthController.text = neww.round().toString();
                                    }
                                  }
                                });
                              },
                              inputFormatters: [
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  int? i = int.tryParse(newValue.text);
                                  if (i != null && i > 0 && i < 10000) {
                                    return newValue.copyWith(text: i.toString());
                                  }
                                  if (newValue.text.isEmpty) return newValue;
                                  return oldValue;
                                })
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (newImageWidthController.text.isEmpty) {
                              newImageWidthController.text = newImageSize.width.toInt().toString();
                            }
                            if (newImageHeightController.text.isEmpty) {
                              newImageHeightController.text = newImageSize.height.toInt().toString();
                            }
                            render = true;
                          });
                        },
                        style: iconTextButtonStyle,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Render",
                            style: defaultTextStyle.copyWith(fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return FutureBuilder<bool>(
              future: captureCanvas(),
              builder: (context, snapshot) {
                if ((snapshot.hasData && snapshot.data!) || imageData != null) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Stack(
                      children: [
                        Center(child: Image.memory(Uint8List.fromList(imageData!))),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ExportBar(
                              imageData: imageData!, imageSize: imageSize, planName: widget.selectedPlan!.name),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: appBackgroundColor,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_sharp,
                                color: selectedIconColor,
                              ),
                              iconSize: 25,
                              onPressed: () {
                                setState(() {
                                  render = false;
                                  imageData = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: SizedBox(
                        width: widget.selectedPlan!.size.width,
                        height: widget.selectedPlan!.size.height,
                        child: Center(
                          child: Screenshot(
                            controller: widget.screenshotController,
                            child: EditCanvas(
                              onAbortAddElement: () {},
                              plan: widget.selectedPlan!,
                              selectedDatabaseElement: null,
                              onAddElement: (element) {},
                              selectedTool: EditTools.select,
                              onMoveBlocked: (blocked) {},
                              moveBlocked: false,
                              zoomFac: 1,
                              onSetElementSelected: (element) {},
                              onUpdate: () {},
                              layerVisibility: {for (var element in Layers.values) element: true},
                              rendering: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: appBackgroundDecoration,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          return Center(
            child: Text(
              "No Plan Selected",
              style: waterMarcTextStyle,
            ),
          );
        }
      },
    );
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
    return Container(
      color: appBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.imageSize.width.toInt()} × ${widget.imageSize.height.toInt()}",
              style: defaultTextStyle,
            ),
          ),
          const SizedBox(width: 16),
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
      ),
    );
  }
}
