import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';
import 'package:lomp_desktop/widgets.dart';

class ObjectInspector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: objectInspectorBackgroundColor,
            child: IconButton(
              icon: Icon(
                expanded ? Icons.arrow_forward_ios_sharp : Icons.arrow_back_ios_sharp,
                size: 15,
                color: Colors.white,
              ),
              onPressed: () {
                onExpandChange();
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            constraints: BoxConstraints(maxHeight: height),
            height: height,
            width: expanded ? 300 : 5,
            color: objectInspectorBackgroundColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: 300,
                child: Column(
                  children: elementProperties(setElement),
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
            controller: TextEditingController(text: setElement!.notes),
            maxLines: 3,
            decoration: defaultTextFieldDecoration.copyWith(hintText: "Notes"),
            style: textFieldStyle,
            onChanged: (value) {
              setElement!.notes = value;
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
                  colorHistory: selectedPlan != null ? selectedPlan!.colorHistory : [],
                  onColorHistoryChanged: (colorHistory) {
                    onColorHistoryChanged(colorHistory);
                  },
                  initialColor: e.fill,
                  size: const Size(25, 25),
                  onColorChanged: (color) {
                    e.fill = color;
                    onUpdate();
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
                  colorHistory: selectedPlan != null ? selectedPlan!.colorHistory : [],
                  onColorHistoryChanged: (colorHistory) {
                    onColorHistoryChanged(colorHistory);
                  },
                  initialColor: e.outline,
                  size: const Size(25, 25),
                  onColorChanged: (color) {
                    e.outline = color;
                    onUpdate();
                  },
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
    if (setElement == null) return [];
    SetElement e = setElement!;
    List<DataRow> d = [];
    d.addAll(
      [
        DataRow(
          cells: [
            DataCell(_propertyText("Position")),
            DataCell(_propertyText(
                setElement!.position.dx.toStringAsFixed(2) + ", " + setElement!.position.dy.toStringAsFixed(2))),
          ],
        ),
        DataRow(
          cells: [
            DataCell(_propertyText("Angle")),
            DataCell(_propertyText(setElement!.angle.toStringAsFixed(2) + "°")),
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
    return d;
  }

  Widget _propertyText(String text) {
    return Text(
      text,
      style: propertyStyle,
    );
  }
}
