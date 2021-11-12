import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/widgets.dart';

class ObjectInspector extends StatefulWidget {
  final Alignment alignment;
  final double height;
  final bool expanded;
  final Function() onExpandChange;
  final Function() onUpdate;
  final Function(List<Color> colorHistory) onColorHistoryChanged;
  final SetElement? setElement;
  final Plan? selectedPlan;
  const ObjectInspector({
    Key? key,
    required this.onColorHistoryChanged,
    this.selectedPlan,
    required this.height,
    this.expanded = true,
    required this.alignment,
    required this.onExpandChange,
    required this.setElement,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ObjectInspector> createState() => _ObjectInspectorState();
}

class _ObjectInspectorState extends State<ObjectInspector> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: objectInspectorBackgroundColor,
            child: IconButton(
              icon: Icon(
                widget.expanded ? Icons.arrow_forward_ios_sharp : Icons.arrow_back_ios_sharp,
                size: 15,
                color: Colors.white,
              ),
              onPressed: () {
                widget.onExpandChange();
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            constraints: BoxConstraints(maxHeight: widget.height),
            height: widget.height,
            width: widget.expanded ? 300 : 5,
            color: objectInspectorBackgroundColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: 300,
                child: Column(
                  children: elementProperties(widget.setElement),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> elementProperties(SetElement? e) {
    List<Widget> w = [];
    ScrollController scrollController = ScrollController();

    if (e != null) {
      w.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: TextEditingController(text: widget.setElement!.notes),
            maxLines: 3,
            decoration: defaultTextFieldDecoration.copyWith(hintText: "Notes"),
            style: textFieldStyle,
            onChanged: (value) {
              widget.setElement!.notes = value;
            },
          ),
        ),
      );
      if (e is SetShape) {
        w.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  "Fill:",
                  style: defaultTextStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomColorPicker(
                  colorHistory: widget.selectedPlan != null ? widget.selectedPlan!.colorHistory : [],
                  onColorHistoryChanged: (colorHistory) {
                    widget.onColorHistoryChanged(colorHistory);
                  },
                  initialColor: e.fill,
                  size: const Size(25, 25),
                  onColorChanged: (color) {
                    e.fill = color;
                    widget.onUpdate();
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  "Stroke:",
                  style: defaultTextStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomColorPicker(
                  colorHistory: widget.selectedPlan != null ? widget.selectedPlan!.colorHistory : [],
                  onColorHistoryChanged: (colorHistory) {
                    widget.onColorHistoryChanged(colorHistory);
                  },
                  initialColor: e.outline,
                  size: const Size(25, 25),
                  onColorChanged: (color) {
                    e.outline = color;
                    widget.onUpdate();
                  },
                ),
              ],
            ),
          ),
        );
      }

      if (e is SetLabel) {
        TextEditingController fontSizeController =
            TextEditingController.fromValue(TextEditingValue(text: e.fontSize.toString()));
        w.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomColorPicker(
                  colorHistory: widget.selectedPlan != null ? widget.selectedPlan!.colorHistory : [],
                  onColorHistoryChanged: (colorHistory) {
                    widget.onColorHistoryChanged(colorHistory);
                  },
                  initialColor: e.color,
                  size: const Size(25, 25),
                  onColorChanged: (color) {
                    e.color = color;
                    widget.onUpdate();
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                  onPressed: () {
                    e.bold = !e.bold;
                    widget.onUpdate();
                  },
                  iconSize: 20,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                  icon: Icon(
                    Icons.format_bold_sharp,
                    color: e.bold ? selectedIconColor : defaultIconColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    e.italic = !e.italic;
                    widget.onUpdate();
                  },
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                  iconSize: 20,
                  icon: Icon(
                    Icons.format_italic_sharp,
                    color: e.italic ? selectedIconColor : defaultIconColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    e.underlined = !e.underlined;
                    widget.onUpdate();
                  },
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                  iconSize: 20,
                  icon: Icon(
                    Icons.format_underline_sharp,
                    color: e.underlined ? selectedIconColor : defaultIconColor,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.format_size_sharp,
                  size: 20,
                  color: selectedIconColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 99,
                  child: TextField(
                    controller: fontSizeController,
                    decoration: defaultTextFieldDecoration.copyWith(
                      hintStyle: const TextStyle(fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 1,
                    cursorHeight: 16,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        double? d = double.tryParse(newValue.text);
                        if (d == null) {
                          return oldValue;
                        }
                        d.clamp(1, 2000);
                        return newValue.copyWith(text: d.toStringAsFixed(2));
                      }),
                    ],
                    onEditingComplete: () {
                      double? d = double.tryParse(fontSizeController.text);
                      if (d == null) {
                        e.fontSize = 15;
                      } else {
                        e.fontSize = d;
                      }
                      widget.onUpdate();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }

      w.add(
        Expanded(
          child: Scrollbar(
            hoverThickness: 20,
            thickness: 15,
            controller: scrollController,
            isAlwaysShown: true,
            radius: Radius.zero,
            showTrackOnHover: true,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              child: DataTable(
                headingRowHeight: 40,
                horizontalMargin: 8,
                columns: [
                  DataColumn(
                    label: Text(
                      "Property",
                      style: propertyHeaderStyle,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Value",
                      style: propertyHeaderStyle,
                    ),
                  ),
                ],
                rows: getProperties(),
              ),
            ),
          ),
        ),
      );
    }

    return w;
  }

  List<DataRow> getProperties() {
    if (widget.setElement == null) return [];
    SetElement e = widget.setElement!;
    List<DataRow> d = [];
    d.addAll(
      [
        DataRow(
          cells: [
            DataCell(_propertyText("Position")),
            DataCell(_propertyText(widget.setElement!.position.dx.toStringAsFixed(2) +
                ", " +
                widget.setElement!.position.dy.toStringAsFixed(2))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Angle")),
            DataCell(_propertyText(widget.setElement!.angle.toStringAsFixed(2) + "°")),
          ],
        ),
      ],
    );
    if (e is LightFixture) {
      d.addAll([
        DataRow(
          cells: [
            DataCell(_propertyText("Opening")),
            DataCell(_propertyText((e.opening ?? 45).toStringAsFixed(2) + "°")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Manufacturer")),
            DataCell(_propertyText(e.manufacturer ?? "")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Model")),
            DataCell(_propertyText(e.model ?? "")),
          ],
        ),
      ]);
    }
    if (e is Camera) {
      d.addAll([
        DataRow(
          cells: [
            DataCell(_propertyText("Focal Length")),
            DataCell(_propertyText(e.focalLength!.toStringAsFixed(2) + " mm")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Manufacturer")),
            DataCell(_propertyText(e.manufacturer ?? "")),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Model")),
            DataCell(_propertyText(e.model ?? "")),
          ],
        ),
      ]);
    }
    if (e is SetShape) {
      d.addAll([
        DataRow(
          cells: [
            DataCell(_propertyText("Width")),
            DataCell(_propertyText(e.size.width.toStringAsFixed(2))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Height")),
            DataCell(_propertyText(e.size.height.toStringAsFixed(2))),
          ],
        ),
      ]);
    }
    if (e is SetLabel) {
      d.addAll([
        DataRow(
          cells: [
            DataCell(_propertyText("Width")),
            DataCell(_propertyText(e.size.width.toStringAsFixed(2))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Height")),
            DataCell(_propertyText(e.size.height.toStringAsFixed(2))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Font Size")),
            DataCell(_propertyText(e.fontSize.toStringAsFixed(2))),
          ],
        ),
      ]);
    }
    return d;
  }

  Widget _propertyText(String text) {
    return Text(
      text,
      style: propertyStyle,
    );
  }
}
