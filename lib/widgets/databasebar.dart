import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/models/database.dart';
import 'package:string_similarity/string_similarity.dart';

// ignore: must_be_immutable
class DatabaseBar extends StatefulWidget {
  final Alignment alignment;
  final double height;
  final bool expanded;
  final Layers currentLayer;
  final Function(Layers layer) onCurrentLayerChanged;
  final Function() onExpandChange;
  final Function(SetElement? element) onElementSelected;
  bool deselect;
  DatabaseBar({
    Key? key,
    required this.height,
    required this.deselect,
    this.expanded = true,
    required this.alignment,
    required this.onExpandChange,
    required this.currentLayer,
    required this.onCurrentLayerChanged,
    required this.onElementSelected,
  }) : super(key: key);

  @override
  State<DatabaseBar> createState() => _DatabaseBarState();
}

class _DatabaseBarState extends State<DatabaseBar> {
  final Map<Layers, IconData> layerIcons = const {
    Layers.light: Icons.tungsten_sharp,
    //Layers.effector: Icons.reorder_sharp,
    Layers.camera: Icons.videocam_sharp,
    Layers.decoration: Icons.chair_sharp,
    Layers.shape: Icons.category_sharp,
  };

  List<Map<SetElement, double>> sortedList = [];
  TextEditingController searchController = TextEditingController(text: "");

  void updateSortedList(Layers layer) {
    sortedList = [];
    switch (layer) {
      case Layers.light:
        for (LightFixture light in lightFixtureDatabase) {
          sortedList.add({light: light.getSearchString().similarityTo(searchController.text.toLowerCase())});
        }
        break;
      case Layers.camera:
        for (Camera camera in cameraDatabase) {
          sortedList.add({camera: camera.getSearchString().similarityTo(searchController.text.toLowerCase())});
        }
        break;
      case Layers.decoration:
        for (SetDecoration deco in setDecorationDatabse) {
          sortedList.add({deco: deco.getSearchString().similarityTo(searchController.text.toLowerCase())});
        }
        break;
      case Layers.shape:
        for (SetShape shape in setShapeDatabase) {
          sortedList.add({shape: shape.getSearchString().similarityTo(searchController.text.toLowerCase())});
        }
        break;
      default:
        for (LightFixture light in lightFixtureDatabase) {
          sortedList.add({light: light.getSearchString().similarityTo(searchController.text.toLowerCase())});
        }
        break;
    }
    for (var element in sortedList) {
      element.keys.first.selected = false;
    }
    sortedList.sort((a, b) => b.values.first.compareTo(a.values.first));
  }

  @override
  void initState() {
    super.initState();
    updateSortedList(widget.currentLayer);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deselect) {
      updateSortedList(widget.currentLayer);
      widget.deselect = false;
    }
    return Align(
      alignment: widget.alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: databaseBarBackgroundColor,
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
            color: databaseBarBackgroundColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Row(
                      children: layerButtons(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.search_sharp,
                            color: selectedIconColor,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: searchController,
                              decoration: defaultTextFieldDecoration.copyWith(hintText: "Type to Search"),
                              style: textFieldStyle,
                              onChanged: (value) {
                                updateSortedList(widget.currentLayer);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        itemCount: sortedList.length,
                        itemBuilder: (context, index) {
                          SetElement e = sortedList[index].keys.first;

                          return GestureDetector(
                            onTap: () {
                              if (!sortedList[index].keys.first.selected) {
                                for (var element in sortedList) {
                                  element.keys.first.selected = false;
                                }
                                sortedList[index].keys.first.selected = true;
                                widget.onElementSelected(sortedList[index].keys.first);
                              } else {
                                sortedList[index].keys.first.selected = false;
                                widget.onElementSelected(null);
                              }

                              setState(() {});
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(
                                  color: sortedList[index].keys.first.selected ? Colors.white : Colors.transparent,
                                ),
                              ),
                              color: databaseBarCardColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: databaseTextStyle,
                                    children: texts(e),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> layerButtons() {
    List<Widget> w = [];
    layerIcons.forEach((layer, icon) {
      w.add(
        TextButton(
          onPressed: () {
            widget.onCurrentLayerChanged(layer);
            updateSortedList(layer);
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Icon(
              icon,
              size: 25,
              color: widget.currentLayer == layer ? selectedIconColor : defaultIconColor,
            ),
          ),
          style: toolBarButtonStyle(widget.currentLayer == layer),
        ),
      );
    });
    return w;
  }

  List<InlineSpan> texts(SetElement e) {
    if (e is LightFixture) {
      return [
        TextSpan(text: "${e.manufacturer} ", style: databaseManufacturerTextStyle),
        TextSpan(text: "${e.model} ", style: databaseModelTextStyle)
      ];
    }
    if (e is Camera) {
      return [
        TextSpan(text: "${e.manufacturer} ", style: databaseManufacturerTextStyle),
        TextSpan(text: "${e.model} ", style: databaseModelTextStyle)
      ];
    }
    if (e is SetShape) {
      return [
        TextSpan(text: "${e.type.toString().split(".").last} ", style: databaseManufacturerTextStyle),
      ];
    }
    return [TextSpan(text: "${e.notes} ", style: databaseManufacturerTextStyle)];
  }
}
