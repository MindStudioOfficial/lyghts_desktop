import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

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
  bool bottomHighlighted = false;
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: getLayerChildren(widget.selectedPlan!.setLayers, 0),
              ),
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

  bool removeFromLayers(List<SetLayer> layers, SetLayer layer) {
    for (int i = 0; i < layers.length; i++) {
      SetLayer setLayer = layers[i];
      if (setLayer == layer) {
        if (layers.removeAt(i) == layer) return true;
      } else {
        if (setLayer is SetGroupLayer) {
          if (removeFromLayers(setLayer.contents, layer)) return true;
        }
      }
    }
    return false;
  }

  List<Widget> getLayerChildren(List<SetLayer> layers, int depth) {
    List<Widget> w = [];

    for (int i = 0; i < layers.length; i++) {
      SetLayer l = layers[i];
      w.add(
        DragTarget(
          onWillAccept: (data) => data != null && data is SetLayer,
          onAccept: (data) {
            if (data != null && data is SetLayer) {
              SetLayer receivedLayer = data;
              setState(() {
                l.highlighted = false;
                removeFromLayers(widget.selectedPlan!.setLayers, receivedLayer);
                layers.insert(i, receivedLayer);
              });
              widget.onUpdate();
            }
          },
          onMove: (details) {
            if (!l.highlighted && details.data != null && details.data is SetLayer) {
              setState(() {
                l.highlighted = true;
              });
            }
          },
          onLeave: (data) {
            if (l.highlighted && data != null && data is SetLayer) {
              setState(() {
                l.highlighted = false;
              });
            }
          },
          builder: (context, candidateData, rejectedData) {
            if (l is SetElementLayer) {
              return Draggable(
                dragAnchorStrategy: pointerDragAnchorStrategy,
                data: l,
                child: elementLayerWidget(l, depth, l.highlighted),
                feedback: elementLayerWidget(l, depth, l.highlighted),
                childWhenDragging: const SizedBox(height: 8),
              );
            } else if (l is SetGroupLayer) {
              return Draggable(
                dragAnchorStrategy: pointerDragAnchorStrategy,
                data: l,
                child: groupLayerWidget(l, depth, l.highlighted, l.expanded),
                feedback: groupLayerWidget(l, depth, l.highlighted, false),
                childWhenDragging: const SizedBox(height: 8),
              );
            }
            return Container();
          },
        ),
      );
    }
    w.add(DragTarget(
      onWillAccept: (data) => data != null && data is SetLayer,
      onAccept: (data) {
        if (data != null && data is SetLayer) {
          SetLayer receivedLayer = data;
          setState(() {
            bottomHighlighted = false;
            removeFromLayers(widget.selectedPlan!.setLayers, receivedLayer);
            layers.add(receivedLayer);
          });
          widget.onUpdate();
        }
      },
      onMove: (details) {
        if (!bottomHighlighted && details.data != null && details.data is SetLayer) {
          setState(() {
            bottomHighlighted = true;
          });
        }
      },
      onLeave: (data) {
        if (bottomHighlighted && data != null && data is SetLayer) {
          setState(() {
            bottomHighlighted = false;
          });
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bottomHighlighted)
              Container(
                width: 300,
                height: 4,
                color: Colors.white,
              ),
            Container(
              width: 300,
              height: 100,
              color: Colors.transparent,
            ),
          ],
        );
      },
    ));
    return w;
  }

  Widget groupLayerWidget(SetGroupLayer l, int depth, bool highlighted, bool expanded) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (highlighted && depth == 0)
                Container(
                  width: 300,
                  height: 4,
                  color: Colors.white,
                ),
              Card(
                color: l.selected ? layerViewerSelectedColor : layerViewerDeselectedColor,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                      child: GestureDetector(
                        onTap: () {
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
                        expanded ? Icons.expand_less_sharp : Icons.expand_more_sharp,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (expanded)
          Column(
            children: getLayerChildren(l.contents, depth + 1),
          ),
      ],
    );
  }

  Widget elementLayerWidget(SetElementLayer l, int depth, bool highlighted) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (highlighted)
            Container(
              width: 300,
              height: 4,
              color: Colors.white,
            ),
          Card(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            color: l.element.selected ? layerViewerSelectedColor : layerViewerDeselectedColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: (depth) * 12,
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
                  child: GestureDetector(
                    onTap: () {
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
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                      child: Text(
                        l.element.getDisplayString(),
                        style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
