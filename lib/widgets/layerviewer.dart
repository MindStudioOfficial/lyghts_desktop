import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';
import 'package:lomp_desktop/utils.dart';

class LayerViewer extends StatefulWidget {
  final Plan? selectedPlan;
  final Function() onUpdate;
  final Function(SetElement? element) onSetElementSelected;
  const LayerViewer({
    Key? key,
    this.selectedPlan,
    required this.onUpdate,
    required this.onSetElementSelected,
  }) : super(key: key);

  @override
  _LayerViewerState createState() => _LayerViewerState();
}

class _LayerViewerState extends State<LayerViewer> {
  void resetSelected() {
    widget.onSetElementSelected(null);
    for (SetLayer l in widget.selectedPlan!.setLayers) {
      if (l is SetElementLayer) {
        l.selected = false;
        l.element.selected = false;
      }
      if (l is SetGroupLayer) {
        l.selectAll(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedPlan != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: layerViewerBackgroundColor,
            width: 300,
            height: constraints.maxHeight,
            child: ListView.builder(
              itemCount: widget.selectedPlan!.setLayers.length,
              itemBuilder: (context, index) {
                SetLayer layer = widget.selectedPlan!.setLayers[index];
                if (layer is SetElementLayer) {
                  return Container(
                    width: 300,
                    color: layer.element.selected ? layerViewerSelectedColor : layerViewerDeselectedColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              layer.visible = !layer.visible;
                            });
                            widget.onUpdate();
                          },
                          icon: Icon(
                            layer.visible ? Icons.visibility_sharp : Icons.visibility_off_sharp,
                            color: layer.visible ? Colors.white : Colors.grey.shade600,
                            size: 18,
                          ),
                        ),
                        Expanded(
                          child: Listener(
                            onPointerDown: (event) {
                              if (checkBit(event.buttons, 0)) {
                                setState(() {
                                  if (!layer.element.selected) {
                                    resetSelected();
                                    layer.element.selected = true;
                                    widget.onSetElementSelected(layer.element);
                                  } else {
                                    widget.onSetElementSelected(null);
                                    layer.element.selected = false;
                                  }
                                });
                                widget.onUpdate();
                              }
                            },
                            child: Text(
                              layer.element.getDisplayString(),
                              style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (layer is SetGroupLayer) {
                  return Column(
                    children: [
                      Container(
                        width: 300,
                        color: layer.selected ? layerViewerSelectedColor : layerViewerDeselectedColor,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  layer.setVisibility(!layer.visible);
                                  layer.visible = !layer.visible;
                                });
                                widget.onUpdate();
                              },
                              icon: Icon(
                                layer.visible ? Icons.visibility_sharp : Icons.visibility_off_sharp,
                                color: layer.visible ? Colors.white : Colors.grey.shade600,
                                size: 18,
                              ),
                            ),
                            Expanded(
                              child: Listener(
                                onPointerDown: (event) {
                                  if (checkBit(event.buttons, 0)) {
                                    setState(() {
                                      if (!layer.selected) {
                                        for (SetLayer l in widget.selectedPlan!.setLayers) {
                                          if (l is SetGroupLayer) {
                                            l.selectAll(false);
                                          }
                                          l.selected = false;
                                        }
                                      }
                                      layer.selected = !layer.selected;
                                    });
                                    widget.onUpdate();
                                  }
                                },
                                child: Text(
                                  "Group",
                                  style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  layer.expanded = !layer.expanded;
                                });
                              },
                              icon: Icon(
                                layer.expanded ? Icons.expand_less_sharp : Icons.expand_more_sharp,
                                color: layer.visible ? Colors.white : Colors.grey.shade600,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (layer.expanded)
                        Column(
                          children: getLayerChildren(layer, 0),
                        ),
                    ],
                  );
                }
                return Container();
              },
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "No Plan Selected",
          style: defaultTextStyle,
        ),
      );
    }
  }

  List<Widget> getLayerChildren(SetGroupLayer layer, int depth) {
    List<Widget> w = [];

    for (SetLayer l in layer.contents) {
      if (l is SetElementLayer) {
        w.add(
          Container(
            width: 300,
            color: l.element.selected ? layerViewerSelectedColor : layerViewerDeselectedColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: (depth + 1) * 8,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      l.visible = !l.visible;
                    });
                    widget.onUpdate();
                  },
                  icon: Icon(
                    l.visible ? Icons.visibility_sharp : Icons.visibility_off_sharp,
                    color: l.visible ? Colors.white : Colors.grey.shade600,
                    size: 18,
                  ),
                ),
                Expanded(
                  child: Listener(
                    onPointerDown: (event) {
                      if (checkBit(event.buttons, 0)) {
                        setState(() {
                          if (!l.element.selected) {
                            resetSelected();
                            l.element.selected = true;
                            widget.onSetElementSelected(l.element);
                          } else {
                            widget.onSetElementSelected(null);
                            l.element.selected = false;
                          }
                        });
                        widget.onUpdate();
                      }
                    },
                    child: Text(
                      l.element.getDisplayString(),
                      style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (l is SetGroupLayer) {
        w.add(
          Column(
            children: [
              Container(
                width: 300,
                color: l.selected ? layerViewerSelectedColor : layerViewerDeselectedColor,
                child: Row(
                  children: [
                    SizedBox(
                      width: (depth + 1) * 8,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          l.setVisibility(!l.visible);
                          l.visible = !l.visible;
                        });
                        widget.onUpdate();
                      },
                      icon: Icon(
                        l.visible ? Icons.visibility_sharp : Icons.visibility_off_sharp,
                        color: l.visible ? Colors.white : Colors.grey.shade600,
                        size: 18,
                      ),
                    ),
                    Expanded(
                      child: Listener(
                        onPointerDown: (event) {
                          if (checkBit(event.buttons, 0)) {
                            setState(() {
                              if (!l.selected) {
                                for (SetLayer l in widget.selectedPlan!.setLayers) {
                                  if (l is SetGroupLayer) {
                                    l.selectAll(false);
                                  }

                                  l.selected = false;
                                }
                              }
                              l.selected = !l.selected;
                            });
                            widget.onUpdate();
                          }
                        },
                        child: Text(
                          "Group",
                          style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          l.expanded = !l.expanded;
                        });
                      },
                      icon: Icon(
                        l.expanded ? Icons.expand_less_sharp : Icons.expand_more_sharp,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              if (layer.expanded)
                Column(
                  children: getLayerChildren(layer, depth + 1),
                ),
            ],
          ),
        );
      }
    }
    return w;
  }
}
